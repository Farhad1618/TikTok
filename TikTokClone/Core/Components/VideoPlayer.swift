//
//  VideoPlayer.swift
//  TikTokClone
//
//  Created by Farhad on 10/8/23.
//

import SwiftUI
import AVFoundation
import AVKit

struct VideoPlayer: UIViewControllerRepresentable {
    var player: AVPlayer
    
    func makeUIViewController(context: Context) ->  UIViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.exitsFullScreenWhenPlaybackEnds = true
        controller.allowsPictureInPicturePlayback = true
        controller.videoGravity = .resizeAspectFill
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}
