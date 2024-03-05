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
    private let threshold = 0.456

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

                let pointsDeimension = getPointsDimension(multiArray)
                let borderPoints = getBorderPoints(pointsDeimension)

                // at least, 4 points are needed to draw a shape
                if borderPoints.count < 3 {
                    return
                }

                let equalizedPoints = equalizePoints(borderPoints)
                let shapeLayer = drawLayer(equalizedPoints)

                layer.addSublayer(shapeLayer)
            }
        }
    }

    private func getPointsDimension(_ mlMA: MLMultiArray, channel: Int = 0) -> [[CGPoint]] {
        let channelCount = mlMA.shape[1].intValue
        let outputHeight = mlMA.shape[2].intValue
        let outputWidth = mlMA.shape[3].intValue

        var points: [[CGPoint]] = Array(repeating: Array(repeating: .zero, count: outputWidth), count: outputHeight)

        for y in 0..<outputHeight {
            for x in 0..<outputWidth {
                let originValue = mlMA[[0, 0, y, x] as [NSNumber]].doubleValue
                let secondValue = mlMA[[0, 2, y, x] as [NSNumber]].doubleValue
                let thirdValue = mlMA[[0, 4, y, x] as [NSNumber]].doubleValue
                let fourthValue = mlMA[[0, 6, y, x] as [NSNumber]].doubleValue

                let detected =
                    secondValue > threshold
//                        && secondValue > 0.05
//                        && thirdValue > -0.1
//                && fourthValue > threshold
                let target = CGPoint(x: Int(x * Int(layer.frame.width) / outputWidth), y: Int(y * Int(layer.frame.height) / outputHeight))

                if detected {
                    points[y][x] = target
                }
            }
        }
        return points
    }

    private func getBorderPoints(_ pointsDeimension: [[CGPoint]]) -> [CGPoint] {
        var topRow = [CGPoint]()
        var rightColumn = [CGPoint]()
        var bottomRow = [CGPoint]()
        var leftColumn = [CGPoint]()
        var borderPoints: [CGPoint] = []

        let paddingRatio: CGFloat = 0.2
        let minX = layer.bounds.width * paddingRatio
        let maxX = layer.bounds.width - minX
        let minY = layer.bounds.height * paddingRatio
        let maxY = layer.bounds.height - minY

        let filterCallback = { (point: CGPoint) -> Bool in
            point != .zero || (point.x > minX && point.x < maxX) || (point.y > minY && point.y < maxY)
        }

        // Top row
        topRow = pointsDeimension[0].filter(filterCallback)

        // Right column
        for i in 1..<pointsDeimension.count - 1 {
            guard let rightPoint = pointsDeimension[i].filter(filterCallback).last else { continue }
            rightColumn.append(rightPoint)
        }

        // Bottom row
        if let bottomPoints = pointsDeimension.last {
            bottomRow = bottomPoints.filter(filterCallback).reversed()
        }

        // Left column
        for i in stride(from: pointsDeimension.count - 2, through: 1, by: -1) {
            guard let leftPoint = pointsDeimension[i].filter(filterCallback).first else { continue }
            leftColumn.append(leftPoint)
        }

        borderPoints = [topRow, rightColumn, bottomRow, leftColumn].flatMap { $0 }

        return borderPoints
    }

    private func equalizePoints(_ points: [CGPoint]) -> [CGPoint] {
        let distanceThreshold: CGFloat = layer.bounds.width / 160

        var equalizedPoints = points
        var removeTargetIndices: [Int] = []

        var skipNext = false

        for i in 0..<points.count - 1 {
            if skipNext {
                skipNext = false
                continue
            }
            let currentPoint = points[i]
            let nextPoint = points[i + 1]

            let xDifference = abs(currentPoint.x - nextPoint.x)
            let yDifference = abs(currentPoint.y - nextPoint.y)
            let distance = hypot(xDifference, yDifference)

            if distance > distanceThreshold {
                removeTargetIndices.append(i + 1)
                skipNext = true
            }
        }

        equalizedPoints = equalizedPoints.enumerated().filter { !removeTargetIndices.contains($0.offset) }.map { $0.element }

        return equalizedPoints
    }

    private func drawLayer(_ drawingPoints: [CGPoint], color: UIColor = .blue) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()

        let path = UIBezierPath()
        path.move(to: drawingPoints[0])
        for i in 1..<drawingPoints.count {
            path.addLine(to: drawingPoints[i])
        }
        path.close()

        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = color.withAlphaComponent(0.25).cgColor
        shapeLayer.strokeColor = color.cgColor

        return shapeLayer
    }
}
