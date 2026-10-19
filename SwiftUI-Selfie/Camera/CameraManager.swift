//
//  CameraManager.swift
//  SwiftUI-Selfie
//
//  Created by Laurentius Brandon Vikario on 11/03/26.
//

import AVFoundation
import Combine
import UIKit

class CameraManager: NSObject, ObservableObject {
    
    let session = AVCaptureSession()
    private var photoDelegate: PhotoCaptureDelegate?
    private let photoOutput = AVCapturePhotoOutput()
    
    private let sessionQueue = DispatchQueue(label: "camera.session.queue")
    
    override init() {
        super.init()
        checkPermission()
    }
    
    private func checkPermission() {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .authorized:
            configureSession()
            
        case .notDetermined:
            
            AVCaptureDevice.requestAccess(for: .video) { granted in
                
                if granted {
                    self.configureSession()
                } else {
                    print("Camera permission denied")
                }
            }
            
        default:
            print("Camera access restricted")
        }
    }
    
    private func configureSession() {
        
        sessionQueue.async {
            
            self.session.beginConfiguration()
            
            guard let device = AVCaptureDevice.default(
                .builtInWideAngleCamera,
                for: .video,
                position: .front
            ) else {
                print("Front camera not available")
                return
            }
            
            do {
                
                let input = try AVCaptureDeviceInput(device: device)
                
                if self.session.canAddInput(input) {
                    self.session.addInput(input)
                }
                
            } catch {
                print("Camera input error:", error)
                return
            }
            
            if self.session.canAddOutput(self.photoOutput) {
                self.session.addOutput(self.photoOutput)
            }
            
            self.session.commitConfiguration()
            
            self.startSession()
        }
    }
    
    private func startSession() {
        
        if !session.isRunning {
            session.startRunning()
        }
    }
    
    func takePhoto(completion: @escaping (UIImage) -> Void) {
        
        sessionQueue.async {
            
            let settings = AVCapturePhotoSettings()
            
            if let connection = self.photoOutput.connection(with: .video),
               connection.isVideoMirroringSupported {
                connection.isVideoMirrored = true
            }
            
            let delegate = PhotoCaptureDelegate()
            
            delegate.completion = { image in
                completion(image.mirrored())
            }
            
            self.photoDelegate = delegate
            
            self.photoOutput.capturePhoto(with: settings, delegate: delegate)
        }
    }
}

extension UIImage {
    func mirrored() -> UIImage {
        guard let cgImage = self.cgImage else { return self }
        return UIImage(
            cgImage: cgImage,
            scale: self.scale,
            orientation: .leftMirrored
        )
    }
}
