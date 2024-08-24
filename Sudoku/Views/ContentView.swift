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

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var viewHandler: ViewHandler
    private var settings: Settings = Settings()
    private var game: Game = Game()
    
    var body: some View {
        ZStack {
            switch viewHandler.state {
            case .menu:
                MenuView()
                    .transition(.slideRight)
                    .environmentObject(settings)
                    .environmentObject(game)
                    .onAppear() {
                        // Play music when menu view appear
                        SoundManager.instance.stopSound()
                        SoundManager.instance.playMusic(filename: "menu")
                    }
            case .settings:
                SettingsView()
                    .transition(.slideLeft)
                    .environmentObject(settings)
            case .help:
                HowToPlayView()
                    .transition(.slideLeft)
                    .environmentObject(settings)
            case .leaderboard:
                LeaderboardView()
                    .transition(.slideLeft)
                    .environmentObject(settings)
            case .game:
                GameView()
                    .transition(.slideLeft)
                    .environmentObject(settings)
                    .environmentObject(game)
                    .onAppear() {
                        // Stop menu music
                        SoundManager.instance.stopAndResetMusic()
                    }
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if (newPhase == .active) {
                SoundManager.instance.resumeSound()
            } else if (newPhase == .inactive) {
                SoundManager.instance.fadeSound()
            } else if (newPhase == .background) {
                SoundManager.instance.stopMusic()
                SoundManager.instance.stopSound()
            }
        }
    }
}

extension AnyTransition {
    static var slideLeft: AnyTransition {
        AnyTransition.asymmetric(insertion: AnyTransition.opacity.combined(with: .move(edge: .trailing)), removal: AnyTransition.opacity.combined(with: .move(edge: .leading)))
    }
    
    static var slideRight: AnyTransition {
        AnyTransition.asymmetric(insertion: AnyTransition.opacity.combined(with: .move(edge: .leading)), removal: AnyTransition.opacity.combined(with: .move(edge: .trailing)))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewHandler())
    }
}
