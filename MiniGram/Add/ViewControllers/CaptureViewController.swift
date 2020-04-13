//
//  AddViewController.swift
//  MiniGram
//
//  Created by Keegan Black on 2/26/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import UIKit
import AVFoundation

class CaptureViewController: UIViewController {
    
    @IBOutlet weak var previewView: PreviewView!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    
    @IBAction func captureButton(_ sender: Any) {
        
        if(self.imageCaptured) {
            return
        }
        
        self.lockCaptureButton()
        var photoSettings = AVCapturePhotoSettings()
        
        // Capture HEIF photos when supported.
        if self.photoOutput.availablePhotoCodecTypes.contains(.hevc) {
            photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
        }
        
        // Configure flash mode.
        if self.videoDeviceInput!.device.isFlashAvailable {
            var flashMode: AVCaptureDevice.FlashMode
            switch self.flashStatus {
            case .auto: flashMode = .auto
            case .on: flashMode = .on
            case .off: flashMode = .off
            }
            photoSettings.flashMode = flashMode
        }
        
        if !photoSettings.__availablePreviewPhotoPixelFormatTypes.isEmpty {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoSettings.__availablePreviewPhotoPixelFormatTypes.first!]
        }
        
        self.photoOutput.capturePhoto(with: photoSettings, delegate: self.photoCaptureProcessor)
    }
    
    @IBAction func flashButton(_ sender: Any) {
        var next: FlashOptions
        switch self.flashStatus {
        case .auto: next = .on
        case .on: next = .off
        case .off: next = .auto
        }
        self.setFlashStatus(status: next)
    }
    
    private let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private let photoCaptureProcessor = PhotoCaptureProcessor()
    
    private var videoDeviceInput: AVCaptureDeviceInput?
    private var flashStatus = FlashOptions.auto
    private var setupSuccessful = false
    private var imageCaptured = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoCaptureProcessor.delegate = self
        
        self.setupSuccessful = false
        self.captureButton.isHidden = true
        self.flashButton.isHidden = true
        self.setFlashStatus(status: .auto)
        
        self.previewView.videoPreviewLayer.session = self.session
        self.previewView.videoPreviewLayer.frame = self.view.frame
        self.previewView.videoPreviewLayer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(self.previewView.videoPreviewLayer)
        
        // Verify authorization for capture
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupSuccessful = self.setupCaptureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.setupSuccessful = self.setupCaptureSession()
                }
            }
        case .denied:
            return
        case .restricted:
            return
        @unknown default:
            fatalError("Unknown authorization status!")
        }
        
        // Run capture
        if self.setupSuccessful {
            self.captureButton.isHidden = false
            self.flashButton.isHidden = false
            self.session.startRunning()
        }
    }
    
    func setupCaptureSession() -> Bool {
        
        self.session.beginConfiguration()
        let videoDevice = self.selectBestDevice()
        if videoDevice == nil {
            return false
        }
        guard
            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
            self.session.canAddInput(videoDeviceInput)
            else {return false}
        self.videoDeviceInput = videoDeviceInput
        self.session.addInput(videoDeviceInput)
        guard session.canAddOutput(self.photoOutput) else {return false}
        self.session.sessionPreset = .photo
        self.session.addOutput(photoOutput)
        self.session.commitConfiguration()
        return true
    }
    
    func selectBestDevice() -> AVCaptureDevice? {
        
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera], mediaType: .video, position: .back)
        let devices = discoverySession.devices
        guard !devices.isEmpty else {return nil}
        return devices.first!
    }
    
    func setFlashStatus(status: FlashOptions) {
        self.flashStatus = status
        self.flashButton.setImage(UIImage(systemName: status.rawValue), for: .normal)
    }
    
    func lockCaptureButton() {
        self.imageCaptured = true
    }
    
    func unlockCaptureButton() {
        self.imageCaptured = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DecideSegue",
            let controller = segue.destination as? DecideViewController {
            controller.delegate = self
            controller.image = self.photoCaptureProcessor.image
            self.unlockCaptureButton()
        }
    }
}

class PreviewView: UIView {
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
}

class PhotoCaptureProcessor: NSObject, AVCapturePhotoCaptureDelegate {
    
    var delegate: UIViewController!
    var image: UIImage?
    
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let imageData = photo.fileDataRepresentation()
        if let data = imageData, let img = UIImage(data: data) {
            self.image = img
            self.delegate.performSegue(withIdentifier: "DecideSegue", sender: self)
        }
    }
}

enum FlashOptions: String {
    
    case auto = "bolt.badge.a.fill"
    case on = "bolt.fill"
    case off = "bolt"
}
