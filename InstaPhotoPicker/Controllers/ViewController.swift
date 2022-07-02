//
//  ViewController.swift
//  InstaPhotoPicker
//
//  Created by Osaretin Uyigue on 6/28/22.
//

import UIKit
import Photos

class ViewController: UIViewController {

    
    //MARK: - View's LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setUpViews()
        setUpGestureRecognizers()
        fetchPhotos()
    }

    
    //MARK: - Properties
    fileprivate let zoomNavigationDelegate = ZoomTransitionDelegate()
    fileprivate weak var selectedImageView: UIImageView?
    fileprivate var images = [UIImage]()


    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    fileprivate var mediaPickerViewTopAnchor = NSLayoutConstraint()
    fileprivate let collapsedModePadding = UIScreen.main.bounds.height

    fileprivate lazy var mediaPickerView: MediaPickerView = {
        let mediaPickerView = MediaPickerView()
        mediaPickerView.delegate = self
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
    
    
    
    
    
    
    //MARK: - Photokit
    fileprivate func fetchPhotos() {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 100
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        allPhotos.enumerateObjects({ (asset, count, stop) in
            let imageManager = PHImageManager.default()
            let targetSize = CGSize(width: 350, height: 350)
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                
                if let image = image {
                    self.images.append(image)
                }
                
                if count == allPhotos.count - 1 {
                    self.mediaPickerView.bindData(images: self.images)
                }
                
            })
            
        })
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
    
    
    // Set mediaPickerView back to open or collapsed position 
    fileprivate func onGestureCompletion(gesture: UIPanGestureRecognizer) {
        let yTranslation: CGFloat = gesture.direction(in: view) == .Down ? collapsedModePadding : 0
        
        mediaPickerViewTopAnchor.constant = yTranslation
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.7, options: .curveEaseIn) {[weak self] in
            self?.view.layoutIfNeeded()
        }
    }
        
    
    
    
}





//MARK: - MediaPickerViewDelegate
extension ViewController: MediaPickerViewDelegate {
    
    func handleOpenAlbumVC() {
        let albumVC = AlbumVC()
       albumVC.modalPresentationStyle = .custom
       albumVC.transitioningDelegate = self
       present(albumVC, animated: true, completion: nil)
    }
    
    func handleTransitionToStoriesEditorVC(with selectedImageView: UIImageView) {
        self.selectedImageView = selectedImageView
        navigationController?.delegate = zoomNavigationDelegate
        let storiesEditorVC = StoriesEditorVC(selectedImage: selectedImageView.image ?? UIImage())
       navigationController?.pushViewController(storiesEditorVC, animated: true)
    }
    
    
    
    func handleBeyondTutScope() {
        UIAlertController.show("Beyond the scope of this tutorial", from: self)
    }
}


//MARK: - ZoomViewController Transition Delegates
extension ViewController: ZoomViewController {
    
    func zoomingImageView(for transition: ZoomTransitionDelegate) -> UIImageView? {
        
        if let selectedImageView = selectedImageView {
            return selectedImageView
        } else {
            return UIImageView(frame: CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0))
        }
        
    }
    
    func zoomingBackgroundView(for transition: ZoomTransitionDelegate) -> UIView? {
        return nil
    }

    
}





//MARK: - Presentation Animation for StoriesEditorVC
extension ViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = PresentationController(presentedViewController: presented, presenting: presenting)
        let height = view.frame.height / 2
        presentationController.cardHeight = height
        return presentationController
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



