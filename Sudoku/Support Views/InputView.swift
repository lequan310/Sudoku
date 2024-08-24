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

// 1-9 buttons, hint and undo buttons
struct InputView: View {
    @EnvironmentObject var game: Game
    @EnvironmentObject var settings: Settings
    let buttonSize: CGFloat = min(Screen.cellSize / 2, 30)
    
    var body: some View {
        VStack {
            optionsRow // Undo and Hint buttons
            numbersRow // 1 to 9 buttons
        }
//        .preferredColorScheme(settings.darkMode ? .dark : .light)
//        .environment(\.locale, Locale.init(identifier: settings.english ? "en" : "vi"))
    }
    
    var optionsRow: some View {
        HStack {
            // Undo Button
            Button(action: {
                let temp = self.game.getPreviousCell()
                if (temp != [-1, -1]) {
                    self.game.objectWillChange.send()
                    self.game.undo()
                }
            }, label: {
                self.renderButton(systemName: "gobackward", buttonName: "undo", condition: self.game.isError() && self.game.getCanResume())
            })
            .disabled(!self.game.isError() && !self.game.getCanResume() ? true : false)
            
            Spacer()
            
            // Hint Button
            Button(action: {
                self.game.objectWillChange.send()
                self.game.hint()
            }, label: {
                self.renderButton(systemName: "lightbulb", buttonName: "hint", condition: !self.game.isError() && self.game.getCanResume() && self.game.canHint())
            })
            .disabled(self.game.isError() || !self.game.getCanResume() || !self.game.canHint() ? true : false)
        }
        .padding()
    }
    
    func renderButton(systemName: String, buttonName: String, condition: Bool) -> some View {
        VStack {
            Image(systemName: systemName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: buttonSize)
                .foregroundColor(condition ? Color(UIColor(named: "InputColor")!) : Color(UIColor.secondaryLabel))
                .padding(2)
            Text(LocalizedStringKey(buttonName))
                .font(.custom("UVF Caviar Dreams Bold", size: buttonSize))
                .foregroundColor(condition ? Color(.label) : Color(UIColor.secondaryLabel))
                .frame(width: buttonSize * 4)
        }
    }
    
    var numbersRow: some View {
        HStack {
            ForEach(1 ..< 10) { num in
                Spacer()
                Button(action: {
                    self.game.objectWillChange.send()
                    self.game.writeValue(value: num)
                    self.game.setPreviousCell(row: self.game.getActiveCell()[0], col: self.game.getActiveCell()[1])
                }, label: {
                    Text("\(num)")
                        .font(.custom("UVF Caviar Dreams Bold", size: min(Screen.cellSize, 50)))
                        .foregroundColor(self.game.isError() ? Color(UIColor.secondaryLabel) : Color(.label))
                })
                .disabled(self.game.isError() ? true : false)
                Spacer()
            }
        }
        .padding(.vertical)
    }
}

struct InputView_Previews: PreviewProvider {
    static var testSettings: Settings = Settings()
    static var testGame: Game = Game()
    
    static var previews: some View {
        InputView()
            .environmentObject(testGame)
            .environmentObject(testSettings)
            .onAppear() {
                testGame.loadNewPuzzle(name: testSettings.playerName, difficulty: .Easy)
            }
    }
}
