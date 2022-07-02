//
//  MediaPickerView.swift
//  InstaPhotoPicker
//
//  Created by Osaretin Uyigue on 6/28/22.
//

import UIKit
import Photos
class MediaPickerView: UIView {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Properties
    weak var delegate: MediaPickerViewDelegate?
    
    
    fileprivate var tempImages = [UIImage]()

    
    fileprivate lazy var albumTitleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Recents", for: .normal)
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold, scale: .medium)
        let image = UIImage(systemName: "chevron.down", withConfiguration:
                                config)?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.semanticContentAttribute = .forceRightToLeft
        button.imageEdgeInsets = .init(top: 2, left: 2, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(didTapAlbumTitleButton), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var selectMultiplePhotosButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select", for: .normal)
        button.setTitleColor(.white, for: .normal)
        let image = UIImage(named: "copy")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.backgroundColor = UIColor.rgb(red: 27, green: 29, blue: 31)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        button.addTarget(self, action: #selector(didTapSelectMultiPhotoButton), for: .touchUpInside)
        return button
    }()
    
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
   
    
    //MARK: - Methods
    fileprivate func setUpViews() {
        
        addSubview(albumTitleButton)
        addSubview(selectMultiplePhotosButton)
        addSubview(collectionView)
        
        // albumTitleLabel layout
        let topPadding: CGFloat = 35
        albumTitleButton.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: topPadding, left: 8, bottom: 0, right: 0), size: .init(width: 0, height: 45))
        
        // selectMultiplePhotosButton layout
        selectMultiplePhotosButton.centerYAnchor.constraint(equalTo: albumTitleButton.centerYAnchor, constant: 0).isActive = true
        selectMultiplePhotosButton.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 6), size: .init(width: 80, height: 30))
        selectMultiplePhotosButton.layer.cornerRadius = 30 / 2
        
        // collectionView layout and registration
        collectionView.anchor(top: albumTitleButton.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.cellReuseIdentifier)
        
        
    }
    
       
    func bindData(images: [UIImage]) {
        tempImages = images
        collectionView.reloadData()
    }
    
    
    
    //MARK: - Target Selectors
    @objc fileprivate func didTapAlbumTitleButton() {
        delegate?.handleOpenAlbumVC()
    }
    
    
    @objc fileprivate func didTapSelectMultiPhotoButton() {
        delegate?.handleBeyondTutScope()
    }
    
}


//MARK: - CollectionView Delegates
extension MediaPickerView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.cellReuseIdentifier, for: indexPath) as! PhotoCell
        cell.bindData(image: tempImages[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width / 3 - 1
        return .init(width: width, height: width * 1.8)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tempImages.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell else {return}
        let imageView = cell.getImageView()
        delegate?.handleTransitionToStoriesEditorVC(with: imageView)
    }
    
}
