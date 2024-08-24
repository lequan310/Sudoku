/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 2
  Author: Le Minh Quan
  ID: 3877969
  Created  date: 12/8/2023
  Last modified: 24/8/2023
  Acknowledgement:
https://rmit.instructure.com/courses/121597/pages/w8-whats-happening-this-week?module_item_id=5219568
http://www.opensky.ca/~jdhildeb/software/sudokugen/
*/

import Foundation
import AVKit

final class SoundManager {
    static let instance = SoundManager()
    
    private var musicPlayer: AVAudioPlayer?
    private var effectPlayer: AVAudioPlayer?
    private var reset: Bool = true
    
    // Play music with loop
    func playMusic(filename: String) {
        if (reset) {
            musicPlayer?.stop()
            guard let url = Bundle.main.url(forResource: filename, withExtension: ".mp3") else { return }
            
            do {
                musicPlayer = try AVAudioPlayer(contentsOf: url)
                musicPlayer?.numberOfLoops = -1
                musicPlayer?.play()
                reset = false
            } catch let error {
                print("Error playing sound. \(error.localizedDescription)")
            }
        } else {
            musicPlayer?.play()
        }
    }
    
    // Play sound effect once
    func playSoundEffect(filename: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: ".mp3") else { return }
        
        do {
            effectPlayer = try AVAudioPlayer(contentsOf: url)
            effectPlayer?.numberOfLoops = 0
            effectPlayer?.play()
        } catch let error {
            print("Error playing sound. \(error.localizedDescription)")
        }
    }
    
    func stopSound() {
        effectPlayer?.stop()
    }
    
    func stopAndResetMusic() {
        fadeSound()
        reset = true
    }
    
    func stopMusic() {
        musicPlayer?.stop()
    }
    
    func resumeSound() {
        musicPlayer?.setVolume(1, fadeDuration: 1)
        musicPlayer?.play()
    }
    
    func fadeSound() {
        musicPlayer?.setVolume(0, fadeDuration: 1)
    }
}
