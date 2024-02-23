//
//  PopUpController.swift
//  page-viewer-swift
//
//  Created by changju.kim on 2/20/24.
//

import UIKit

class PopUpController: UIViewController {
    var contents: UIView? {
        didSet {
            guard let contentsView = contents else { return }
            view.addSubview(contentsView)
        }
    }
}

// MARK: View Life Cycle

extension PopUpController {
    override func loadView() {
        self.view = PopUpView()
    }

    override func viewDidLoad() {
        // memory load
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

extension PopUpController {
    func setContent() {
        view.backgroundColor = .clear
    }
}
