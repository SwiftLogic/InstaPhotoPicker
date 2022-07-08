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




public func getAssetThumbnail(asset: PHAsset, size: CGSize) -> UIImage? {
    let manager = PHImageManager.default()
    let options = PHImageRequestOptions()
    options.isSynchronous = true
    options.isNetworkAccessAllowed = true
    //        options.version = .original //when turned on it crahes snapseed album when scrolling fast but it also fetches the right orientation of the image
    // the two lines below to fetch higher res images but beware of crashes when the phasset has a high PHImageManagerMaximumSize
    //        options.resizeMode = .exact
    //        options.deliveryMode = .highQualityFormat
    //
    
    var thumbnail: UIImage?
    ///Tested & Proven Bug: - Sometimes when asset mediatype is video, if we request for a PHImageManagerMaximumSize as targetSize of requested image it might return nil image if the video thumbnail is blurry
    manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options) {(imageReturned, info) in
        guard let thumbnailUnwrapped = imageReturned else {return}
        thumbnail = thumbnailUnwrapped
    }
    return thumbnail
}
