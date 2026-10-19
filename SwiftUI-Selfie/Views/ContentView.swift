//
//  ContentView.swift
//  SwiftUI-Selfie
//
//  Created by Laurentius Brandon Vikario on 10/03/26.

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    let photos = CarouselData.items
    
    @State private var currentIndex = 0
    @StateObject private var camera = CameraManager()
    
    @State private var countdown = 3
    @State private var isCounting = false
    @State private var showCamera = false
    
    @State private var capturedImages: [UIImage] = []
    @State private var showResult = false
    
    @State private var previewImage: UIImage? = nil
    @State private var showPreview = false
    
    @State private var audioPlayer: AVAudioPlayer?
    @State private var beepPlayer: AVAudioPlayer?
    
    @State private var firstLine = ""
    @State private var secondLine = ""
    let fullFirstLine = "Seize Your Moments"
    let fullSecondLine = "with SnapStory"
    @State private var isDeleting = false
    @State private var charIndex = 0
    @State private var showCursor = true
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                if showCamera {
                    
                    CameraPreview(session: camera.session)
                        .ignoresSafeArea()
                    
                }
                else {
                    HomeView(
                        firstLine: firstLine,
                        secondLine: secondLine,
                        showCamera: showCamera
                    ) {
                        fadeOutAndStop()
                        showCamera = true
                        startCountdown()
                    }
                }
                
                if isCounting {
                    
                    Text("\(countdown)")
                        .font(.system(size: 120, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .transition(.scale)
                }
            }
            
            .navigationDestination(isPresented: $showPreview) {
                
                PhotoPreview(
                    image: previewImage ?? UIImage(),
                    
                    onRetake: {
                        
                        showPreview = false
                        
                        startCountdown()
                    },
                    
                    onNext: {
                        
                        if let img = previewImage {
                            capturedImages.append(img)
                        }
                        
                        showPreview = false
                        
                        if capturedImages.count < 4 {
                            
                            startCountdown()
                            
                        } else {
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                showResult = true
                            }
                        }
                    }
                )
            }

            .navigationDestination(isPresented: $showResult) {
                
                ResultView(images: capturedImages) {
                    resetSession()
                }
            }
            .onAppear {
                if !showCamera && audioPlayer?.isPlaying != true {
                    playMusic()
                }
                
                startTypingAdvanced()
            }
        }
    }
}

#Preview {
    ContentView()
}

extension ContentView {
    
    private func startCountdown() {
        
        countdown = 3
        isCounting = true
        
        runCountdown()
    }

    private func runCountdown() {
        
        playBeep()
        
        if countdown > 1 {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                
                countdown -= 1
                runCountdown()
            }
            
        } else {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                
                isCounting = false
                takePhoto()
            }
        }
    }
    
    private func takePhoto() {
        camera.takePhoto { image in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                previewImage = image
                showPreview = true
            }
        }
    }
    
    private func resetSession() {
        
        capturedImages.removeAll()
        
        showResult = false
        
        showCamera = false
        
        countdown = 3
    
    }
    
    func playMusic() {
        
        if audioPlayer?.isPlaying == true {
            return
        }
        
        guard let url = Bundle.main.url(
            forResource: "Moavii - Above It All (freetouse.com)",
            withExtension: "mp3"
        ) else {
            print("❌ File not found")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.volume = 0
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            
            fadeIn()
            
        } catch {
            print("❌ Error:", error)
        }
    }
    
    func fadeIn() {
        guard let player = audioPlayer else { return }
        
        let steps = 20
        let duration = 2.0
        
        for i in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + (duration / Double(steps)) * Double(i)) {
                player.volume = Float(i) / Float(steps) * 0.3
            }
        }
    }
    
    func fadeOutAndStop() {
        guard let player = audioPlayer else { return }
        
        let steps = 20
        let duration = 1.5
        
        for i in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + (duration / Double(steps)) * Double(i)) {
                player.volume = 0.3 * (1 - Float(i) / Float(steps))
                
                if i == steps {
                    player.stop()
                    audioPlayer = nil
                }
            }
        }
    }
    
    func playBeep() {
        guard let url = Bundle.main.url(forResource: "beep", withExtension: "mp3") else {
            print("❌ Beep file not found")
            return
        }
        
        do {
            beepPlayer = try AVAudioPlayer(contentsOf: url)
            beepPlayer?.volume = 1
            beepPlayer?.prepareToPlay()
            beepPlayer?.play()
        } catch {
            print("❌ Beep error:", error)
        }
    }
    
    func startTypingAdvanced() {
        
        let typingSpeed = isDeleting ? 0.05 : 0.1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + typingSpeed) {
            
            if !isDeleting {
                
                if charIndex < fullFirstLine.count {
                    let index = fullFirstLine.index(fullFirstLine.startIndex, offsetBy: charIndex)
                    firstLine.append(fullFirstLine[index])
                    charIndex += 1
                }
                
                else if charIndex < fullFirstLine.count + fullSecondLine.count {
                    let secondIndex = charIndex - fullFirstLine.count
                    let index = fullSecondLine.index(fullSecondLine.startIndex, offsetBy: secondIndex)
                    secondLine.append(fullSecondLine[index])
                    charIndex += 1
                }
                else {
                    isDeleting = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        startTypingAdvanced()
                    }
                    return
                }
                
            } else {
                
                if !secondLine.isEmpty {
                    secondLine.removeLast()
                    charIndex -= 1
                } else if !firstLine.isEmpty {
                    firstLine.removeLast()
                    charIndex -= 1
                } else {
                    isDeleting = false
                }
            }
            
            startTypingAdvanced()
        }
    }
}

