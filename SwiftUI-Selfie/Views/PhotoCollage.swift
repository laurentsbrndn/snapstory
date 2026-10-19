//
//  PhotoCollage.swift
//  SwiftUI-Selfie
//
//  Created by Laurentius Brandon Vikario on 16/03/26.

import SwiftUI

struct PhotoCollageView: View {
    
    var images: [UIImage]
    
    var body: some View {
        
        GeometryReader { geo in
            
            let width = geo.size.width
            
            let horizontalSpacing = width * 0.09
            let verticalSpacing = width * 0.03
            
            let horizontalPadding = width * 0.08
            let verticalPadding = width * 0.12
            
            let imageHeight = width * 0.68
            let cornerRadius = width * 0.05
            let offsetAmount = width * 0.025
            
            VStack {
                
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: horizontalSpacing),
                        GridItem(.flexible(), spacing: horizontalSpacing)
                    ],
                    spacing: verticalSpacing
                ) {
                    
                    ForEach(images.indices, id: \.self) { i in
                        Image(uiImage: images[i])
                            .resizable()
                            .scaledToFill()
                            .frame(height: imageHeight)
                            .clipped()
                            .cornerRadius(cornerRadius)
                            .offset(
                                x: i % 2 == 0 ? offsetAmount : -offsetAmount
                            )
                    }
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                .offset(y: -width * 0.065)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
        }
    }
}
