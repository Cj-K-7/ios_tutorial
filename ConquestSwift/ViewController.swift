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

        let pageWidth = pageView.ratio * dumbAssSize.height
        let pageSize = CGSize(width: pageWidth, height: dumbAssSize.height)
        let offserX = (dumbAssSize.width - pageWidth) / 2

        canvasView.offsetX = offserX

        add(pageView) { page in
            page.frame.size = pageSize
            page.center = self.view.center
            page.backgroundColor = .clear
        }

        add(canvasView) { canvas in
            self.view.bringSubviewToFront(canvas)

            canvas.clipsToBounds = false
            canvas.frame.size = pageSize
            canvas.center = self.view.center
            canvas.backgroundColor = .clear
        }

        Task {
            do {
                let data = try await drawingHttp.get(
                    key: "35414&490ee101-19b0-4f8c-8c4e-83d759c955ae&12925-63&1"
                )

                guard let drawingData = data else { return }

                let bookId = drawingData.pageId.split(separator: "-")
                print("asdasdasd \(drawingData)")

//                pageView.setPage(bookId: <#T##String#>, pageIndex: <#T##Int#>)
                canvasView.strokes = drawingData.strokes
                canvasView.setNeedsDisplay()
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                    let updatedData = drawingData.copy(
//                        strokes: self.canvasView.ratioStrokes
//                    )
//
//                    let userDraw = UserDrawingData(userDrawList: [updatedData])
//                    Task {
//                        do {
//                            try await self.drawingHttp.post(data: userDraw)
//                        } catch {
//                            print(error)
//                        }
//                    }
//                    print("userData send")
//                }
            } catch {
                print(error)
            }
        }

        print("view size \(view.frame.size)")

        print("canvas size \(canvasView.frame.size)")
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
