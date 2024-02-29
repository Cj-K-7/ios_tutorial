//
//  Detector.swift
//  ConquestSwift
//
//  Created by changju.kim on 2/29/24.
//

import CoreML
import UIKit
import Vision

class PDFDetector {
    private let cameraQueue = DispatchQueue(label: "cameraQueue")
    var imageVIew: UIImageView!
    var imagePicker = UIImagePickerController()

    init() {
        cameraQueue.async {
            self.loadML()
        }
    }

    func loadML() {
        let modelURL = Bundle.main.url(forResource: "pdfDetector", withExtension: "mlmodelc")
        do {
            let model = try VNCoreMLModel(for:)
            let request = VNCoreMLRequest(model: model, completionHandler: onDetectionComplete)

//            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
//                self?.processObservations(for: request, error: error)
//            })
//            request.imageCropAndScaleOption = .scaleFill
        } catch {
            print("Error: \(error)")
        }
    }

    func onDetectionComplete(request: VNRequest, error: Error?) {
        cameraQueue.async {
            if let results = request.results {
                print(results)
            }
        }
    }
}
