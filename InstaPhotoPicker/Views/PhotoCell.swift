//
//  PhotoCell.swift
//  InstaPhotoPicker
//
//  Created by Osaretin Uyigue on 6/28/22.
//

import UIKit
class PhotoCell: UICollectionViewCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Properties
    
    static let cellReuseIdentifier = String(describing: PhotoCell.self)
    
    fileprivate let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    
    //MARK: - Methods
    fileprivate func setUpViews() {
        addSubview(thumbnailImageView)
        thumbnailImageView.fillSuperview()
    }
    
    
    func getImageView() -> UIImageView {
        return thumbnailImageView
    }
    
    
    func bindData(image: UIImage) {
        thumbnailImageView.image = image
        getDominantColor(from: image)
    }
    
    
    /// Gets dominant color from image and sets the cell's background color to the retrieved color
   fileprivate  func getDominantColor(from image: UIImage) {
        do {
            try thumbnailImageView.backgroundColor = image.averageColor()
            try backgroundColor = image.averageColor()
        } catch let error {
            print("failed to set background color ", error.localizedDescription)
        }
    }
    
    
}




