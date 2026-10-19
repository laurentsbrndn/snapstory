//
//  PhotoPreview.swift
//  SwiftUI-Selfie
//
//  Created by Laurentius Brandon Vikario on 13/03/26.
//

import SwiftUI

struct PhotoPreview: View {
    
    var image: UIImage
    
    var onRetake: () -> Void
    var onNext: () -> Void
    
    @Environment(\.dismiss) var dismiss
    
    @State private var timer = 5
    @State private var isActive = true
    @State private var isButtonDisabled = false
    
    var body: some View {
        
        ZStack {
            
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .blur(radius: 50)
                .overlay(Color.black.opacity(0.6))
            
            VStack(spacing: 24) {
                
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 260)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.5), radius: 20, y: 10)
                
                Text("\(timer)")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                
                Text("Next photo")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
                
                HStack(spacing: 16) {
                    
                    Button {
                        guard !isButtonDisabled else { return }
                        isButtonDisabled = true
                        isActive = false
                        dismiss()
                        onRetake()
                    } label: {
                        Text("Retake")
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                .ultraThinMaterial,
                                in: RoundedRectangle(cornerRadius: 16)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    }
                    
                    Button {
                        guard !isButtonDisabled else { return }
                        isButtonDisabled = true
                        isActive = false
                        dismiss()
                        onNext()
                    } label: {
                        Text("Next")
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(
                                    colors: [Color.purple, Color.blue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                in: RoundedRectangle(cornerRadius: 16)
                            )
                            .shadow(color: .purple.opacity(0.4), radius: 10, y: 5)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 10)
            }
            .padding(.horizontal, 24)
            .onAppear {
                runTimer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
    
    func runTimer() {
        
        guard isActive else { return }
        
        if timer > 0 {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                
                timer -= 1
                runTimer()
            }
            
        } else {
            
            dismiss()
            onNext()
        }
    }
}
