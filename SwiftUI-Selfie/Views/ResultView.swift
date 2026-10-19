//
//  ResultView.swift
//  SwiftUI-Selfie
//
//  Created by Laurentius Brandon Vikario on 12/03/26.
//

import SwiftUI
import Photos
import AVFoundation

struct ResultView: View {
    
    let images: [UIImage]
    let onExit: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.displayScale) var displayScale
    
    @State private var showExitAlert = false
    @State private var showFramePicker = false
    @State private var selectedFrame: FrameItem? = FrameData.items.first
    
    @State private var audioPlayer: AVAudioPlayer?
    
    @State private var showToast = false
    
    @State private var showShareSheet = false
    @State private var shareImage: UIImage?
    
    private let frames = FrameData.items
    
    var body: some View {
        
        ZStack {
            
            if let frame = selectedFrame {
                Image(frame.frameName)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .blur(radius: 40)
                    .overlay(Color.black.opacity(0.55))
            }
            
            ScrollViewReader { proxy in
                
                ScrollView {
                    
                    VStack(spacing: 2){
                        
                        header
                        
                        collageSection
                        
                        chooseFrameButton(proxy: proxy)
                        
                        if showFramePicker {
                            framePickerSection(proxy: proxy)
                        }
                        
                        shareButton
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            
            .toolbar { toolbarContent }
            
            .sheet(isPresented: $showShareSheet) {
                if let image = shareImage {
                    ShareSheet(activityItems: [
                        ShareItemSource(
                            image: image,
                            text: "Made with SnapStory ✨"
                        )
                    ])
                }
            }
            
            .alert("Are you sure?", isPresented: $showExitAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Yes", role: .destructive) {
                    onExit()
                    dismiss()
                }
            } message: {
                Text("Your photos will be deleted.")
            }
            
            .onAppear {
                playMusic()
            }
            .onDisappear {
                fadeOutAndStop()
            }
            
            if showToast {
                VStack {
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Saved to Gallery")
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .shadow(radius: 10)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

private extension ResultView {
    
    var header: some View {
        Text("Your Story")
            .font(.system(size: 32, weight: .bold, design: .rounded))
            .foregroundStyle(
                LinearGradient(
                    colors: [.yellow, .pink],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .id("top")
            .padding(.bottom, 20)
    }
    
    var collageSection: some View {
        
        guard let frame = selectedFrame,
              let uiImage = UIImage(named: frame.frameName) else {
            return AnyView(EmptyView())
        }
        
        let size = uiImage.size
        let ratio = size.width / size.height
        
        let displayWidth: CGFloat = 320
        let displayHeight = displayWidth / ratio
        
        return AnyView(
            ZStack {
                
                Image(frame.frameName)
                    .resizable()
                    .scaledToFit()
                
                PhotoCollageView(images: images)
                    .frame(width: displayWidth, height: displayHeight)
                
                Image(frame.ornamentName)
                    .resizable()
                    .scaledToFit()
                    .allowsHitTesting(false)
            }
            .frame(width: displayWidth)
            .aspectRatio(ratio, contentMode: .fit)
            .padding(.bottom, 20)
        )
    }
    
    func chooseFrameButton(proxy: ScrollViewProxy) -> some View {
        Button {
            withAnimation(.easeInOut) {
                showFramePicker.toggle()
                proxy.scrollTo("framePicker", anchor: .top)
            }
        } label: {
            HStack {
                Image(systemName: "photo.on.rectangle")
                Text("Choose Frame")
                    .fontWeight(.semibold)
            }
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 20)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
        }
        .padding(.horizontal, 60)
    }
    
    func framePickerSection(proxy: ScrollViewProxy) -> some View {
        
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        return VStack(spacing: 16) {
            
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(frames) { frame in
                    
                    let isSelected = selectedFrame?.id == frame.id
                    ZStack {
                        
                        Image(frame.frameName)
                            .resizable()
                            .scaledToFit()
                        
                        Image(frame.ornamentName)
                            .resizable()
                            .scaledToFit()
                    }
                    .frame(height: 100)
                    .background(
                        Color.white.opacity(0.05),
                        in: RoundedRectangle(cornerRadius: 12)
                    )
                    .blur(radius: isSelected ? 2 : 0)
                    .overlay(
                        Color.black.opacity(isSelected ? 0.4 : 0)
                    )
                    .overlay {
                        if isSelected {
                            VStack(spacing: 6) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title2)
                                    .foregroundStyle(.white)
                                
                                Text("Selected")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                    .onTapGesture {
                        
                        selectedFrame = frame
                        
                        withAnimation(.easeInOut) {
                            showFramePicker = false
                            proxy.scrollTo("top", anchor: .top)
                        }
                    }
                }
            }
            .padding(12)
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 20)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
                
            )
            .padding(.horizontal, 80)
            
        }
        .id("framePicker")
        .padding(.vertical, 12)
    }
    
    var shareButton: some View {
        Button {
            shareImage = renderImage()
            showShareSheet = true
        } label: {
            HStack {
                Image(systemName: "square.and.arrow.up.fill")
                Text("Share")
                    .fontWeight(.semibold)
            }
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [
                        Color.purple,
                        Color.blue
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                in: RoundedRectangle(cornerRadius: 20)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
        }
        .padding(.horizontal, 60)
        .padding(.top, 8)
    }
    
    var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                showExitAlert = true
            } label: {
                Image(systemName: "chevron.backward")
            }
        }
    }
}

private extension ResultView {
    
    func playMusic() {
        guard let url = Bundle.main.url(forResource: "Dagored - Happiness In My Soul (freetouse.com)", withExtension: "mp3") else {
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
        
        let duration: Double = 2.0
        let steps = 20
        let stepTime = duration / Double(steps)
        
        for i in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + stepTime * Double(i)) {
                player.volume = Float(i) / Float(steps) * 0.3
            }
        }
    }
    
    func fadeOutAndStop() {
        guard let player = audioPlayer else { return }
        
        let duration: Double = 2.0
        let steps = 20
        let stepTime = duration / Double(steps)
        
        for i in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + stepTime * Double(i)) {
                player.volume = 0.3 * (1 - Float(i) / Float(steps))
                
                if i == steps {
                    player.stop()
                }
            }
        }
    }
    
    func stopMusic() {
        audioPlayer?.stop()
    }
    
    func renderImage() -> UIImage {
        
        guard let frame = selectedFrame,
              let uiImage = UIImage(named: frame.frameName) else { return UIImage() }

        let size = uiImage.size
        
        let exportView =
        ZStack(alignment: .top) {
            
            Image(frame.frameName)
                .resizable()
                .scaledToFill()
            
            PhotoCollageView(images: images)
                .frame(width: size.width, height: size.height)
                .offset(y: -size.height * 0.002)
            
            Image(frame.ornamentName)
                .resizable()
                .scaledToFill()
        }
        .frame(width: size.width, height: size.height)
        .clipped()
        
        let renderer = ImageRenderer(content: exportView)
        renderer.scale = 2
        
        return renderer.uiImage ?? UIImage()
    }
}
