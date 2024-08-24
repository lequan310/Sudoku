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

struct MenuView: View {
    @EnvironmentObject var viewHandler: ViewHandler
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var game: Game
    
    var body: some View {
        ZStack {
            VStack {
                // Game title
                Text("Sudoku")
                    .font(.custom("UVF Caviar Dreams Bold", size: TextSize.title))
                    .foregroundColor(Color(.label))
                    .shadow(radius: 10)
                    .padding(.bottom, Screen.height / 20)
                
                // Menu Buttons to navigate views
                Group {
                    ResumeButtonView(width: Screen.width, state: $viewHandler.state)
                    PlayButtonView(width: Screen.width, name: settings.playerName, difficulty: settings.difficulty, state: $viewHandler.state)
                        .modifier(DefaultButton(width: Screen.width))
                    MenuButtonView(buttonName: "leaderboard", imageName: "chart.bar.fill", width: Screen.width, state: $viewHandler.state, targetState: .leaderboard)
                        .modifier(DefaultButton(width: Screen.width))
                    MenuButtonView(buttonName: "howtoplay", imageName: "book.fill", width: Screen.width, state: $viewHandler.state, targetState: .help)
                        .modifier(DefaultButton(width: Screen.width))
                    MenuButtonView(buttonName: "settings", imageName: "gear", width: Screen.width, state: $viewHandler.state, targetState: .settings)
                        .modifier(DefaultButton(width: Screen.width))
                }
            }
        }
        // Initialize color scheme and language on launch
        .preferredColorScheme(settings.darkMode ? .dark : .light)
        .environment(\.locale, Locale.init(identifier: settings.english ? "en" : "vi"))
    }
}

struct MenuView_Previews: PreviewProvider {
    static var testSettings: Settings = Settings()
    static var testGame: Game = Game()

    static var previews: some View {
        MenuView()
            .environmentObject(ViewHandler())
            .environmentObject(testSettings)
            .environmentObject(testGame)
    }
}

struct PlayButtonView: View {
    @EnvironmentObject var game: Game
    private var name: String
    private var buttonWidth: CGFloat
    private var textOffset: CGFloat
    private var iconPosition: [CGFloat]
    private var difficulty: Difficulty
    @Binding var state: ViewState

    init(width: CGFloat, name: String, difficulty: Difficulty, state: Binding<ViewState>) {
        self.buttonWidth = width * 0.65
        self.textOffset = self.buttonWidth * 0.32
        self.iconPosition = [self.buttonWidth * 0.16, TextSize.normal / 2]
        self.name = name
        self.difficulty = difficulty
        self._state = state
    }
    
    var body: some View {
        Button(action: {
            withAnimation {
                // Load new puzzle, play sound, change to game view
                self.game.loadNewPuzzle(name: self.name, difficulty: self.difficulty)
                self.state = ViewState.game
                SoundManager.instance.playSoundEffect(filename: "check-on")
            }
        }, label: {
            ZStack(alignment: .leading) {
                Image(systemName: "gamecontroller.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .position(x: self.iconPosition[0], y: self.iconPosition[1])
                    .frame(height: TextSize.normal)
                    .foregroundColor(.white)
                Text(LocalizedStringKey("new-game"))
                    .font(.custom("UVF Caviar Dreams Bold", size: TextSize.normal))
                    .offset(x: self.textOffset)
            }
            .frame(width: buttonWidth, height: min(Screen.height / 15, Screen.width / 8), alignment: .leading)
        })
    }
}

struct ResumeButtonView: View {
    @EnvironmentObject var game: Game
    private var buttonWidth: CGFloat
    private var textOffset: CGFloat
    private var iconPosition: [CGFloat]
    @Binding var state: ViewState
    
    init(width: CGFloat, state: Binding<ViewState>) {
        self.buttonWidth = width * 0.65
        self.textOffset = self.buttonWidth * 0.32
        self.iconPosition = [self.buttonWidth * 0.16, TextSize.normal / 2]
        self._state = state
    }
    
    var body: some View {
        Button(action: {
            withAnimation {
                // Load unfinished puzzle and go to game view
                if (self.game.getCanResume()) {
                    self.game.resume()
                    self.state = .game
                }
                SoundManager.instance.playSoundEffect(filename: "check-on")
            }
        }, label: {
            ZStack(alignment: .leading) {
                Image(systemName: "hourglass.bottomhalf.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .position(x: self.iconPosition[0], y: self.iconPosition[1])
                    .frame(height: TextSize.normal)
                    .foregroundColor(self.game.getCanResume() ? Color(.label) : nil)
                Text(LocalizedStringKey("resume"))
                    .font(.custom("UVF Caviar Dreams Bold", size: TextSize.normal))
                    .offset(x: self.textOffset)
            }
            .frame(width: buttonWidth, height: min(Screen.height / 15, Screen.width / 8), alignment: .leading)
            .background(Color(UIColor(named: "LightBlue")!))
            .foregroundColor(self.game.getCanResume() ? Color(.label) : nil)
            .cornerRadius(40)
            .padding(TextSize.small / 3)
            .shadow(radius: TextSize.small)
        })
        .disabled(self.game.getCanResume() ? false : true)
    }
}

struct MenuButtonView: View {
    private var buttonName: String
    private var imageName: String
    private var buttonWidth: CGFloat
    private var textOffset: CGFloat
    private var iconPosition: [CGFloat]
    @Binding var state: ViewState
    private var targetState: ViewState
    
    init(buttonName: String, imageName: String, width: CGFloat, state: Binding<ViewState>, targetState: ViewState) {
        self.buttonName = buttonName
        self.imageName = imageName
        self.buttonWidth = width * 0.65
        self.textOffset = self.buttonWidth * 0.32
        self.iconPosition = [self.buttonWidth * 0.16, TextSize.normal / 2]
        self._state = state
        self.targetState = targetState
    }
    
    var body: some View {
        Button(action: {
            withAnimation {
                // Change to the desired view
                state = targetState
                SoundManager.instance.playSoundEffect(filename: "check-on")
            }
        }, label: {
            ZStack(alignment: .leading) {
                Image(systemName: self.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .position(x: self.iconPosition[0], y: self.iconPosition[1])
                    .frame(height: TextSize.normal)
                Text(LocalizedStringKey(self.buttonName))
                    .font(.custom("UVF Caviar Dreams Bold", size: TextSize.normal))
                    .offset(x: self.textOffset)
            }
            .frame(width: buttonWidth, height: min(Screen.height / 15, Screen.width / 8), alignment: .leading)
        })
    }
}

struct DefaultButton: ViewModifier {
    private var buttonWidth: CGFloat
    
    init(width: CGFloat) {
        self.buttonWidth = width * 0.65
    }
    
    func body(content: Content) -> some View {
        content
            .background(Color(UIColor(named: "DarkGray")!))
            .cornerRadius(40)
            .padding(TextSize.small / 3)
            .foregroundColor(.white)
            .shadow(radius: TextSize.small)
    }
}
