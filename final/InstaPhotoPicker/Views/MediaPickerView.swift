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
    private var allPhotosInSelectedAlbum = PHFetchResult<PHAsset>()
    
        
    
    //Note: using .custom instead of .system for buttonType to stop unwanted UIButton animation on title change...check out https://stackoverflow.com/questions/18946490/how-to-stop-unwanted-uibutton-animation-on-title-change for more info
    fileprivate lazy var albumTitleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Recent", for: .normal)
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
    
    
       
    
    func bindDataFromPhotosLibrary(fetchedAssets: PHFetchResult<PHAsset>, albumTitle: String) {
        allPhotosInSelectedAlbum = fetchedAssets
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .top, animated: false)
        collectionView.reloadData()
        albumTitleButton.setTitle(albumTitle, for: .normal)
        handleAnimateArrow(toIdentity: true)
    }
    
    /// Animates albumTitleButton arrow Imageview
     func handleAnimateArrow(toIdentity: Bool) {
        if toIdentity {
            // on albumVc Dismissal
            albumTitleButton.imageView?.handleRotate180(rotate: false, withDuration: 0.2)
        } else {
            // on albumVc Presentation
            albumTitleButton.imageView?.handleRotate180(rotate: true, withDuration: 0.2)
        }
    }
    
    
    
    //MARK: - Target Selectors
    @objc fileprivate func didTapAlbumTitleButton() {
        delegate?.handleOpenAlbumVC()
        handleAnimateArrow(toIdentity: false)
    }
    
    
    @objc fileprivate func didTapSelectMultiPhotoButton() {
        delegate?.handleBeyondTutScope()
    }
    
}


//MARK: - CollectionView Delegates
extension MediaPickerView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.cellReuseIdentifier, for: indexPath) as! PhotoCell
        cell.bind(asset: allPhotosInSelectedAlbum[indexPath.item])
        return cell
    }


  
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width / 3 - 1
        return .init(width: width, height: width * 1.8)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPhotosInSelectedAlbum.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell else {return}
        let asset = allPhotosInSelectedAlbum[indexPath.item]
        let image = getAssetThumbnail(asset: asset, size: PHImageManagerMaximumSize)
        cell.thumbnailImageView.image = image
        delegate?.handleTransitionToStoriesEditorVC(with: cell.thumbnailImageView)
    }
    
    
    
}
