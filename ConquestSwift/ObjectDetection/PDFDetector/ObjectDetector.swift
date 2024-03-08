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
    private let threshold: Float = 0.3
    private let boundsOffsetX: CGFloat = 10.0
    private let boundsOffsetY: CGFloat = 16.0
    private let minimalPointCount = 20

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

        guard let detectedScores = results.first else { return }
        guard let detectedBoundaries = results.last else { return }

        var scopeBounds: CGRect = .zero
        var bestMarkValue: Float = 0.0
        var bestMarkIndex = 0

        if detectedBoundaries is VNCoreMLFeatureValueObservation {
            guard let output = detectedBoundaries as? VNCoreMLFeatureValueObservation else { return }
            guard let multiArray = output.featureValue.multiArrayValue else { return }

            // (Float32 1 × 37 × 8400)
            let channelCount = multiArray.shape[1].intValue
            let dimensionCount = multiArray.shape[2].intValue

            // find max probability
            var maxProbability: Float = 0.0
            var maxProbabilityIndex = 0
            for j in 0 ... dimensionCount - 2 {
                let currentProbability = multiArray[[0, 4, j] as [NSNumber]].floatValue
                let nextProbability = multiArray[[0, 4, j + 1] as [NSNumber]].floatValue
                let isNextBigger = nextProbability > currentProbability
                let isNextMax = nextProbability > maxProbability
                if isNextBigger {
                    if isNextMax {
                        maxProbabilityIndex = j + 1
                        maxProbability = nextProbability
                        // 0 = xCenter , 1 = yCenter, 2 = height, 3 = width
                        let outputXC = multiArray[[0, 0, maxProbabilityIndex] as [NSNumber]].floatValue
                        let outputYC = multiArray[[0, 1, maxProbabilityIndex] as [NSNumber]].floatValue
                        let outputWidth = multiArray[[0, 2, maxProbabilityIndex] as [NSNumber]].floatValue
                        let outputHeight = multiArray[[0, 3, maxProbabilityIndex] as [NSNumber]].floatValue

                        let x = CGFloat(outputXC) * (160 / layer.bounds.width) - boundsOffsetX
                        let y = CGFloat(outputYC) - boundsOffsetY
                        let width = CGFloat(outputWidth)
                        let height = CGFloat(outputHeight)

                        scopeBounds = CGRect(x: x, y: y, width: height, height: width)
                    }
                }
            }

            for i in 5 ... channelCount - 1 {
                let curentChannelProbability = multiArray[[0, i, maxProbabilityIndex] as [NSNumber]].floatValue
                if curentChannelProbability > bestMarkValue {
                    bestMarkValue = curentChannelProbability
                    bestMarkIndex = i - 5
                }
            }

            let boxLayer = CALayer()
            boxLayer.frame = scopeBounds
            boxLayer.borderWidth = 1
            boxLayer.borderColor = UIColor.white.cgColor
            layer.addSublayer(boxLayer)
        }

        if detectedScores is VNCoreMLFeatureValueObservation {
            guard let output = detectedScores as? VNCoreMLFeatureValueObservation else { return }
            guard let multiArray = output.featureValue.multiArrayValue else { return }
            // (Float32 1 × 32 × 160 × 160)

            let pointsDeimension = getPointsDimension(multiArray, bestMarkIndex, scopeBounds)
            let borderPoints = getBorderPoints(pointsDeimension)

            // at least, minimal points are needed to draw a shape
            if borderPoints.count < minimalPointCount {
                return
            }

            let equalizedPoints = equalizePoints(borderPoints)
            let shapeLayer = drawLayer(equalizedPoints)

            layer.addSublayer(shapeLayer)
        }
    }

    private func getPointsDimension(_ mlMA: MLMultiArray, _ targetChannelIndex: Int, _ bounds: CGRect) -> [[CGPoint]] {
        let outputHeight = mlMA.shape[2].intValue
        let outputWidth = mlMA.shape[3].intValue

        var points: [[CGPoint]] = Array(repeating: Array(repeating: .zero, count: outputWidth), count: outputHeight)

        for y in 0..<outputHeight {
            for x in 0..<outputWidth {
                let score = mlMA[[0, targetChannelIndex, y, x] as [NSNumber]].floatValue
                let outputX = Int(x * Int(layer.frame.width) / outputWidth)
                let outputY = Int(y * Int(layer.frame.height) / outputHeight)
                let targetPoint = CGPoint(x: outputX, y: outputY)

                let isDetected = score > threshold
                let isIntersected = bounds.contains(targetPoint)

                if isDetected, isIntersected {
                    points[y][x] = targetPoint
                }
            }
        }
        return points
    }

    private func sigmoid(_ score: Float) -> Float {
        return 1.0 / (1.0 + exp(score))
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
