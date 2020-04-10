//
//  AddViewController.swift
//  MiniGram
//
//  Created by Keegan Black on 2/26/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import UIKit
import AVFoundation

class AddViewController: UIViewController {
    
    @IBOutlet weak var previewView: PreviewView!
    @IBOutlet weak var captureButton: UIButton!
    
    private let session = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureButton.isHidden = true
        
        // Verify authorization for capture
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.setupCaptureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.setupCaptureSession()
                }
            }
        case .denied:
            return
        case .restricted:
            return
        @unknown default:
            fatalError("Unknown authorization status!")
        }
    }
    
    func setupCaptureSession() {
        
        self.session.beginConfiguration()
        let videoDevice = self.selectBestDevice()
        guard
            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
            self.session.canAddInput(videoDeviceInput)
            else {return}
        self.session.addInput(videoDeviceInput)
        let photoOutput = AVCapturePhotoOutput()
        guard session.canAddOutput(photoOutput) else {return}
        self.session.sessionPreset = .photo
        self.session.addOutput(photoOutput)
        self.session.commitConfiguration()
        
        self.captureButton.isHidden = false
        
        self.previewView.videoPreviewLayer.session = self.session
        session.startRunning()
    }
    
    func selectBestDevice() -> AVCaptureDevice {
        
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera], mediaType: .video, position: .back)
        let devices = discoverySession.devices
        guard !devices.isEmpty else {fatalError("Missing capture devices!")}
        return devices.first!
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if segue.identifier == "DecideSegue",
        //    let controller = segue.destination as? DecideViewController {
        //    controller.delegate = self
        //}
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
