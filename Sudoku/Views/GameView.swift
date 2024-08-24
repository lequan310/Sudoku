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

struct GameView: View {
    @EnvironmentObject var viewHandler: ViewHandler
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var game: Game
    
    var body: some View {
        ZStack {
            VStack {
                TopBarView(title: "Sudoku", state: $viewHandler.state)
                Divider()
                
                HStack {
                    Text(LocalizedStringKey("error: \(self.game.getErrorCount()) / \(self.game.getErrorLimit())"))
                        .font(.custom("UVF Caviar Dreams Bold", size: Screen.cellSize / 3))
                    
                    Spacer()
                    
                    Text(LocalizedStringKey("score: \(self.game.getScore())"))
                        .font(.custom("UVF Caviar Dreams Bold", size: Screen.cellSize / 3))
                    
                    Spacer()
                    
                    Text(LocalizedStringKey("hint: \(self.game.getHintCount()) / \(self.game.getHintLimit())"))
                        .font(.custom("UVF Caviar Dreams Bold", size: Screen.cellSize / 3))

                }
                .padding(.top, TextSize.small / 3)
                .padding(.horizontal, TextSize.small)
                
                GridView()
                
                Spacer()
                
                InputView()
                
                Spacer()
                Spacer()
            }
            .opacity(game.getCanResume() ? 1 : 0.2)
            .background(game.getCanResume() ? Color(.systemBackground) : Color(.secondaryLabel))
            
            popup
        }
        .preferredColorScheme(settings.darkMode ? .dark : .light)
        .environment(\.locale, Locale.init(identifier: settings.english ? "en" : "vi"))
    }
}

extension GameView {
    var popup: some View {
        VStack {
            Text(game.isError() ? LocalizedStringKey("rip") :  LocalizedStringKey("congratulations"))
                .font(.custom("UVF Caviar Dreams Bold", size: TextSize.big * 1.1))
                .padding(.bottom, TextSize.normal)
            
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: TextSize.small / 2) {
                        HStack {
                            Text("player: \(game.getName())")
                                .font(.custom("UVF Caviar Dreams Bold", size: TextSize.normal))
                                .fixedSize()
                                .lineLimit(1)
                            Spacer()
                        }
                        HStack {
                            Text(LocalizedStringKey("difficulty: \(Text(LocalizedStringKey(game.getDifficulty().rawValue)))"))
                                .font(.custom("UVF Caviar Dreams Bold", size: TextSize.normal))
                                .fixedSize()
                                .lineLimit(1)
                            Spacer()
                        }
                        HStack {
                            Text(LocalizedStringKey("score: \(game.getScore())"))
                                .font(.custom("UVF Caviar Dreams Bold", size: TextSize.normal))
                                .fixedSize()
                                .lineLimit(1)
                            Spacer()
                        }
                    }
                    .padding(TextSize.vSpacing)
                    
                    Spacer()
                    
                    Image(game.getRecord().getAchievementImage())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: Screen.width * 0.3)
                        .padding(.vertical)
                }
                .padding(.trailing, TextSize.small)
                .padding(.leading, TextSize.small / 2)
            }
            
                        
            Spacer()
            
            Button(action: {
                withAnimation(.easeIn) {
                    viewHandler.state = .menu
                }
            }, label: {
                HStack {
                    Spacer()
                    Text(LocalizedStringKey("leave"))
                        .font(.custom("UVF Caviar Dreams Bold", size: TextSize.normal))
                    Spacer()
                }
                .frame(width: Screen.width * 0.55, height: TextSize.big * 1.6)
                .background(Color(red: 50/255, green: 50/255, blue: 50/255))
                .cornerRadius(40)
                .foregroundColor(.white)
                .shadow(radius: TextSize.normal)
            })
            
            Spacer()
        }
        .padding(.top, TextSize.big)
        .frame(width: game.getCanResume() ? Screen.width * 0.6 : Screen.width * 0.8, height: game.getCanResume() ? Screen.width * 0.6 : Screen.width * 0.8)
        .background(Color(.systemBackground))
        .cornerRadius(TextSize.small)
        .opacity(game.getCanResume() ? 0 : 1)
        .animation(.interpolatingSpring(mass: 2, stiffness: 200, damping: 20), value: game.getHightlight())
    }
}

struct GameView_Previews: PreviewProvider {
    static var testSettings: Settings = Settings()
    static var testGame: Game = Game()

    static var previews: some View {
        GameView()
            .environmentObject(ViewHandler())
            .environmentObject(testSettings)
            .environmentObject(testGame)
            .onAppear() {
                testGame.loadNewPuzzle(name: testSettings.playerName, difficulty: testSettings.difficulty)
            }
    }
}
