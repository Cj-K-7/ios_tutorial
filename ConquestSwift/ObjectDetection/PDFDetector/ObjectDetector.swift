//
//  Detector.swift
//  ConquestSwift
//
//  Created by changju.kim on 2/29/24.
//

import CoreML
import UIKit
import Vision

class ObjectDetector {
    var requests = [VNRequest]()
    var layer: CALayer

    init() {
        layer = CALayer()
    }

    func loadML() {
        let modelURL = Bundle.main.url(forResource: "pdfDetector", withExtension: "mlmodelc")

        do {
            let model = try VNCoreMLModel(for: MLModel(contentsOf: modelURL!))
            let detecteds = VNCoreMLRequest(model: model, completionHandler: onDetectionComplete)

            requests = [detecteds]

        } catch {
            print("Error: \(error)")
        }
    }

    func unloadML() {
        requests = []
        layer.sublayers = nil
    }

    private func onDetectionComplete(request: VNRequest, error: Error?) {
        DispatchQueue.main.sync {
            if let results = request.results {
                onDetectedConditionFullfilled(results)
            }
        }
    }

    private func onDetectedConditionFullfilled(_ results: [VNObservation]) {
        layer.sublayers = nil
        print("VNObservation: \(results.count)")

        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else { continue }

            // Transformations
            let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(layer.bounds.width), Int(layer.bounds.height))
            let transformedBounds = CGRect(x: objectBounds.minX, y: layer.bounds.height - objectBounds.maxY, width: objectBounds.maxX - objectBounds.minX, height: objectBounds.maxY - objectBounds.minY)

            let boxLayer = CALayer()
            boxLayer.frame = objectBounds
            boxLayer.borderWidth = 3.0
            boxLayer.borderColor = CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            boxLayer.cornerRadius = 4

            layer.addSublayer(boxLayer)
        }
    }
}
