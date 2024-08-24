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

struct LeaderboardView: View {
    @EnvironmentObject var viewHandler: ViewHandler
    @EnvironmentObject var settings: Settings
    private var recordList: [Record]
    
    init() {
        // Retrieve the list of records, then sort by achievement, then score
        self.recordList = RecordManager.instance.getRecordList().sorted { (lhs, rhs) in
            if (lhs.getAchievement().rawValue == rhs.getAchievement().rawValue) {
                return lhs.getScore() > rhs.getScore()
            }
            return lhs.getAchievement().rawValue > rhs.getAchievement().rawValue
        }
    }
    
    var body: some View {
        VStack {
            TopBarView(title: "leaderboard", state: $viewHandler.state)
            Divider()
                .background(Color(.secondaryLabel))
             
            ScrollView {
                ForEach(Array(self.recordList.enumerated())[0 ..< min(recordList.count, 20)], id: \.offset) { index, record in
                    HStack {
                        Image(record.getAchievementImage())
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: Screen.cellSize * 1.8)
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text(record.getName())
                                    .font(.custom("UVF Caviar Dreams Bold", size: TextSize.normal * 1.2))
                                    .fixedSize()
                                    .lineLimit(1)
                                Spacer()
                            }
                            
                            Spacer()
                            
                            HStack {
                                Text(LocalizedStringKey("score: \(record.getScore())"))
                                    .font(.custom("UVF Caviar Dreams Bold", size: TextSize.normal * 1.2))
                                    .fixedSize()
                                    .lineLimit(1)
                                Spacer()
                            }

                        }
                        .padding(.horizontal, TextSize.vSpacing)
                        .padding(.vertical, TextSize.vSpacing / 2)
                        
                        Spacer()
                        
                        VStack {
                            HStack {
                                Spacer()
                                Text(LocalizedStringKey(record.getDifficulty().rawValue))
                                    .font(.custom("UVF Caviar Dreams Bold", size: TextSize.normal))
                            }
                            Spacer()
                        }
                        .padding(TextSize.vSpacing / 2)
                    }
                    .frame(height: Screen.cellSize * 1.8)
                    .padding(.leading, Screen.cellSize / 2)
                    .padding(.trailing, TextSize.normal / 4)
                    .padding(.bottom, TextSize.normal)
                    .padding(.top, TextSize.small * 0.5)
                    .border(width: 2, edges: [.bottom], color: Color(.tertiarySystemFill))
                }
            }
        }
        .preferredColorScheme(settings.darkMode ? .dark : .light)
        .environment(\.locale, Locale.init(identifier: settings.english ? "en" : "vi"))
    }
}

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]
    
    func path(in rect: CGRect) -> Path {
        edges.map { edge -> Path in
            switch edge {
            case .top: return Path(.init(x: rect.minX, y: rect.minY, width: rect.width, height: width))
            case .bottom: return Path(.init(x: rect.minX, y: rect.maxY - width, width: rect.width, height: width))
            case .leading: return Path(.init(x: rect.minX, y: rect.minY, width: width, height: rect.height))
            case .trailing: return Path(.init(x: rect.maxX - width, y: rect.minY, width: width, height: rect.height))
            }
        }.reduce(into: Path()) { $0.addPath($1) }
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
            .environmentObject(Settings())
            .environmentObject(ViewHandler())
    }
}
