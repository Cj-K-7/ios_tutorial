//
//  PageView.swift
//  ConquestSwift
//
//  Created by changju.kim on 1/10/25.
//
import UIKit

class PageView: UIImageView {
    init() {
        super.init(image: UIImage(named: "page"))
        self.contentMode = .scaleAspectFit
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("unavailable")
    }
}
