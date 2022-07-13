//
//  Constants.swift
//  InstaPhotoPicker
//
//  Created by Osaretin Uyigue on 6/30/22.
//

import Photos
import UIKit

extension UIColor {
    static var lineSeperatorColor: UIColor {
        return UIColor.rgb(red: 219, green: 219, blue: 219)
    }
}




/// Responsible for getting a PHAsset's Image from Photo Library via PHImageManager
public func getAssetThumbnail(asset: PHAsset, size: CGSize) -> UIImage? {
    let manager = PHImageManager.default()
    let options = PHImageRequestOptions()
    options.isSynchronous = true
    options.isNetworkAccessAllowed = true
    
    var thumbnail: UIImage?
    manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options) {(imageReturned, info) in
        guard let thumbnailUnwrapped = imageReturned else {return}
        thumbnail = thumbnailUnwrapped
    }
    return thumbnail
}
