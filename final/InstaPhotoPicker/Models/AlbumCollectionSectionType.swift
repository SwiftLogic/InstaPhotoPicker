//
//  AlbumCollectionSectionType.swift
//  InstaPhotoPicker
//
//  Created by Osaretin Uyigue on 7/5/22.
//

import UIKit
enum AlbumCollectionSectionType: Int, CustomStringConvertible {
    case /*all,*/ smartAlbums, userCreatedAlbums
    var description: String {
        switch self {
//        case .all: return "All Photos"
        case .smartAlbums: return "Smart Albums"
        case .userCreatedAlbums: return "User Created Albums"
        }
    }
}
