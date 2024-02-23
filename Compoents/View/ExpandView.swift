//
//  FlexView.swift
//  page-viewer-swift
//
//  Created by changju.kim on 2/21/24.
//

import UIKit

class ExpandView: UIView {
    var padding: Padding = .init(0) {
        didSet {
            setPadding()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ExpandView {
    private func expand() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    private func horizontalExpand() {
        autoresizingMask = [.flexibleWidth]
    }

    private func verticalExpand() {
        autoresizingMask = [.flexibleHeight]
    }

    private func setPadding() {
        layoutMargins = padding.value
    }
}
