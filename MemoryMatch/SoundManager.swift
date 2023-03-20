//
//  SoundManager.swift
//  MemoryMatch
//
//  Created by Ogbemudia Terry Osayawe on 19.03.23.
//

import AVFoundation

class SoundManager {
    
    private var audioPlayer: AVAudioPlayer?
    
    func playSound(_ soundURL: URL?, isMuted: Bool) {
        guard !isMuted else { return }
        
        guard let url = soundURL else {
            print("Sound file not found.")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error)")
        }
    }
}
