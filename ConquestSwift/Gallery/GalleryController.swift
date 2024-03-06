//
//  GalleryView.swift
//  ConquestSwift
//
//  Created by changju.kim on 3/1/24.
//

import SwiftUI
import UIKit

class GalleryController: UIViewController {}

#if DEBUG
struct GalleryControllerRepresentable: UIViewControllerRepresentable {
    // update
    // _ uiViewController: UIViewController로 지정
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    // makeui
    func makeUIViewController(context: Context) -> UIViewController {
        // Preview를 보고자 하는 Viewcontroller 이름
        // e.g.)
        return GalleryController()
    }
}

struct GalleryController_Previews: PreviewProvider {
    static var previews: some View {
        GalleryControllerRepresentable()
    }
}
#endif
