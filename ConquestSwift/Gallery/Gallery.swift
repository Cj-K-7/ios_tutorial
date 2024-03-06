//
//  Gallery.swift
//  ConquestSwift
//
//  Created by changju.kim on 3/1/24.
//

import SwiftUI

struct Gallery: View {
    @ObservedObject var model: GalleryModel

    @State private var selectedFolder: String = "모든 폴더"

    var leftButton: some View {
        CameraButton {
            print("Camera Button Pressed")
        }
    }

    var body: some View {
        VStack(spacing: 8) {
            GalleryHeader(
                leftButton: leftButton,
                title: selectedFolder
            )
            GalleryImageScrollView(items: model.items)
        }
    }
}

#if DEBUG
struct Gallery_Previews: PreviewProvider {
    struct GalleryPreview: View {
        let model = GalleryModel()

        var body: some View {
            Gallery(model: model)
        }
    }

    static var previews: some View {
        GalleryPreview()
    }
}
#endif

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
