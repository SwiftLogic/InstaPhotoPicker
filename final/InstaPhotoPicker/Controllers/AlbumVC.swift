//
//  AlbumVC.swift
//  InstaPhotoPicker
//
//  Created by Osaretin Uyigue on 6/30/22.
//

import UIKit
fileprivate let tableViewCellIdentifier = "CardModalViewController-tableViewCellIdentifier"
class AlbumVC: CardModalViewController {
    
    
    //MARK: - view's LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        view.backgroundColor = .clear
    }
    
    
    
    
    
    //MARK: - Properties
    fileprivate let smartAlbums = [SmartAlbum(albumName: "Search", imageName: "magnifyingglass"),
                                  SmartAlbum(albumName: "Recents", imageName: "clock"),
                                  SmartAlbum(albumName: "Favorites", imageName: "heart"),
                                  SmartAlbum(albumName: "Videos", imageName: "play.circle"),
                                  SmartAlbum(albumName: "Screenshots", imageName: "iphone")
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
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.alwaysBounceVertical = true
    }
    
}



//MARK: - TableView Protocols
extension AlbumVC: UITableViewDelegate, UITableViewDataSource {
    
    
    fileprivate func setUpCellConfig(cell: UITableViewCell, indexPath: IndexPath) {
        let album = smartAlbums[indexPath.row]
        var contentConfig = cell.defaultContentConfiguration()
        contentConfig.text = album.albumName
        
        let config = UIImage.SymbolConfiguration(pointSize: 15, weight: .semibold, scale: .large)
        let image = UIImage(systemName: album.imageName, withConfiguration:
                                config)?.withRenderingMode(.alwaysTemplate)

        contentConfig.image = image
        contentConfig.imageProperties.tintColor = .white
        contentConfig.textProperties.color = .white
        contentConfig.imageToTextPadding = 12
        cell.contentConfiguration = contentConfig
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        setUpCellConfig(cell: cell, indexPath: indexPath)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return smartAlbums.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}


struct SmartAlbum {
    let albumName, imageName: String
}
