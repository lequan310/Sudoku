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

final class Game: ObservableObject {
    private var name: String {
        didSet {
            UserDefaults.standard.set(name, forKey: "name")
        }
    }
    private var difficulty: Difficulty
    @Published private var puzzle: [[Int]] = [[Int]]()
    @Published private var solution: [[Int]] = [[Int]]()
    private var progressStr: String {
        didSet {
            UserDefaults.standard.set(progressStr, forKey: "progressStr")
        }
    }
    private var solutionStr: String {
        didSet {
            UserDefaults.standard.set(solutionStr, forKey: "solutionStr")
        }
    }
    private var errorCount: Int {
        didSet {
            UserDefaults.standard.set(errorCount, forKey: "errorCount")
        }
    }
    private var errorLimit: Int {
        didSet {
            UserDefaults.standard.set(errorLimit, forKey: "errorLimit")
        }
    }
    private var hintCount: Int {
        didSet {
            UserDefaults.standard.set(hintCount, forKey: "hintCount")
        }
    }
    private var hintLimit: Int {
        didSet {
            UserDefaults.standard.set(hintLimit, forKey: "hintLimit")
        }
    }
    private var score: Int {
        didSet {
            UserDefaults.standard.set(score, forKey: "score")
        }
    }
    private var combo: Int {
        didSet {
            UserDefaults.standard.set(combo, forKey: "combo")
        }
    }
    private var error: Bool = false
    private var activeCell: [Int] = [Int]()
    private var previousCell: [Int] = [Int]()
    private var highlight: Int = -1
    private var canResume: Bool {
        didSet {
            UserDefaults.standard.set(canResume, forKey: "canResume")
        }
    }
    @Published private var record: Record? = nil
    
    init() {
        self.puzzle = Array(repeating: Array(repeating: 0, count: 9), count: 9)
        self.solution = Array(repeating: Array(repeating: 0, count: 9), count: 9)
        self.progressStr = UserDefaults.standard.string(forKey: "progressStr") ?? ""
        self.solutionStr = UserDefaults.standard.string(forKey: "solutionStr") ?? ""
        self.name = UserDefaults.standard.string(forKey: "name") ?? "User"
        self.difficulty = .Easy
        self.errorCount = UserDefaults.standard.integer(forKey: "errorCount")
        self.errorLimit = UserDefaults.standard.integer(forKey: "errorLimit")
        self.hintCount = UserDefaults.standard.integer(forKey: "hintCount")
        self.hintLimit = UserDefaults.standard.integer(forKey: "hintLimit")
        self.score = UserDefaults.standard.integer(forKey: "score")
        self.combo = UserDefaults.standard.integer(forKey: "combo")
        self.activeCell = [-1, -1]
        self.previousCell = [-1, -1]
        self.canResume = UserDefaults.standard.bool(forKey: "canResume")
    }
    
    // Getters and Setters
    func getName() -> String {
        return self.name
    }
    
    func getDifficulty() -> Difficulty {
        return self.difficulty
    }
    
    func getSolution() -> [[Int]] {
        return self.solution
    }
    
    func getValueAt(row: Int, col: Int) -> Int {
        return self.puzzle[row][col]
    }
        
    func getActiveCell() -> [Int] {
        return self.activeCell
    }
    
    func setActiveCell(row: Int, col: Int) {
        self.activeCell = [row, col]
    }
    
    func getPreviousCell() -> [Int] {
        return self.previousCell
    }
    
    func setPreviousCell(row: Int, col: Int) {
        self.previousCell = [row, col]
    }
    
    func setHightlight(value: Int) {
        self.highlight = value
    }
    
    func getHightlight() -> Int {
        return self.highlight
    }
    
    func isError() -> Bool {
        return self.error
    }
    
    func getErrorLimit() -> Int {
        return self.errorLimit
    }
    
    func getErrorCount() -> Int {
        return self.errorCount
    }
    
    func getHintCount() -> Int {
        return self.hintCount
    }
    
    func getHintLimit() -> Int {
        return self.hintLimit
    }
    
    func canHint() -> Bool {
        return self.hintLimit > self.hintCount
    }
    
    func getCanResume() -> Bool {
        return self.canResume
    }
    
    func getRecord() -> Record {
        return self.record ?? Record(name: "", difficulty: .Easy, errorCount: 10, hintCount: 0, score: 0)
    }
    
    func getScore() -> Int {
        return self.score
    }
    
    // Function to write a new value into the empty cell
    func writeValue(value: Int) {
        if (self.activeCell != [-1, -1] && self.puzzle[self.activeCell[0]][self.activeCell[1]] == 0) {
            self.puzzle[self.activeCell[0]][self.activeCell[1]] = value
            self.highlight = value
            self.previousCell = self.activeCell
            
            // Win game
            if (self.puzzle == self.solution) {
                self.score += 10 + 5 * combo
                self.combo += 1
                self.canResume = false
                self.record = Record(name: self.name, difficulty: self.difficulty, errorCount: self.errorCount, hintCount: self.hintCount, score: self.score)
                RecordManager.instance.addRecord(record: self.record!)
                SoundManager.instance.playSoundEffect(filename: "applause")
                return
            }
            
            // Wrong number
            if (value != self.solution[self.activeCell[0]][self.activeCell[1]]) {
                self.combo = 0
                self.score = self.score >= 10 ? self.score - 10 : 0
                self.error = true
                self.errorCount += 1
                
                // Lose game
                if (errorCount >= errorLimit) {
                    self.canResume = false
                    self.record = Record(name: self.name, difficulty: self.difficulty, errorCount: self.errorCount, hintCount: self.hintCount, score: self.score)
                    if (self.score >= 100) {
                        RecordManager.instance.addRecord(record: self.record!)
                    }
                    SoundManager.instance.playSoundEffect(filename: "failsound")
                } else {
                    SoundManager.instance.playSoundEffect(filename: "combobreak")
                }
            } else { // Correct number
                self.score += 10 + 5 * combo
                self.combo += 1
                SoundManager.instance.playSoundEffect(filename: "game-button-click")
            }
            
            save()
        }
    }
    
    func undo() {
        self.puzzle[self.activeCell[0]][self.activeCell[1]] = 0
        self.highlight = -1
        self.error = false
        save()
        SoundManager.instance.playSoundEffect(filename: "game-button-click")
    }
    
    func hint() {
        if (activeCell != [-1, -1] && self.puzzle[activeCell[0]][activeCell[1]] == 0) { // Hint at active cell
            self.puzzle[activeCell[0]][activeCell[1]] = self.solution[activeCell[0]][activeCell[1]]
            self.highlight = self.solution[activeCell[0]][activeCell[1]]
        } else { // Hint first occured empty cell
            outerLoop: for i in 0...8 {
                for j in 0...8 {
                    if (self.puzzle[i][j] == 0) {
                        self.puzzle[i][j] = self.solution[i][j]
                        self.highlight = self.solution[i][j]
                        self.activeCell = [i, j]
                        break outerLoop
                    }
                }
            }
        }
        
        // Win game
        if (self.puzzle == self.solution) {
            self.score += 5
            self.combo = 0
            self.canResume = false
            self.record = Record(name: self.name, difficulty: self.difficulty, errorCount: self.errorCount, hintCount: self.hintCount, score: self.score)
            RecordManager.instance.addRecord(record: self.record!)
            SoundManager.instance.playSoundEffect(filename: "applause")
            return
        }
        
        self.combo = 0
        self.score += 5
        self.hintCount += 1
        save()
        SoundManager.instance.playSoundEffect(filename: "game-button-click")
    }
    
    // Loading puzzles
    func loadNewPuzzle(name: String, difficulty: Difficulty) {
        let random = Int.random(in: 0 ..< Puzzle.easyDiff.count)
        
        // Initialize the game
        self.name = name
        self.difficulty = difficulty
        self.error = false
        self.errorCount = 0
        self.hintCount = 0
        self.canResume = true
        self.activeCell = [-1, -1]
        self.previousCell = [-1, -1]
        self.highlight = -1
        self.record = nil
        self.score = 0
        self.combo = 0
        
        switch (difficulty) {
        case .Easy:
            self.progressStr = Puzzle.easyDiff[random][0]
            self.solutionStr = Puzzle.easyDiff[random][1]
            self.errorLimit = 10
            self.hintLimit = 5
        case .Medium:
            self.progressStr = Puzzle.mediumDiff[random][0]
            self.solutionStr = Puzzle.mediumDiff[random][1]
            self.errorLimit = 5
            self.hintLimit = 3
        case .Hard:
            self.progressStr = Puzzle.hardDiff[random][0]
            self.solutionStr = Puzzle.hardDiff[random][1]
            self.errorLimit = 3
            self.hintLimit = 0
        }

        loadPuzzleFromStr(puzzle: self.progressStr, solution: self.solutionStr)
    }
    
    func resume() {
        if (self.canResume) { // Load resume game difficulty, since init() does not initialize difficulty
            switch (self.errorLimit) {
            case 10:
                self.difficulty = .Easy
            case 5:
                self.difficulty = .Medium
            case 3:
                self.difficulty = .Hard
            default:
                self.difficulty = .Easy
                self.errorLimit = 10
            }
            
            // Reset active cell, previous cell and highlight
            self.activeCell = [-1, -1]
            self.previousCell = [-1, -1]
            self.highlight = -1
            loadPuzzleFromStr(puzzle: self.progressStr, solution: self.solutionStr)
        }
    }
    
    // Convert string to 2D array sudoku puzzle
    func loadPuzzleFromStr(puzzle: String, solution: String) {        
        var count: Int = 0 // Current index of character in string
        var puzzleStr: String = puzzle
        var solutionStr: String = solution

        // Loop through the string and place into correct 2d array index
        while (!puzzleStr.isEmpty || !solutionStr.isEmpty) {
            let row: Int = count / 9
            let col: Int = count % 9
            let puzzleChar: Character = puzzleStr.removeFirst()
            let solutionChar: Character = solutionStr.removeFirst()

            if (puzzleChar >= "0" && puzzleChar <= "9" && solutionChar >= "0" && solutionChar <= "9") {
                let puzzleTemp = String(puzzleChar)
                var puzzleValue = Int(puzzleTemp) ?? 0
                let solutionTemp = String(solutionChar)
                let solutionValue = Int(solutionTemp) ?? 0
                
                // Handle app turn off before undo an error
                if (puzzleValue != 0 && puzzleValue != solutionValue) {
                    puzzleValue = 0
                    self.error = false
                }

                self.puzzle[row][col] = puzzleValue
                self.solution[row][col] = solutionValue
                count += 1
            }
        }
        
        save()
    }
    
    // Convert 2D array to string for saving purposes
    func puzzle2Str(puzzle: [[Int]]) -> String {
        var str = String()
        
        for row in 0 ..< 9 {
            for col in 0 ..< 9 {
                str.append(String(puzzle[row][col]))
            }
        }
        
        return str
    }
    
    // Update string so didset save into userdefaults
    func save() {
        self.progressStr = puzzle2Str(puzzle: self.puzzle)
    }
}
