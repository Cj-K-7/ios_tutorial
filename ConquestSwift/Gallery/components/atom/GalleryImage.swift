//
//  Image.swift
//  ConquestSwift
//
//  Created by changju.kim on 3/5/24.
//

import SwiftUI

struct GalleryImage: View {
    let url: URL?
    let width: Double
    let height: Double
    let placeHolderName = "icon-warning-triangle-solid"

    var body: some View {
        if #available(iOS 15.0, *) {
            AsyncImage(url: url) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                } else if phase.error != nil {
                    Image(placeHolderName)
                        .resizable()
                        .scaledToFill()
                } else {
                    ProgressView()
                }
            }
            .frame(width: width, height: height)
        } else {
            let placholder = UIImage(named: placeHolderName)
            let uiImage = url != nil ? UIImage(contentsOfFile: url!.path) : placholder

            Image(uiImage: uiImage!)
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
        }
    }
}

#if DEBUG
struct GalleryImage_Preview: PreviewProvider {
    struct GalleryImagePreview: View {
        var body: some View {
            GalleryImage(url: URL(string: "https://picsum.photos/200/200"), width: 200, height: 200)
        }
    }

    static var previews: some View {
        GalleryImagePreview()
    }
}
#endif
