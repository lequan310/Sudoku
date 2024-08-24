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

// State to switch views in the main view (ContentView)
enum ViewState {
    case menu, settings, help, leaderboard, game
}

final class ViewHandler: ObservableObject {
    @Published var state: ViewState

    init() {
        self.state = ViewState.menu // MenuView on launch
    }
}
