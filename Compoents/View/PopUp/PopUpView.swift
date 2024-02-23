//
//  PopUpView.swift
//  page-viewer-swift
//
//  Created by changju.kim on 2/21/24.
//

import UIKit

class PopUpView: UIView {
    var padding: Padding = .init(8)

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PopUpView {
    private func setLayout() {
        layoutMargins = padding.value
    }
}
