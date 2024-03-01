//
//  Photo.swift
//  ConquestSwift
//
//  Created by changju.kim on 3/1/24.
//

import SwiftUI

struct ImageItem: Identifiable, Equatable {
    let id = UUID()
    let url: URL

    static func ==(lhs: ImageItem, rhs: ImageItem) -> Bool {
        return lhs.id == rhs.id && lhs.id == rhs.id
    }
}
