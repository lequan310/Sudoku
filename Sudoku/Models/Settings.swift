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

// Settings inside the settings view to change game and app settings
final class Settings: ObservableObject {
    @Published var playerName: String {
        didSet {
            UserDefaults.standard.set(playerName, forKey: "playerName")
        }
    }
    
    @Published var darkMode: Bool! {
        didSet {
            UserDefaults.standard.set(darkMode, forKey: "darkMode")
        }
    }
    
    @Published var difficulty: Difficulty! = Difficulty.Easy {
        didSet {
            UserDefaults.standard.set(difficulty.rawValue, forKey: "difficulty")
        }
    }
    
    @Published var english: Bool! {
        didSet {
            UserDefaults.standard.set(english, forKey: "english")
        }
    }
    
    init() {        
        if (UserDefaults.standard.object(forKey: "playerName") != nil) {
            let rawValue = UserDefaults.standard.string(forKey: "playerName") ?? "User"
            self.playerName = (rawValue != "") ? rawValue : "User"
        } else {
            self.playerName = "User"
        }
        
        if (UserDefaults.standard.object(forKey: "difficulty") != nil) {
            let rawValue = UserDefaults.standard.string(forKey: "difficulty") ?? "easy"
            self.difficulty = (rawValue != "") ? Difficulty(rawValue: rawValue) : Difficulty.Easy
        } else {
            self.difficulty = Difficulty.Easy
        }
        
        // Default false
        self.darkMode = UserDefaults.standard.bool(forKey: "darkMode")
        
        // Default true
        if (UserDefaults.standard.object(forKey: "english") != nil) {
            self.english = UserDefaults.standard.bool(forKey: "english")
        } else {
            self.english = true
        }
    }
}
