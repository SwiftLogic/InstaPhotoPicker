//
//  CardModalViewController.swift
//  InstaPhotoPicker
//
//  Created by Osaretin Uyigue on 6/30/22.
//


import UIKit
class CardModalViewController: UIViewController {
        
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setUpViews()
        handleSetUpPanGesture()
        
    }
    
    
    
    
    
    //MARK: - Properties
    fileprivate var alertLabelIsVisible = false
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?

    
    fileprivate let navView: UIView = {
        let view = UIView()
        return view
    }()

    
    fileprivate(set) var horizontalBarView: UIView = {
        let view = UIView()
         view.backgroundColor = .lineSeperatorColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 3
        return view
    }()
    
    
    
    
    
    //MARK: - Handlers
    fileprivate func setUpViews() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        view.addSubview(blurEffectView)
        blurEffectView.fillSuperview()
        
        blurEffectView.contentView.addSubview(navView)
        navView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .zero, size: .init(width: view.frame.width, height: 55)) 
        
        navView.addSubview(horizontalBarView)
        horizontalBarView.constrainToTop(paddingTop: 8)
        horizontalBarView.centerXInSuperview()
        horizontalBarView.constrainHeight(constant: 5)
        horizontalBarView.constrainWidth(constant: 40)
    }
    
    
    
    func handleSetUpPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
    }
    
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    
    
    
    
    
    
   
    
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 500 { //1300 S.B
                self.dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {[weak self] in
                    guard let self = self else {return}
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
}





