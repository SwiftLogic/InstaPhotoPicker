//
//  MediaPickerView.swift
//  InstaPhotoPicker
//
//  Created by Osaretin Uyigue on 6/28/22.
//

import UIKit
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
    fileprivate let albumTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Recents"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    fileprivate let selectMultiplePhotosButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select", for: .normal)
        button.setTitleColor(.white, for: .normal)
        let image = UIImage(named: "copy")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.backgroundColor = UIColor.rgb(red: 27, green: 29, blue: 31)
        return button
    }()
    
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    
    //MARK: - Methods
    fileprivate func setUpViews() {
        addSubview(albumTitleLabel)
        addSubview(selectMultiplePhotosButton)
        addSubview(collectionView)
        
        // albumTitleLabel anchors
        let topPadding: CGFloat = 35
        albumTitleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: topPadding, left: 6, bottom: 0, right: 0), size: .init(width: 0, height: 45))
        
        // selectMultiplePhotosButton anchors
        selectMultiplePhotosButton.centerYAnchor.constraint(equalTo: albumTitleLabel.centerYAnchor, constant: 0).isActive = true
        selectMultiplePhotosButton.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 6), size: .init(width: 80, height: 30))
        selectMultiplePhotosButton.layer.cornerRadius = 30 / 2
        
        // collectionView anchors and registration
        collectionView.anchor(top: albumTitleLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.cellReuseIdentifier)
    }
    
    
    
    
}



extension MediaPickerView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.cellReuseIdentifier, for: indexPath) as! PhotoCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width / 3 - 1
        return .init(width: width, height: width * 2)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}
