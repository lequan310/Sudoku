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

struct HowToPlayView: View {
    @EnvironmentObject var viewHandler: ViewHandler
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        VStack {
            TopBarView(title: "howtoplay", state: $viewHandler.state)
            Divider()
                .background(Color(.secondaryLabel))

            List {
                listSection(header: "introduction", content: "introduction.content")
                listSection(header: "rules", content: "rules.content")
                listSection(header: "difficulty", content: "difficulty.content")
            }
            .scrollContentBackground(.hidden)
            .listStyle(.sidebar)
            .padding(.top, TextSize.small / 3)
        }
        .preferredColorScheme(settings.darkMode ? .dark : .light)
        .environment(\.locale, Locale.init(identifier: settings.english ? "en" : "vi"))
    }
}

func listSection(header: String, content: String) -> some View {
    Section {
        Text(LocalizedStringKey(content))
            .font(.custom("VNF-Caviar Dreams", size: TextSize.small))
            .tracking(1)
    } header: {
        Text(LocalizedStringKey(header))
            .font(.custom("UVF Caviar Dreams Bold", size: TextSize.normal))
    }
    .headerProminence(.increased)
    .listRowBackground(Color(UIColor.quaternarySystemFill))

}

struct HowToPlayView_Previews: PreviewProvider {
    static var previews: some View {
        HowToPlayView()
            .environmentObject(Settings())
            .environmentObject(ViewHandler())
    }
}
