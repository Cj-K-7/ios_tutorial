//
//  CameraButton.swift
//  ConquestSwift
//
//  Created by changju.kim on 3/8/24.
//

import UIKit

class CameraShutter: UIView {
    let layerWidth: CGFloat = 74
    var button = ShutterButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setShape()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setShape()
    }

    private func setShape() {
        backgroundColor = .clear
        layer.cornerRadius = layerWidth / 2
        layer.borderWidth = 5
        layer.borderColor = UIColor.white.cgColor
        clipsToBounds = true

        addButton()
    }

    private func addButton() {
        addSubview(button)

        button.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: button.buttonWidth),
            button.heightAnchor.constraint(equalToConstant: button.buttonWidth)
        ])
    }
}

class ShutterButton: UIButton {
    let buttonWidth: CGFloat = 54

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = .clear
            } else {
                backgroundColor = .white
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setShape()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setShape()
    }

    private func setShape() {
        backgroundColor = .white
        layer.cornerRadius = buttonWidth / 2
        clipsToBounds = true
    }
}
