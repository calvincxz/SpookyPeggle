//
//  MusicPlayer.swift
//  SpookyPeggle
//
//  Created by Calvin Chen on 29/2/20.
//  Copyright © 2020 Calvin Chen. All rights reserved.
//

import Foundation
import AVFoundation

class MusicPlayer {
    static let shared = MusicPlayer()
    static var audioPlayer: AVAudioPlayer?
    static var secondAudioPlayer: AVAudioPlayer?

    static func playBackgroundMusic() {
        playSound(fileName: "bgm", fileExtension: "mp3", loop: -1)
    }

    static func playInGameMusic() {
        playSound(fileName: "bgm2", fileExtension: "mp3", loop: -1)
    }

    static func playBucketCollisionSound() {
        playSoundOnce(fileName: "bucket-collision", fileExtension: "mp3")
    }

    static func playCannonSound() {
        playSoundOnce(fileName: "cannon", fileExtension: "mp3")
    }

    static func playCloseToWinSound() {
        playSound(fileName: "winning", fileExtension: "mp3")
    }

    static func playPegHitSound() {
        playSoundOnce(fileName: "bluepeg", fileExtension: "wav")
    }

    static func playGameWinMusic() {
        playSound(fileName: "win", fileExtension: "wav")
    }

    static func playGameLoseMusic() {
        playSound(fileName: "lose", fileExtension: "wav")
    }

    static func playSound(fileName: String, fileExtension: String) {
        playSound(fileName: fileName, fileExtension: fileExtension, loop: 1)
    }

    static func stop() {
        audioPlayer = nil
        secondAudioPlayer = nil
    }

    static func playSound(fileName: String, fileExtension: String, loop: Int) {
        if let bundle = Bundle.main.path(forResource: fileName, ofType: fileExtension) {
            let backgroundMusic = NSURL(fileURLWithPath: bundle)
            guard let player = try? AVAudioPlayer(contentsOf: backgroundMusic as URL) else {
                return

            }
            audioPlayer = player
            audioPlayer?.volume = 0.2
            audioPlayer?.numberOfLoops = loop
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        }
    }

    static func playSoundOnce(fileName: String, fileExtension: String) {
        if let bundle = Bundle.main.path(forResource: fileName, ofType: fileExtension) {
            let backgroundMusic = NSURL(fileURLWithPath: bundle)
            guard let player = try? AVAudioPlayer(contentsOf: backgroundMusic as URL) else {
                return

            }
            secondAudioPlayer = player
            secondAudioPlayer?.volume = 0.05
            secondAudioPlayer?.numberOfLoops = 0
            secondAudioPlayer?.prepareToPlay()
            secondAudioPlayer?.play()
        }
    }
}
