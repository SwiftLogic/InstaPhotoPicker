//
//  Protocols.swift
//  InstaPhotoPicker
//
//  Created by Osaretin Uyigue on 6/30/22.
//

import UIKit


//MARK: - MediaPickerViewDelegate
protocol MediaPickerViewDelegate: AnyObject {
    func handleOpenAlbumVC()
    func handleBeyondTutScope()
    func handleTransitionToStoriesEditorVC(with selectedImageView: UIImageView)
}
