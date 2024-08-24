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

// View title and back button
struct TopBarView: View {
    @Binding var state: ViewState
    private var title: String
    
    init(title: String, state: Binding<ViewState>) {
        self.title = title
        self._state = state
    }
    
    var body: some View {
        ZStack {
            // View Title
            Text(LocalizedStringKey(title))
                .font(.custom("UVF Caviar Dreams Bold", size: TextSize.big))
            
            BackButtonView(state: $state)
        }
        .padding(.top, TextSize.small / 4)
        .padding(.bottom, TextSize.small / 4)
        .padding(.horizontal, TextSize.small / 2)
    }
}

struct TopBarView_Previews: PreviewProvider {
    @State static var testState: ViewState = .settings
    
    static var previews: some View {
        TopBarView(title: "Settings", state: $testState)
    }
}
