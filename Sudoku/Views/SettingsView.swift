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

struct SettingsView: View {
    @EnvironmentObject var viewHandler: ViewHandler
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        ScrollView {
            TopBarView(title: "settings", state: $viewHandler.state)
            Divider()
                .background(Color(.secondaryLabel))

            Section {
                VStack(spacing: TextSize.vSpacing / 5) {
                    HStack {
                        Text(LocalizedStringKey("playername"))
                            .font(.custom("UVF Caviar Dreams Bold", size: TextSize.normal))
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    TextField("Enter player name here...", text: $settings.playerName)
                        .font(.custom("UVF Caviar Dreams Bold", size: TextSize.normal))
                        .frame(height: TextSize.normal * 2)
                        .cornerRadius(6)
                        .modifier(TextFieldModifier(horizontalPadding: TextSize.small, verticalPadding: TextSize.small / 3, cornerRadius: TextSize.small / 2, lineWidth: TextSize.small / 6))
                }
                
                VStack(spacing: TextSize.vSpacing) {
                    SelectSettingView(select: $settings.difficulty, name: "difficulty", description: "difficulty.description") // Difficulty selection
                    ToggleSettingView(toggle: $settings.darkMode,
                                      name: "darkmode",
                                      description: "darkmode.description") // Dark mode toggle
                    ToggleSettingView(toggle: $settings.english,
                                      name: "language",
                                      description: "language.description") // Language toggle
                }
            }
            .padding(.horizontal, TextSize.small)
            .padding(.top, TextSize.small)
        }
        .preferredColorScheme(settings.darkMode ? .dark : .light)
        .environment(\.locale, Locale.init(identifier: settings.english ? "en" : "vi"))
    }
}

struct TextFieldModifier: ViewModifier {
    let horizontalPadding: CGFloat
    let verticalPadding: CGFloat
    let cornerRadius: CGFloat
    let lineWidth: CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(Color(UIColor.tertiarySystemFill), lineWidth: lineWidth))
            .cornerRadius(cornerRadius)
            .background(Color(UIColor.quaternarySystemFill))
    }
}

struct SelectSettingView: View {
    var select: Binding<Difficulty>
    var name: String
    var description: String
    
    init(select: Binding<Difficulty>, name: String, description: String) {
        self.select = select
        self.name = name
        self.description = description
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: TextSize.vSpacing / 3) {
            HStack(alignment: .center) {
                Text(LocalizedStringKey(name))
                    .font(.custom("UVF Caviar Dreams Bold", size: TextSize.normal))
                
                Spacer()

                Picker(selection: select, label: Text("")) {
                    ForEach(Difficulty.allCases, id: \.self) {
                        Text(LocalizedStringKey($0.rawValue)).tag($0)
                    }
                }
                .accentColor(Color(.label))
                .background(Color(UIColor.quaternarySystemFill))
                .cornerRadius(6)
            }
            
            Text(LocalizedStringKey(description))
                .font(.custom("UVF Caviar Dreams Bold", size: TextSize.small))
                .foregroundColor(.secondary)
        }
    }
}

struct ToggleSettingView: View {
    var toggle: Binding<Bool>
    var name: String
    var description: String
    
    init(toggle: Binding<Bool>, name: String, description: String) {
        self.toggle = toggle
        self.name = name
        self.description = description
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: TextSize.vSpacing / 3) {
            Toggle(isOn: toggle) {
                Text(LocalizedStringKey(name))
                    .font(.custom("UVF Caviar Dreams Bold", size: TextSize.normal))
            }
            
            Text(LocalizedStringKey(description))
                .font(.custom("UVF Caviar Dreams Bold", size: TextSize.small))
                .foregroundColor(.secondary)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(Settings())
            .environmentObject(ViewHandler())
    }
}
