//
//  PhotoCapture.swift
//  SwiftUI-Selfie
//
//  Created by Laurentius Brandon Vikario on 11/03/26.
//

import AVFoundation
import UIKit

class PhotoCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {

    var completion: ((UIImage) -> Void)?

    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {

        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else { return }

        completion?(image)
    }
}
