//
//  HomeView.swift
//  SwiftUI-Selfie
//
//  Created by Laurentius Brandon Vikario on 01/04/26.
//

import SwiftUI

struct HomeView: View {
    
    var firstLine: String
    var secondLine: String
    
    var showCamera: Bool
    
    var onStart: () -> Void
    
    var body: some View {
        
        ZStack {
            
            LinearGradient(
                colors: [
                    Color.purple,
                    Color.blue,
                    Color.pink.opacity(0.8)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            
            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 180)
                .blur(radius: 50)
                .offset(x: -120, y: -250)
            
            Circle()
                .fill(Color.pink.opacity(0.2))
                .frame(width: 140)
                .blur(radius: 60)
                .offset(x: 140, y: 200)
            
            Circle()
                .fill(Color.blue.opacity(0.2))
                .frame(width: 120)
                .blur(radius: 60)
                .offset(x: -100, y: 250)
            
            VStack {
                VStack(spacing: 6) {
                    
                    Text(firstLine)
                    
                    (
                        Text(secondLine.replacingOccurrences(of: "SnapStory", with: ""))
                        +
                        Text(secondLine.contains("SnapStory") ? "SnapStory" : "")
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.yellow, .pink],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
                }
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.top, 20)
                
                Spacer()
                
                VStack {
                    Spacer()
                    
                    Button {
                        onStart()
                    } label: {
                        
                        ZStack {
                            
                            Circle()
                                .fill(Color.white.opacity(0.15))
                                .frame(width: 140, height: 140)
                                .blur(radius: 30)
                            
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.yellow, .blue],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 100, height: 100)
                                .shadow(color: .purple.opacity(0.6), radius: 20)
                            
                            Image(systemName: "camera.fill")
                                .font(.system(size: 36))
                                .foregroundStyle(.white)
                        }
                    }
                    .padding(.bottom, 220)
                }
                
                VStack(spacing: 8) {
                    
                    HStack(spacing: 6) {
                        Image(systemName: "wand.and.stars")
                        Text("Turn moments into memories")
                    }
                    
                    Text("Tap to start capturing ✨")
                        .font(.footnote)
                        .opacity(0.8)
                }
                .foregroundStyle(.white)
                .padding(.bottom, 50)
                
            }
            
        }
    }
}
