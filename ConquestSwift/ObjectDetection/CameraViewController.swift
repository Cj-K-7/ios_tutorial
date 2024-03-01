//
//  CaptureView.swift
//  ConquestSwift
//
//  Created by changju.kim on 2/29/24.
//

import AVFoundation
import SwiftUI
import UIKit
import Vision

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    private var previewLayer = AVCaptureVideoPreviewLayer()
    private var videoOutput = AVCaptureVideoDataOutput()
    private let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "cameraQueue")
    private var permissionGranted = false
    private var screenBounds: CGRect!

    private var objectDetector = ObjectDetector()

    override func viewDidLoad() {
        checkPermission()
    }

    override func viewWillAppear(_ animated: Bool) {
        updateViewScreen()

        sessionQueue.async {
            self.setupCameraSession()

            self.setupDetector()
            self.session.startRunning()
        }
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        updateViewScreen()
    }

    override func viewWillDisappear(_ animated: Bool) {
        sessionQueue.sync {
            session.stopRunning()
        }
    }
}

// MARK: SCREEN UI HANDLING

extension CameraViewController {
    private func updateViewScreen() {
        screenBounds = UIScreen.main.bounds
        previewLayer.frame = CGRect(x: 0, y: 0, width: screenBounds.size.width, height: screenBounds.size.height)

        switch UIDevice.current.orientation {
        case .portraitUpsideDown:
            previewLayer.connection?.videoOrientation = .portraitUpsideDown

        case .landscapeLeft:
            previewLayer.connection?.videoOrientation = .landscapeRight

        case .landscapeRight:
            previewLayer.connection?.videoOrientation = .landscapeLeft

        case .portrait:
            previewLayer.connection?.videoOrientation = .portrait

        default:
            break
        }
        updateDetector()
    }

    private func setupDetector() {
        objectDetector.loadML()
        objectDetector.layer.frame = CGRect(x: 0, y: 0, width: screenBounds.size.width, height: screenBounds.size.height)
        view.layer.addSublayer(objectDetector.layer)
    }

    private func updateDetector() {
        objectDetector.layer.frame = CGRect(x: 0, y: 0, width: screenBounds.size.width, height: screenBounds.size.height)
    }

    private func removeDetector() {
        objectDetector.unloadML()
        objectDetector.layer.removeFromSuperlayer()
    }

    // Delegate of VideoOutput
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return }

        let cropRect = CGRect(x: 0, y: 0, width: 640, height: 640)

        guard let croppedCGImage = cgImage.cropping(to: cropRect) else { return }

        let imageRequestHandler = VNImageRequestHandler(cgImage: croppedCGImage, options: [:])

        do {
            try imageRequestHandler.perform(objectDetector.requests) // Schedules vision requests to be performed
        } catch {
            print(error)
        }
    }
}

// MARK: PERMISSION

extension CameraViewController {
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            permissionGranted = true
        case .notDetermined:
            requestPermission()
        default:
            permissionGranted = false
        }
    }

    func requestPermission() {
        sessionQueue.suspend()
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            self?.permissionGranted = granted
            self?.sessionQueue.resume()
        }
    }

    func setupCameraSession() {
        guard let videoDevice = AVCaptureDevice.default(.builtInDualWideCamera, for: .video, position: .back) else { return }
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else { return }

        guard session.canAddInput(videoDeviceInput) else { return }
        session.addInput(videoDeviceInput)

        screenBounds = UIScreen.main.bounds

        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = CGRect(x: 0, y: 0, width: screenBounds.size.width, height: screenBounds.size.height)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill // Fill screen
        previewLayer.connection?.videoOrientation = .portrait

        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBufferQueue"))
        session.addOutput(videoOutput)

        videoOutput.connection(with: .video)?.videoOrientation = .portrait

        DispatchQueue.main.async { [weak self] in
            self!.view.layer.addSublayer(self!.previewLayer)
        }
    }
}

struct HostedCameraViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return CameraViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
