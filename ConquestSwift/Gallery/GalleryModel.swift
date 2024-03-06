//
//  GalleryModel.swift
//  ConquestSwift
//
//  Created by changju.kim on 3/1/24.
//

import Foundation

class GalleryModel: ObservableObject {
    @Published var items: [GalleryImageItem] = [
        GalleryImageItem(url: URL(string: "https://picsum.photos/200/200")),
        GalleryImageItem(url: URL(string: "https://picsum.photos/200/200")),
        GalleryImageItem(url: URL(string: "https://picsum.photos/200/200")),
        GalleryImageItem(url: URL(string: "https://picsum.photos/200/200")),
        GalleryImageItem(url: URL(string: "https://picsum.photos/200/200")),
        GalleryImageItem(url: URL(string: "https://picsum.photos/200/200")),
        GalleryImageItem(url: URL(string: "https://picsum.photos/200/200")),
        GalleryImageItem(url: URL(string: "https://picsum.photos/200/200")),
        GalleryImageItem(url: URL(string: "https://picsum.photos/200/200")),
        GalleryImageItem(url: URL(string: "https://picsum.photos/200/200")),
        GalleryImageItem(url: URL(string: "https://picsum.photos/200/200")),
        GalleryImageItem(url: URL(string: "https://picsum.photos/200/200")),
    ]

    init() {
        if let urls = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: nil) {
            for url in urls {
                let item = GalleryImageItem(url: url)
                items.append(item)
            }
        }
    }

    /// Adds an item to the data collection.
    func addItem(_ item: GalleryImageItem) {
        items.insert(item, at: 0)
    }

    func addItems(_ items: [GalleryImageItem]) {
        self.items.insert(contentsOf: items, at: 0)
    }

    /// Removes an item from the data collection.
    func removeItem(_ item: GalleryImageItem) {
        if let index = items.firstIndex(of: item) {
            items.remove(at: index)
        }
    }

    /// Removes all items from the data collection.
    func removeAll() {
        items.removeAll()
    }
}

extension URL {
    /// Indicates whether the URL has a file extension corresponding to a common image format.
    var isImage: Bool {
        let imageExtensions = ["jpg", "jpeg", "png", "gif", "heic"]
        return imageExtensions.contains(pathExtension)
    }
}
