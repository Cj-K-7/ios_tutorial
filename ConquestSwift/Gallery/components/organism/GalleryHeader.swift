//
//  GalleryHeader.swift
//  ConquestSwift
//
//  Created by changju.kim on 3/5/24.
//
import SwiftUI

struct GalleryHeader<Content: View>: View {
    var leftButton: Content
    var title: String
    var rightButton: Content?

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            leftButton

            Text(title)
                .frame(minWidth: 176, maxWidth: .infinity)
                .font(.system(size: 16, weight: .bold))
                .multilineTextAlignment(.center)

            if rightButton != nil {
                rightButton
            } else {
                Spacer().frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}

#if DEBUG
struct GalleryHeader_Preview: PreviewProvider {
    struct GalleryHeaderPreview: View {
        var body: some View {
            GalleryHeader(
                leftButton: CameraButton {
                    print("Camera Button Pressed")
                },
                title: "모든 폴더"
            )
        }
    }

    static var previews: some View {
        GalleryHeaderPreview()
    }
}
#endif
