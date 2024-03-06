//
//  Photo.swift
//  ConquestSwift
//
//  Created by changju.kim on 3/1/24.
//

import SwiftUI

struct GalleryFolerItem: Identifiable, Equatable {
    let id = UUID()
    let title: String
    var items: [GalleryImageItem]

    static func ==(lhs: GalleryFolerItem, rhs: GalleryFolerItem) -> Bool {
        return lhs.id == rhs.id && lhs.id == rhs.id
    }
}

struct GalleryImageItem: Identifiable, Equatable {
    let id = UUID()
    let url: URL?

    static func ==(lhs: GalleryImageItem, rhs: GalleryImageItem) -> Bool {
        return lhs.id == rhs.id && lhs.id == rhs.id
    }
}
