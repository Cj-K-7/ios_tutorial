//
//  Photo.swift
//  ConquestSwift
//
//  Created by changju.kim on 3/1/24.
//

import Foundation
import SwiftUI

struct GalleryImageView: View {
    let indexNumber: Int
    let url: URL?
    let width: Double
    let height: Double

    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                GalleryImage(url: url, width: width, height: height)
                    .cornerRadius(4.0)
            }
            Text("\(indexNumber)")
                .font(.callout)
                .lineLimit(1)
        }
    }
}

#if DEBUG

struct ImageGridItemView_Previews: PreviewProvider {
    static var previews: some View {
        let url = URL(string: "https://picsum.photos/200/200")
        GalleryImageView(indexNumber: 1, url: url, width: 200, height: 200)
    }
}

#endif
