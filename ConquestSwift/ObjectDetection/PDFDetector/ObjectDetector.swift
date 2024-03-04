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

//                guard let image = createImage(from: multiArray) else { return }

                let height = multiArray.shape[2].intValue
                let width = multiArray.shape[3].intValue

                var points: [[CGPoint]] = Array(repeating: Array(repeating: CGPoint(x: 0, y: 0), count: height), count: width)

                for y in 0..<height {
                    for x in 0..<width {
                        let value = multiArray[[0, 0, y, x] as [NSNumber]].doubleValue
                        let detected = value > 0.2

                        let target = CGPoint(x: Int(x * Int(layer.frame.width) / width), y: Int(y * Int(layer.frame.height) / height))

                        if detected {
                            points[y].append(target)
                        }
                    }
                }

                let borderPoints = getBorderPoints(points: points)

                if borderPoints.count < 3 {
                    return
                }

                let path = UIBezierPath()
                path.move(to: borderPoints[0])
                for i in 1..<borderPoints.count {
                    path.addLine(to: borderPoints[i])
                }
                path.close()

                let shapeLayer = CAShapeLayer()
                shapeLayer.path = path.cgPath
                shapeLayer.fillColor = UIColor.clear.cgColor
                shapeLayer.strokeColor = UIColor.red.cgColor
//                shapeLayer.contents = image.cgImage
//                shapeLayer.frame = layer.bounds

                layer.addSublayer(shapeLayer)
            }
        }
    }

    private
    func createImage(from mlMultiArray: MLMultiArray) -> CIImage? {
        guard mlMultiArray.shape.count >= 2 else {
            print("The input MLMultiArray should have at least 2 dimensions")
            return nil
        }

        let height = mlMultiArray.shape[2].intValue
        let width = mlMultiArray.shape[3].intValue

        var pixelValues = [UInt8](repeating: 0, count: width * height * 4)

        for y in 0..<height {
            for x in 0..<width {
                let value = mlMultiArray[[0, 0, y, x] as [NSNumber]].doubleValue
                let detected = value > 0.3
                let index = (y * width + x) * 4
                pixelValues[index] = 160 // Red
                pixelValues[index + 1] = 200 // Green
                pixelValues[index + 2] = 255 // Blue
                pixelValues[index + 3] = detected ? 100 : 0 // Alpha
            }
        }

        let cfbuffer = CFDataCreate(nil, &pixelValues, pixelValues.count)
        let dataProvider = CGDataProvider(data: cfbuffer!)
        let cgImage = CGImage(width: width, height: height, bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: width * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.last.rawValue), provider: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)

        return CIImage(cgImage: cgImage!)
    }

    private func blendImage(_ image: CIImage, withMask mask: CIImage, onBackground background: CIImage) -> CIImage {
        let blendFilter = CIFilter(name: "CIBlendWithMask")!
        blendFilter.setValue(image, forKey: kCIInputImageKey)
        blendFilter.setValue(background, forKey: kCIInputBackgroundImageKey)
        blendFilter.setValue(mask, forKey: kCIInputMaskImageKey)
        return blendFilter.outputImage!
    }
}

func getBorderPoints(points: [[CGPoint]]) -> [CGPoint] {
    var borderPoints: [CGPoint] = []

    // Top row
    borderPoints += points[0]

    // Right column
    for i in 1..<points.count - 1 {
        borderPoints.append(points[i].last!)
    }

    // Bottom row
    if let bottomRow = points.last {
        borderPoints += bottomRow.reversed()
    }

    // Left column
    for i in stride(from: points.count - 2, through: 1, by: -1) {
        borderPoints.append(points[i].first!)
    }

    return borderPoints
}
