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
    private let threshold = 0.7

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
            detecteds.imageCropAndScaleOption = .scaleFill

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
        if #available(iOS 14.0, *) {
            guard let observation = results.first else { return }
            if observation is VNCoreMLFeatureValueObservation {
                guard let observation = observation as? VNCoreMLFeatureValueObservation else { return }
                let featureValue = observation.featureValue
                guard let multiArray = featureValue.multiArrayValue else { return }

                let outputHeight = multiArray.shape[2].intValue
                let outputWidth = multiArray.shape[3].intValue

                var points: [[CGPoint]] = Array(repeating: Array(repeating: .zero, count: outputWidth), count: outputHeight)

                for y in 0..<outputHeight {
                    for x in 0..<outputWidth {
                        let value = multiArray[[0, 0, y, x] as [NSNumber]].doubleValue
                        let detected = value > threshold

                        let target = CGPoint(x: Int(x * Int(layer.frame.width) / outputWidth), y: Int(y * Int(layer.frame.height) / outputHeight))

                        if detected {
                            points[y][x] = target
                        }
                    }
                }

                let borderPoints = getBorderPoints(points: points)

                // If the border is not a rectangle, return nil
                if borderPoints.count < 3 {
                    return
                }

                let equalizedPoints = equalizePoints(points: borderPoints)
                let minimizedPoints = minimizePoints(points: equalizedPoints)
                let shapeLayer = drawLayer(drawingPoints: minimizedPoints)

                layer.addSublayer(shapeLayer)
            }
        }
    }

    private func getBorderPoints(points: [[CGPoint]]) -> [CGPoint] {
        var topRow = [CGPoint]()
        var rightColumn = [CGPoint]()
        var bottomRow = [CGPoint]()
        var leftColumn = [CGPoint]()
        var borderPoints: [CGPoint] = []

        let nonZeroCallback = { (point: CGPoint) -> Bool in
            point != .zero
        }

        // Top row
        topRow = points[0].filter(nonZeroCallback)

        // Right column
        for i in 1..<points.count - 1 {
            guard let rightPoint = points[i].filter(nonZeroCallback).last else { continue }
            rightColumn.append(rightPoint)
        }

        // Bottom row
        if let bottomPoints = points.last {
            bottomRow = bottomPoints.filter(nonZeroCallback).reversed()
        }

        // Left column
        for i in stride(from: points.count - 2, through: 1, by: -1) {
            guard let leftPoint = points[i].filter(nonZeroCallback).first else { continue }
            leftColumn.append(leftPoint)
        }

        borderPoints = [topRow, rightColumn, bottomRow, leftColumn].flatMap { $0 }

        print("borderPoints: \(borderPoints)")

        return borderPoints
    }

    private func equalizePoints(points: [CGPoint]) -> [CGPoint] {
        let threshold: CGFloat = 4.0 // Define your threshold for "too different"

        var equalizedPoints = points
        var removeTargetIndices: [Int] = []

        for i in 0..<points.count - 1 {
            let currentPoint = points[i]
            let nextPoint = points[i + 1]

            let xDifference = abs(currentPoint.x - nextPoint.x)
            let yDifference = abs(currentPoint.y - nextPoint.y)

            if xDifference > threshold || yDifference > threshold {
                removeTargetIndices.append(i)
            }
        }

        equalizedPoints = equalizedPoints.enumerated().filter { !removeTargetIndices.contains($0.offset) }.map { $0.element }

        return equalizedPoints
    }

    private func minimizePoints(points: [CGPoint]) -> [CGPoint] {
        let minimumDistance: CGFloat = 10.0 // Define your minimum distance

        var filteredPoints: [CGPoint] = [points.first!]

        for point in points.dropFirst() {
            let lastPoint = filteredPoints.last!
            let distance = hypot(point.x - lastPoint.x, point.y - lastPoint.y)

            if distance >= minimumDistance {
                filteredPoints.append(point)
            }
        }

        return filteredPoints
    }

    private func drawLayer(drawingPoints: [CGPoint]) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()

        let path = UIBezierPath()
        path.move(to: drawingPoints[0])
        for i in 1..<drawingPoints.count {
            path.addLine(to: drawingPoints[i])
        }
        path.close()

        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.blue.withAlphaComponent(0.2).cgColor
        shapeLayer.strokeColor = UIColor.blue.cgColor

        return shapeLayer
    }
}
