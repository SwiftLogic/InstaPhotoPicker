//
//  AlbumVC.swift
//  InstaPhotoPicker
//
//  Created by Osaretin Uyigue on 6/30/22.
//

import UIKit
import Photos
fileprivate let smartAlbumCellIdentifier = "smartAlbumCellIdentifier"
fileprivate let userCreatedAlbumCellIdentifier = "userCreatedAlbumCellIdentifier"
class AlbumVC: CardModalViewController {
    
    
    //MARK: - Init
    init(smartAlbums: [PHAssetCollection] = [],
         userCreatedAlbums: PHFetchResult<PHAssetCollection> = PHFetchResult<PHAssetCollection>()) {
        self.smartAlbums = smartAlbums
        self.userCreatedAlbums = userCreatedAlbums
        super.init(nibName: nil, bundle: nil)
    }
    
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - view's LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        view.backgroundColor = .clear
        
        let authStatus = PHPhotoLibrary.authorizationStatus()
        if authStatus ==  .authorized || authStatus == .limited {
            PHPhotoLibrary.shared().register(self)
        }
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.handleOnDismiss()
    }
    
    
    
    //MARK: - Properties
    weak var delegate: AlbumVCDelegate?
    
    fileprivate var albumSections: [AlbumCollectionSectionType] = [.smartAlbums, .userCreatedAlbums]
    fileprivate var smartAlbums: [PHAssetCollection]
    fileprivate var userCreatedAlbums: PHFetchResult<PHAssetCollection>
    

    fileprivate lazy var smartAlbumSection = [SmartAlbumItem(albumName: "Search", imageName: "magnifyingglass"),
                                                   SmartAlbumItem(albumName: "Recents", imageName: "clock", collection: smartAlbums[0]),
                                                   SmartAlbumItem(albumName: "Favorites", imageName: "heart", collection: smartAlbums[1]),
                                                   SmartAlbumItem(albumName: "Videos", imageName: "play.circle", collection: smartAlbums[2]),
                                                   SmartAlbumItem(albumName: "Screenshots", imageName: "iphone", collection: smartAlbums[3])
    ]
    
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    
    
    
    //MARK: - Methods
    fileprivate func setUpTableView() {
        view.addSubview(tableView)
        tableView.anchor(top: horizontalBarView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 25, left: 0, bottom: 0, right: 0))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: smartAlbumCellIdentifier)
        tableView.register(AlbumCell.self, forCellReuseIdentifier: userCreatedAlbumCellIdentifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.alwaysBounceVertical = true
    }
    
    
}



//MARK: - TableView Protocols
extension AlbumVC: UITableViewDelegate, UITableViewDataSource {
    
    
    fileprivate func dequeSmartAlbumCell(for indexPath: IndexPath) -> UITableViewCell {
        // cell dequeing
         let smartAlbumCell = tableView.dequeueReusableCell(withIdentifier: smartAlbumCellIdentifier, for: indexPath)
         smartAlbumCell.backgroundColor = .clear
         smartAlbumCell.selectionStyle = .none
        
        // configuring SmartAlbumCell's UI and data binding
        let album = smartAlbumSection[indexPath.row]
        var contentConfig = smartAlbumCell.defaultContentConfiguration()
        contentConfig.text = album.albumName
        
        let config = UIImage.SymbolConfiguration(pointSize: 15, weight: .semibold, scale: .large)
        let image = UIImage(systemName: album.imageName, withConfiguration:
                                config)?.withRenderingMode(.alwaysTemplate)

        contentConfig.image = image
        contentConfig.imageProperties.tintColor = .white
        contentConfig.textProperties.color = .white
        contentConfig.imageToTextPadding = 12
        smartAlbumCell.contentConfiguration = contentConfig
        
         return smartAlbumCell
     }
     
     
     
     fileprivate func dequeUserCreatedAlbumCell(for indexPath: IndexPath) -> AlbumCell {
         
         // cell dequeing
         let userCreatedAlbumCell = tableView.dequeueReusableCell(withIdentifier: userCreatedAlbumCellIdentifier, for: indexPath) as! AlbumCell
         userCreatedAlbumCell.backgroundColor = .clear
         userCreatedAlbumCell.selectionStyle = .none
         
         // cell data binding
         var coverAsset: PHAsset?
         let collection = userCreatedAlbums[indexPath.item]
         let fetchOptions = PHFetchOptions()
         fetchOptions.fetchLimit = 1
         let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
         fetchOptions.sortDescriptors = [sortDescriptor]
         
         let fetchedAssets = PHAsset.fetchAssets(in: collection, options: fetchOptions)
         coverAsset = fetchedAssets.firstObject
         guard let asset = coverAsset else { return userCreatedAlbumCell }
         
         let coverImage = getAssetThumbnail(asset: asset, size: userCreatedAlbumCell.bounds.size)
         userCreatedAlbumCell.bindData(albumTitle: collection.localizedTitle ?? "", albumCoverImage: coverImage)
         
         return userCreatedAlbumCell
     }
     
     

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = albumSections[indexPath.section]
        switch sectionType {
        case .smartAlbums:
            let smartAlbumCell = dequeSmartAlbumCell(for: indexPath)
            return smartAlbumCell
        case  .userCreatedAlbums:
            let userCreatedAlbumCell = dequeUserCreatedAlbumCell(for: indexPath)
            return userCreatedAlbumCell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch albumSections[indexPath.section] {
        case .smartAlbums:
            
            if let smartAlbum = smartAlbumSection[indexPath.row].collection {
                delegate?.handleDidSelect(smartAlbum: smartAlbum)
            } else {
                delegate?.handlePresentPHPickerViewController()
            }
            
            dismiss(animated: true)
            
        case .userCreatedAlbums:
            delegate?.handleDidSelect(smartAlbum: userCreatedAlbums[indexPath.row])
            dismiss(animated: true)
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return albumSections.count
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch albumSections[section] {
        case .smartAlbums: return smartAlbumSection.count
        case .userCreatedAlbums: return userCreatedAlbums.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        // Gets the header view as a UITableViewHeaderFooterView and changes the text colour and adds above blur effect
        let headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        headerView.textLabel!.textColor = UIColor.white
        headerView.textLabel!.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        headerView.tintColor = .clear
        headerView.backgroundView = blurEffectView
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch albumSections[section] {
        case .smartAlbums: return ""
        case .userCreatedAlbums: return "My albums"
        }
    }
    
}



//MARK: - PHPhotoLibraryChangeObserver
extension AlbumVC: PHPhotoLibraryChangeObserver  {
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
            if let changeDetails = changeInstance.changeDetails(for: self.userCreatedAlbums) {
                self.userCreatedAlbums = changeDetails.fetchResultAfterChanges
            }
            self.tableView.reloadData()
        }
    }
    
}
