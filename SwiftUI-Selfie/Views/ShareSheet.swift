//
//  ShareSheet.swift
//  SwiftUI-Selfie
//
//  Created by Laurentius Brandon Vikario on 31/03/26.
//

import SwiftUI
import UIKit

struct ShareSheet: UIViewControllerRepresentable {
    
    var activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

class ShareItemSource: NSObject, UIActivityItemSource {
    
    let image: UIImage
    let text: String
    
    init(image: UIImage, text: String) {
        self.image = image
        self.text = text
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return image
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController,
                                itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        
        if activityType == .postToFacebook ||
           activityType == .postToTwitter {
            return text
        }
        
        return image
    }
}
