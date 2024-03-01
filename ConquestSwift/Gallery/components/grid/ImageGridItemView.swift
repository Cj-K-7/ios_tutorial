//
//  Photo.swift
//  ConquestSwift
//
//  Created by changju.kim on 3/1/24.
//

import Foundation
import SwiftUI

struct ImageGridItemView: View {
    let url: URL?
    let size: Double

    var body: some View {
        ZStack(alignment: .topTrailing) {
            if #available(iOS 15.0, *) {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                    } else if phase.error != nil {
                        Image("icon-warning-triangle-solid")
                            .resizable()
                            .scaledToFill()
                    } else {
                        ProgressView()
                    }
                }
                .frame(width: size, height: size)
            } else {
                let placholder = UIImage(named: "icon-warning-triangle-solid")
                let uiImage = url != nil ? UIImage(contentsOfFile: url!.path) : placholder

                Image(uiImage: uiImage!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
            }
        }
    }
}

#if DEBUG

struct ImageGridItemView_Previews: PreviewProvider {
    static var previews: some View {
        let url = URL(string: "https://picsum.photos/200/200")
        ImageGridItemView(url: url, size: 50)
    }
}

#endif
