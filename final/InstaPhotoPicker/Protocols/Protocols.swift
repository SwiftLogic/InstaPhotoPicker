//
//  Protocols.swift
//  InstaPhotoPicker
//
//  Created by Osaretin Uyigue on 6/30/22.
//

import UIKit
import Photos

//MARK: - MediaPickerViewDelegate
protocol MediaPickerViewDelegate: AnyObject {
    func handleOpenAlbumVC()
    func handleBeyondTutScope()
    func handleTransitionToStoriesEditorVC(with selectedImageView: UIImageView)
}



//MARK: - AskPhotoPermissionViewDelegate
protocol AskPhotoPermissionViewDelegate: AnyObject {
    func handleAskForPhotoPermission()
}


//MARK: - AlbumVCDelegate
protocol AlbumVCDelegate: AnyObject {
    func handleDidSelect(smartAlbum: PHAssetCollection)
    func handlePresentPHPickerViewController()
    func handleOnDismiss()
}
