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
    let dumbAssSize = CGSize(width: 834.24, height: 632)

    // UIs
    private let pageView = PageView()
    private let canvasView = CanvasView()

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

        add(pageView) { page in
            page.frame.size = self.dumbAssSize
            page.backgroundColor = .clear
        }

        add(canvasView) { canvas in
            self.view.bringSubviewToFront(canvas)

            canvas.frame.size = self.dumbAssSize
            canvas.backgroundColor = .clear
        }

        Task {
            do {
                let data = try await drawingHttp.get(key: "1014&b6e122bb-aa46-4b75-8581-43e3d0fd2604&1844-1&1")

                guard let strokes = data?.strokes else { return }
                canvasView.strokes = strokes
                canvasView.setNeedsDisplay()

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
