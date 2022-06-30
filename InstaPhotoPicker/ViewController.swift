//
//  ViewController.swift
//  InstaPhotoPicker
//
//  Created by Osaretin Uyigue on 6/28/22.
//

import UIKit

class ViewController: UIViewController {

    
    //MARK: - View's LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setUpViews()
        setUpGestureRecognizers()
    }

    
    //MARK: - Properties
    fileprivate var mediaPickerViewTopAnchor = NSLayoutConstraint()
    fileprivate let collapsedModePadding = UIScreen.main.bounds.height

    fileprivate lazy var mediaPickerView: MediaPickerView = {
        let mediaPickerView = MediaPickerView()
        mediaPickerView.backgroundColor = .red
        return mediaPickerView
    }()
    
    
    
    
    
    //MARK: - Methods
    fileprivate func setUpViews() {
        view.addSubview(mediaPickerView)
        
        mediaPickerViewTopAnchor = mediaPickerView.topAnchor.constraint(equalTo: view.topAnchor, constant: collapsedModePadding)
        mediaPickerViewTopAnchor.isActive = true
        
        mediaPickerView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: view.frame.height))

    }
    
    
    fileprivate func setUpGestureRecognizers() {
        let swipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    
    
    
    //MARK: - Target Selectors
    @objc fileprivate func panGestureRecognizerAction(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .changed:
            
            let translatedYPoint = translation.y
            
            if mediaPickerViewTopAnchor.constant < 0 {
                mediaPickerViewTopAnchor.constant = 0
            } else {
                mediaPickerViewTopAnchor.constant += translatedYPoint
            }
            
            gesture.setTranslation(.zero, in: view)

        case .failed, .cancelled, .ended:
            
           onGestureCompletion(gesture: gesture)
         default:
            break
        }
        
    }
    
    
    fileprivate func onGestureCompletion(gesture: UIPanGestureRecognizer) {
        let yTranslation: CGFloat = gesture.direction(in: view) == .Down ? collapsedModePadding : 0
        
        mediaPickerViewTopAnchor.constant = yTranslation
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.7, options: .curveEaseIn) {[weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    
    

}




#if canImport(SwiftUI) && DEBUG
import SwiftUI

let deviceNames: [String] = [
    "iPhone SE (3rd generation)"
]

@available(iOS 13.0, *)
struct ViewController_Preview: PreviewProvider {
    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            UIViewControllerPreview {
                ViewController()
            }.previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
#endif



/// For detecting pan Gesture direction
extension UIPanGestureRecognizer {
    
    public struct PanGestureDirection: OptionSet {
        public let rawValue: UInt8

        public init(rawValue: UInt8) {
            self.rawValue = rawValue
        }

        static let Up = PanGestureDirection(rawValue: 1 << 0)
        static let Down = PanGestureDirection(rawValue: 1 << 1)
        static let Left = PanGestureDirection(rawValue: 1 << 2)
        static let Right = PanGestureDirection(rawValue: 1 << 3)
    }

    /// For detecting pan Gesture direction
    public func direction(in view: UIView) -> PanGestureDirection {
        let velocity = self.velocity(in: view)
        let isVerticalGesture = abs(velocity.y) > abs(velocity.x)
        if isVerticalGesture {
            return velocity.y > 0 ? .Down : .Up
        } else {
            return velocity.x > 0 ? .Right : .Left
        }
    }
}
