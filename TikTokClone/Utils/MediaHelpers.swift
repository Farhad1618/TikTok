//
//  MediaHelpers.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/10/23.
//

import SwiftUI
import AVKit

struct MediaHelpers {
    static func generateThumbnail(path: String) -> UIImage? {
        do {
            guard let url = URL(string: path) else { return nil }
            let asset = AVURLAsset(url: url, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            print("DEBUG: Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
}
