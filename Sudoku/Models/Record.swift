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

// Record for Leaderboard
struct Record: Codable {
    private var name: String
    private var achievement: Achievement
    private var achievementImage: String
    private var difficulty: Difficulty
    private var score: Int
    
    init(name: String, difficulty: Difficulty, errorCount: Int, hintCount: Int, score: Int) {
        self.name = name
        self.difficulty = difficulty
        self.score = score
        
        // Condition for achievement
        if (difficulty == .Hard && errorCount < 3) {
            if (errorCount == 0 && hintCount == 0) {
                self.achievement = .PerfectSS
                self.achievementImage = "PerfectSS"
            } else {
                self.achievement = .SS
                self.achievementImage = "SS"
            }
        } else if (difficulty == .Medium && errorCount < 5) {
            if (errorCount == 0 && hintCount == 0) {
                self.achievement = .PerfectS
                self.achievementImage = "PerfectS"
            } else {
                self.achievement = .S
                self.achievementImage = "S"
            }
        } else if (difficulty == .Easy && errorCount < 10) {
            self.achievement = .A
            self.achievementImage = "A"
        } else {
            self.achievement = .D
            self.achievementImage = "D"
        }
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getAchievement() -> Achievement {
        return self.achievement
    }
    
    func getAchievementImage() -> String {
        return self.achievementImage
    }
    
    func getDifficulty() -> Difficulty {
        return self.difficulty
    }
    
    func getScore() -> Int {
        return self.score
    }
}

final class RecordManager {
    static let instance = RecordManager()

    // Record list to store list of record for the leaderboard
    @Published private var recordList: [Record] {
        didSet {
            do {
                let encodedData = try JSONEncoder().encode(recordList)
                UserDefaults.standard.set(encodedData, forKey: "recordList") // Store record list on change
            } catch {
                print("Fail to encode records.")
            }
        }
    }

    init() {
        if let savedData = UserDefaults.standard.object(forKey: "recordList") as? Data {
            do {
                self.recordList = try JSONDecoder().decode([Record].self, from: savedData) // Retrieve record list from UserDefaults on launch
            } catch {
                print("Fail to decode records.")
                self.recordList = [Record]()
            }
        } else {
            self.recordList = [Record]() // Initialize new record list
        }
    }

    func getRecordList() -> [Record] {
        return self.recordList
    }
    
    func addRecord(record: Record) {
        self.recordList.append(record)
    }
}
