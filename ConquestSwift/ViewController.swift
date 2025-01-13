//
//  ViewController.swift
//  ConquestSwift
//
//  Created by changju.kim on 2/21/24.
//
import SwiftUI
import UIKit

class ViewController: UIViewController {
    private let drawingHttp: DrawingHttpService = .init()

    // UIs
    private let page = PageView()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - LifeCycle

extension ViewController {
    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        add(page) { page in
            let constraints = [
                page.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                page.widthAnchor.constraint(equalTo: self.view.widthAnchor),
                page.heightAnchor.constraint(equalTo: self.view.heightAnchor)
            ]

            page.backgroundColor = .gray

            NSLayoutConstraint.activate(constraints)
        }

        Task {
            do {
                let data = try await drawingHttp.get()

                print(data)
            } catch {}
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view.
    }
}

// MARK: - Childs handling

extension ViewController {
    private func add(_ child: UIView, apply: ((UIView) -> Void)?) {
        view.addSubview(child)
        apply?(child)
    }

    private func remove(_ child: UIView) {
        view.willRemoveSubview(child)
        child.removeFromSuperview()
    }

    private func addChildController(_ controller: UIViewController) {
        addChild(controller)
        view.addSubview(controller.view)
        controller.view.frame = view.bounds
        controller.didMove(toParent: self)
    }

    private func removeChildController(_ controller: UIViewController) {
        controller.willMove(toParent: nil)
        controller.view.removeFromSuperview()
        controller.removeFromParent()
    }
}
