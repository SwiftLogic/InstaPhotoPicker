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
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - view's LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        view.backgroundColor = .clear
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
    
    // REPLACE THIS
    fileprivate func dequeSmartAlbumCell(for indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    // REPLACE THIS
    fileprivate func dequeUserCreatedAlbumCell(for indexPath: IndexPath) -> AlbumCell {
        
        return AlbumCell()
    }
    
    // REPLACE THIS
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    // REPLACE THIS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // REPLACE THIS
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true)
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return albumSections.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
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


