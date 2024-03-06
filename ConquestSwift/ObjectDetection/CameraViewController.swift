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
    private var frameCounter = 0
    private var mlRequsetPerFPS = 5

    var captureTriger = false

    override func viewDidLoad() {
        checkPermission()
    }

    override func viewWillAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)

        sessionQueue.async {
            self.setupCameraSession()

            self.setupDetector()
            self.session.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        sessionQueue.sync {
            session.stopRunning()
        }
        AppUtility.unlockOrientation()
    }

    override func viewDidDisappear(_ animated: Bool) {
        removeDetector()
    }
}

// MARK: SCREEN UI HANDLING

extension CameraViewController {
    private func setupDetector() {
        objectDetector.loadML()
        objectDetector.layer.frame = CGRect(x: 0, y: 0, width: screenBounds.size.width, height: screenBounds.size.height)
        DispatchQueue.main.async {
            self.view.layer.addSublayer(self.objectDetector.layer)
        }
        print("Detector added")
    }

    private func removeDetector() {
        objectDetector.unloadML()
        objectDetector.layer.removeFromSuperlayer()
        frameCounter = 0
        print("Detector removed")
    }

    private func captureAsImage(_ pixelBuffer: CVPixelBuffer) {
        captureTriger = false

        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return }

        let image = UIImage(cgImage: cgImage)
        if let data = image.jpegData(compressionQuality: 1.0) {
//            let filename = getDocumentsDirectory().appendingPathComponent("output.jpg")
//            try? data.write(to: filename)
        }
    }

    // Delegate of VideoOutput
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        frameCounter += 1
        guard frameCounter % mlRequsetPerFPS == 0 else { return }
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        if captureTriger {
            captureAsImage(pixelBuffer)
        }

        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])

        do {
            try imageRequestHandler.perform(objectDetector.requests)
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
        if session.canSetSessionPreset(.hd4K3840x2160) {
            session.sessionPreset = .hd4K3840x2160
        }

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
