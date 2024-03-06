//
//  GridScrollView.swift
//  ConquestSwift
//
//  Created by changju.kim on 3/5/24.
//

import SwiftUI

struct GalleryImageScrollView: View {
    var items: [GalleryImageItem]

    private let numColumns = 2
    private let horizontalSpacing: CGFloat = 10
    private let horizontalPadding: CGFloat = 20
    private let verticalSpacing: CGFloat = 10
    private let verticalPadding: CGFloat = 20

    private func row(for index: Int, itemWidth: CGFloat) -> some View {
        HStack(alignment: .top, spacing: horizontalSpacing) {
            ForEach(0 ..< self.numColumns, id: \.self) { column in
                let itemIndex = index + column
                if let item = self.items[safe: itemIndex] {
                    GalleryImageView(
                        indexNumber: itemIndex + 1,
                        url: item.url,
                        width: itemWidth,
                        height: itemWidth * (16 / 9)
                    )
                } else {
                    Text("Asd")
                    // TODO: add item
                    Spacer()
                }
            }
        }
    }

    var body: some View {
        GeometryReader { geometry in
            let wholeWidth = geometry.size.width - horizontalSpacing - horizontalPadding * 2
            let itemWidth = wholeWidth / CGFloat(self.numColumns)
            ScrollView {
                VStack(alignment: .center, spacing: verticalSpacing) {
                    if items.count >= 1 {
                        ForEach(0 ..< self.items.count, id: \.self) { index in
                            if index % self.numColumns == 0 {
                                self.row(for: index, itemWidth: itemWidth)
                            }
                        }
                    } else {
                        Text("No Images")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
            }
        }
    }
}

#if DEBUG
struct GridScrollView_Preview: PreviewProvider {
    struct GridScrollViewPreview: View {
        var body: some View {
            GalleryImageScrollView(items: [
                GalleryImageItem(url: URL(string: "https://picsum.photos/200/200")),
                GalleryImageItem(url: URL(string: "https://picsum.photos/200/200")),
                GalleryImageItem(url: URL(string: "https://picsum.photos/200/200")),
                GalleryImageItem(url: URL(string: "https://picsum.photos/200/200")),
                GalleryImageItem(url: URL(string: "https://picsum.photos/200/200")),
                GalleryImageItem(url: URL(string: "https://picsum.photos/200/200")),
                GalleryImageItem(url: URL(string: "https://picsum.photos/200/200")),

            ])
        }
    }

    static var previews: some View {
        GridScrollViewPreview()
    }
}
#endif
