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

struct BackButtonView: View {
    @Binding var state: ViewState
    
    var body: some View {
        HStack {
            Button(action: {
                withAnimation(.easeIn) {
                    // Return to menu
                    state = .menu
                    SoundManager.instance.playSoundEffect(filename: "check-off")
                }
            }, label: {
                Image(systemName: "chevron.left")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: TextSize.normal * 0.9)
                Text(LocalizedStringKey("back"))
                    .font(.custom("UVF Caviar Dreams Bold", size: TextSize.normal * 0.9))
            })
            .foregroundColor(Color(.label))
            
            Spacer()
        }
    }
}
