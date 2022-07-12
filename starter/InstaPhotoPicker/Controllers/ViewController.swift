//
//  ViewController.swift
//  InstaPhotoPicker
//
//  Created by Osaretin Uyigue on 6/28/22.
//

import UIKit
import Photos
import PhotosUI
class ViewController: UIViewController {

    
    //MARK: - View's LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setUpViews()
        setUpGestureRecognizers()
        fetchPhotoLibraryAssets()

    }
    
   
    

    
    //MARK: - Properties
   
    
    fileprivate let zoomNavigationDelegate = ZoomTransitionDelegate()
    fileprivate weak var selectedImageView: UIImageView?


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
    
    
    fileprivate lazy var askPhotoPermissionView: AskPhotoPermissionView = {
        let view = AskPhotoPermissionView()
        view.delegate = self
        return view
    }()
    
    
    
    //MARK: - Methods
    fileprivate func setUpViews() {
        view.addSubview(mediaPickerView)
        view.addSubview(askPhotoPermissionView)
        
        mediaPickerViewTopAnchor = mediaPickerView.topAnchor.constraint(equalTo: view.topAnchor, constant: collapsedModePadding)
        mediaPickerViewTopAnchor.isActive = true
        
        mediaPickerView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: view.frame.height))
        
        askPhotoPermissionView.anchor(top: nil, leading: view.leadingAnchor, bottom: mediaPickerView.topAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: view.frame.height))

    }
    
    
    fileprivate func setUpGestureRecognizers() {
        let swipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    
    
    //MARK: - Photokit
   
    fileprivate func getPhotoPermission(completionHandler: @escaping(Bool) -> Void) {
        completionHandler(true)
    }
    
    
    

    
    
    fileprivate func fetchPhotoLibraryAssets() {
        
        
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




//MARK: - AskPhotoPermissionViewDelegate
extension ViewController: AskPhotoPermissionViewDelegate {
    
    func handleAskForPhotoPermission() {
        // On button tap, we ask for auth to access photos library and if granted we fetchPhotos
        getPhotoPermission { [weak self] granted  in
            if granted {
                self?.fetchPhotoLibraryAssets()
            }
        }
    }
        
}


//MARK: - MediaPickerViewDelegate & AlbumVCDelegate & PHPickerViewControllerDelegate
extension ViewController: MediaPickerViewDelegate, AlbumVCDelegate, PHPickerViewControllerDelegate {
    
    //MARK: - MediaPickerViewDelegate
    func handleOpenAlbumVC() {
        let albumVC = AlbumVC(smartAlbums: [], userCreatedAlbums: PHFetchResult<PHAssetCollection>())
       albumVC.modalPresentationStyle = .custom
       albumVC.transitioningDelegate = self
       albumVC.delegate = self
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
    
    
    
    //MARK: - AlbumVCDelegate
    func handleDidSelect(smartAlbum: PHAssetCollection) {
        
    }
    
    
    func handleOnDismiss() {
        mediaPickerView.handleAnimateArrow(toIdentity: true)
    }
    
    
    func handlePresentPHPickerViewController() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
            configuration.selectionLimit = 10
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    
    
    //MARK: - PHPickerViewControllerDelegate
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        let identifiers = results.compactMap(\.assetIdentifier)
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
        DispatchQueue.main.async {
            self.mediaPickerView.bindDataFromPhotosLibrary(fetchedAssets: fetchResult, albumTitle: "Search Result")
        }
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





//MARK: - PHPhotoLibraryChangeObserver

