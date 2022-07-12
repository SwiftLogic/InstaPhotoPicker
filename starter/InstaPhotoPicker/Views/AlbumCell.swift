//
//  AlbumCell.swift
//  InstaPhotoPicker
//
//  Created by Osaretin Uyigue on 7/5/22.
//

import UIKit
class AlbumCell: UITableViewCell {
    
    
    //MARK: - View's LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        setUpAlbumCoverPlaceHolderImage()
    }
    
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    
    
    //MARK: - Properties
    fileprivate let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    fileprivate let albumTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    
    
    
    //MARK: - Handlers
    fileprivate func setUpViews() {
        backgroundColor = .clear
        selectionStyle = .none
        
        
        addSubview(albumCoverImageView)
        addSubview(albumTitleLabel)
        
        
        let albumCoverImageViewDimen: CGFloat = 35
        albumCoverImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        albumCoverImageView.centerYInSuperview()
        albumCoverImageView.constrainHeight(constant: albumCoverImageViewDimen)
        albumCoverImageView.constrainWidth(constant: albumCoverImageViewDimen)
        albumCoverImageView.layer.cornerRadius = 5
        
        albumTitleLabel.centerYInSuperview()
        albumTitleLabel.leadingAnchor.constraint(equalTo: albumCoverImageView.trailingAnchor, constant: 12).isActive = true
        albumTitleLabel.constrainToRight(paddingRight: -12)

    }
    
    
    
    func bindData(albumTitle: String, albumCoverImage: UIImage?) {
        albumTitleLabel.text = albumTitle
        albumCoverImageView.image = albumCoverImage
        albumCoverImageView.contentMode = .scaleAspectFill
    }
    
    
    /// For when album has no coverImage
    fileprivate func setUpAlbumCoverPlaceHolderImage() {
        albumCoverImageView.image = UIImage(systemName: "photo.on.rectangle.angled")
        albumCoverImageView.tintColor = .gray
        albumCoverImageView.contentMode = .scaleAspectFit
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



