//
//  Padding.swift
//  page-viewer-swift
//
//  Created by changju.kim on 2/20/24.
//

import UIKit

class Padding {
    var top: CGFloat {
        didSet {
            self.value.top = self.top
        }
    }

    var left: CGFloat {
        didSet {
            self.value.left = self.left
        }
    }

    var bottom: CGFloat {
        didSet {
            self.value.bottom = self.bottom
        }
    }

    var right: CGFloat {
        didSet {
            self.value.right = self.right
        }
    }

    var value: UIEdgeInsets {
        get {
            return UIEdgeInsets(top: self.top, left: self.left, bottom: self.bottom, right: self.right)
        }
        set {
            self.top = newValue.top
            self.left = newValue.left
            self.bottom = newValue.bottom
            self.right = newValue.right
        }
    }

    init(_ value: CGFloat = 8.0) {
        self.top = value
        self.left = value
        self.bottom = value
        self.right = value
    }

    public func set(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> Padding {
        self.top = top
        self.left = left
        self.bottom = bottom
        self.right = right

        return self
    }

    public func setTop(_ value: CGFloat) -> Padding {
        self.top = value

        return self
    }

    public func setLeft(_ value: CGFloat) -> Padding {
        self.left = value

        return self
    }

    public func setBottom(_ value: CGFloat) -> Padding {
        self.bottom = value

        return self
    }

    public func setRight(_ value: CGFloat) -> Padding {
        self.right = value

        return self
    }

    public func setHorizontal(_ value: CGFloat) -> Padding {
        self.left = value
        self.right = value

        return self
    }

    public func setVertical(_ value: CGFloat) -> Padding {
        self.top = value
        self.bottom = value

        return self
    }
}
