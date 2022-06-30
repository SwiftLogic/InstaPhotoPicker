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
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    //MARK: - Methods
    fileprivate func setUpViews() {
        addSubview(thumbnailImageView)
        thumbnailImageView.fillSuperview()
        
        thumbnailImageView.backgroundColor = .yellow
    }
}
