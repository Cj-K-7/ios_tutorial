//
//  ToolkitController.swift
//  ConquestSwift
//
//  Created by changju.kim on 2/23/24.
//
import SwiftUI
import UIKit

class ToolkitController: UIViewController {
    var viewModel = ViewModel()

    override func viewDidLoad() {
        var toolkitHostController = UIHostingController(
            rootView: Toolkit(
                model: viewModel,
                onToolPress: { tool in print(tool) }
            )
        )

        addChild(toolkitHostController)
        view.addSubview(toolkitHostController.view)

        toolkitHostController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toolkitHostController.view.topAnchor.constraint(equalTo: view.topAnchor),
            toolkitHostController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolkitHostController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolkitHostController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        toolkitHostController.didMove(toParent: self)
    }

    override func viewDidAppear(_ animated: Bool) {}
}

#if DEBUG

struct ToolkitControllerRepresentable: UIViewControllerRepresentable {
    // update
    // _ uiViewController: UIViewController로 지정
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    // makeui
    func makeUIViewController(context: Context) -> UIViewController {
        // Preview를 보고자 하는 Viewcontroller 이름
        // e.g.)
        return ToolkitController()
    }
}

struct ToolkitController_Previews: PreviewProvider {
    static var previews: some View {
        ToolkitControllerRepresentable()
    }
}

#endif