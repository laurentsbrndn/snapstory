//
//  FrameData.swift
//  SwiftUI-Selfie
//
//  Created by Laurentius Brandon Vikario on 16/03/26.
//

import Foundation
import SwiftUI

struct FrameItem: Identifiable {
    let id = UUID()
    let frameName: String
    let ornamentName: String
}

struct FrameData {
    
    static let items: [FrameItem] = [
        FrameItem(
            frameName: "frame",
            ornamentName: "ornament"
        ),
        FrameItem(
            frameName: "frame2",
            ornamentName: "ornament2"
        ),
        FrameItem(
            frameName: "frame3",
            ornamentName: "ornament3"
        )
    ]
}
