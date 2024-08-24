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

import SwiftUI

// 9x9 grid for the sudoku game
struct GridView: View {
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var game: Game
    private let frameSize: CGFloat = min(Screen.cellSize, 80) * 9
    
    var body: some View {
        ZStack {
            self.renderStructure(width: frameSize / 9)
            self.renderLines(width: frameSize / 9)
        }
        .frame(width: frameSize, height: frameSize, alignment: .center)
        //.preferredColorScheme(settings.darkMode ? .dark : .light)
    }
    
    // Function to render a single cell
    private func renderCell(row: Int, col: Int, fontSize: CGFloat) -> Text {
        let value = game.getValueAt(row: row, col: col)
        var color = Color(.label) // Default cell color
        
        // Empty cell
        if (value == 0) {
            return Text(" ")
        }
        
        if (value != game.getSolution()[row][col]) {
            color = Color(.red) // Wrong cell
        } else if (self.game.getActiveCell() == [row, col]) {
            // Selected Cell
            color = Color(UIColor(named: "InputColor")!)
        }
        
        return Text("\(value)")
            .font(.custom("UVF Caviar Dreams Bold", size: fontSize))
            .foregroundColor(color)
    }
    
    // Function to draw all the cells
    private func renderStructure(width: CGFloat) -> some View {
        VStack(spacing: -1) {
            ForEach(0 ..< 9) { row in
                HStack(spacing: -1) {
                    ForEach(0 ..< 9) { col in
                        self.renderCell(row: row, col: col, fontSize: TextSize.normal * 1.25)
                            .frame(width: width, height: width)
                            .border(Color.black, width: 1)
                            .padding(.all, 0)
                            .background(self.game.getActiveCell() == [row, col] ? Color(UIColor(named: "ActiveCell")!) : self.game.getValueAt(row: row, col: col) == self.game.getHightlight() && self.game.getHightlight() != 0 ? Color(UIColor(named: "Hightlight")!) : Color(UIColor(named: "CellBackground")!))
                            .onTapGesture {
                                if (!self.game.isError() && self.game.getCanResume()) {
                                    self.game.objectWillChange.send()
                                    self.game.setActiveCell(row: row, col: col)
                                    self.game.setHightlight(value: self.game.getValueAt(row: row, col: col))
                                    SoundManager.instance.playSoundEffect(filename: "menuhit")
                                }
                            }
                    }
                }
            }
        }
    }
    
    // Function to render the black line seperators between the 3x3 squares
    private func renderLines(width: CGFloat) -> some View {
        GeometryReader { geometry in
            Path { path in
                let factor: CGFloat = width * 3
                let lines: [CGFloat] = [1, 2]
                
                // Draw 2 vertical black lines
                for line in lines {
                    let vpos = line * factor
                    path.move(to: CGPoint(x: vpos, y: 4))
                    path.addLine(to: CGPoint(x: vpos, y: geometry.size.height - 4))
                }
                
                // Draw 2 horizontal black lines
                for line in lines {
                    let hpos = line * factor
                    path.move(to: CGPoint(x: 4, y: hpos))
                    path.addLine(to: CGPoint(x: geometry.size.width - 4, y: hpos))
                }
            }
            .stroke(lineWidth: 2)
            .foregroundColor(.black)
        }
    }
}

struct GridView_Previews: PreviewProvider {
    static var testSettings: Settings = Settings()
    static var testGame: Game = Game()
    
    static var previews: some View {
        GridView()
            .environmentObject(testGame)
            .environmentObject(testSettings)
            .onAppear() {
                testGame.loadNewPuzzle(name: testSettings.playerName, difficulty: testSettings.difficulty)
            }
    }
}
