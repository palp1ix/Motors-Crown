//
//  CustomVideoPlayer.swift
//  Crown Motors
//
//  Created by Artem Khachatryan on 8/5/25.
//


import SwiftUI
import AVKit

struct CustomVideoPlayer: UIViewRepresentable {
    @ObservedObject var viewModel: StoriesViewModel

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let playerLayer = AVPlayerLayer(player: viewModel.player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = view.bounds
        view.layer.addSublayer(playerLayer)
        
        context.coordinator.playerLayer = playerLayer
        
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.playerLayer?.frame = uiView.bounds
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: CustomVideoPlayer
        var playerLayer: AVPlayerLayer?

        init(_ parent: CustomVideoPlayer) {
            self.parent = parent
        }
        
        deinit {
            playerLayer?.removeFromSuperlayer()
            playerLayer = nil
        }
    }
}
