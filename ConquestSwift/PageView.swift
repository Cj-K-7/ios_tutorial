//
//  PageView.swift
//  ConquestSwift
//
//  Created by changju.kim on 1/10/25.
//
import UIKit

class PageView: UIImageView {
    var ratio: Double = 0
    var width: Double = 0
    var height: Double = 0 {
        didSet {
            width = height * ratio
            frame.size = CGSize(width: width, height: height)
        }
    }

    init() {
        guard let image = UIImage(named: "page") else {
            fatalError("")
        }
        super.init(image: image)
        ratio = image.size.width / image.size.height
        contentMode = .scaleAspectFit
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("unavailable")
    }
}
