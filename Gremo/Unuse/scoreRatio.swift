//
//  scoreRatio.swift
//  Gremo
//
//  Created by Andy Lin on 2023/7/23.
//

import SwiftUI
import Charts

struct scoreRatio:View {
    let chineseWeighted = UserDefaults.standard.integer(forKey: "ChineseWeightedScore")
    let englishWeighted = UserDefaults.standard.integer(forKey: "EnglishWeightedScore")
    let mathWeight = UserDefaults.standard.integer(forKey: "MathWeightedScore")
    let scienceWeight = UserDefaults.standard.integer(forKey: "ScienceWeightedScore")
    let historyWeight = UserDefaults.standard.integer(forKey: "HistoryWeightedScore")
    let civicsWeight = UserDefaults.standard.integer(forKey: "CivicsWeightedScore")
    let geographyWeight = UserDefaults.standard.integer(forKey: "GeographyWeightedScore")
    let socialWeighted = UserDefaults.standard.integer(forKey: userdefaultsKey.SocialWeightedScore.rawValue)
    let listeningWeight = UserDefaults.standard.integer(forKey: "ListeningWeightedScore")
    let compositionWeight = UserDefaults.standard.integer(forKey: "CompositionWeightedScore")
    
    let subjectChinese = ["國文", "英文", "數學", "理化", "歷史", "公民", "地理", "社會", "英聽", "作文"]
    
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var pickerValue = "全部"
    @State private var hasWieghted = true
    @State private var weighted = [5, 3, 4, 3, 1, 1, 1, 1, 1]
    @State private var colorList: [colorChoice] = [colorChoice.lightBlue, colorChoice.yellow ]
    @State private var maxScore = 2000
    @State private var animate = false
    @State var returnValue1: [Int] = []
    @State private var ScoreByChart: [Score1] = [.init(name: "", count: 0, color: .accentColor)]
    @State private var jjj = 0
    
    private var isLight: Bool {
        colorScheme == .light
    }
    
    let scoreDetails: KeyValuePairs<String, Color> = [
        "國文": chartColor(.lightBlue),
        "英文": chartColor(.yellow),
        "數學": chartColor(.green),
        "理化": chartColor(.purpleBlue),
        "歷史": chartColor(.purple),
        "公民": chartColor(.orange),
        "地理": chartColor(.greenblue),
        "社會": chartColor(.blue),
        "英聽": chartColor(.pink),
        "作文": chartColor(.brown)
    ]
    
    func chartValueDecide(_ newValue: String) {
        
        ScoreByChart = []
        maxScore = 0
        
        if newValue == "全部" {
            jjj = 0
            if hasWieghted {
                weighted = [chineseWeighted,
                            englishWeighted,
                            mathWeight,
                            scienceWeight,
                            historyWeight,
                            civicsWeight,
                            geographyWeight,
                            socialWeighted,
                            listeningWeight,
                            compositionWeight]
            }else {
                weighted = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
            }
            colorList = [.lightBlue,
                         .yellow,
                         .green,
                         .purpleBlue,
                         .purple,
                         .orange,
                         .greenblue,
                         .blue,
                         .pink,
                         .brown]
            
        }else if newValue == "文科" {
            if hasWieghted {
                weighted = [chineseWeighted,
                            englishWeighted,
                            listeningWeight,
                            compositionWeight]
            }else {
                weighted = [1, 1, 1, 1]
            }
            colorList = [.lightBlue,
                         .yellow,
                         .pink,
                         .brown]
            
        }else if newValue == "數理科" {
            jjj = 2
            if hasWieghted {
                weighted = [mathWeight, scienceWeight]
            }else {
                weighted = [1, 1]
            }
            colorList = [.green,
                         .purpleBlue,
                         ]
        }else if newValue == "社會科" {
            if !UserDefaults.standard.bool(forKey: "isSocialOn") {
                jjj = 4
                if hasWieghted {
                    weighted = [historyWeight,
                                civicsWeight,
                                geographyWeight]
                }else {
                    weighted = [1, 1, 1]
                }
                colorList = [.purple,
                             .orange,
                             .greenblue
                ]
            }else {
                jjj = 7
                weighted = [1]
                colorList = [.blue]
            }
        }
        
        if newValue != "文科" {
            for i in 0..<weighted.count {
                ScoreByChart.append(.init(name: "總分", count: returnValue1[i + jjj] * weighted[i], color: chartColor(colorList[i])))
                //增加.init(name: "總分", count: returnValue1[i] * weighted[i], color: chartColor(colorList[i]))到ScoreByChart中
                maxScore += weighted[i] * 100
            }
        }else {
            for i in 0..<weighted.count {
                if i < 2 {
                    jjj = 0
                }else {
                    jjj = 6
                }
                
                ScoreByChart.append(.init(name: "總分", count: returnValue1[i + jjj] * weighted[i], color: chartColor(colorList[i])))
                maxScore += weighted[i] * 100
            }
        }
        
        animate = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            animate = false
        }
    }
    
    var body: some View{
        VStack{
            HStack{
                Text("分數佔比")
                    .font(.title3.bold())
                Spacer()
            }
            HStack{
                Text("加權分")
                    .padding(.trailing, 90)
                Picker("", selection: $hasWieghted) {
                    Text("開啟")
                        .tag(true)
                    Text("關閉")
                        .tag(false)
                }
                .pickerStyle(.segmented)
                .onChange(of: hasWieghted) { newValue in
                    chartValueDecide(pickerValue)
                }
            }
            .padding(.horizontal, 10)
            HStack{
                Text("類型")
                    .padding(.trailing, 50)
                Picker("", selection: $pickerValue) {
                    Text("全部")
                        .tag("全部")
                    Text("文科")
                        .tag("文科")
                    Text("數理科")
                        .tag("數理科")
                    Text("社會科")
                        .tag("社會科")
                }
                .pickerStyle(.segmented)
                .onChange(of: pickerValue) { newValue in
                    chartValueDecide(newValue)
                }
            }
            .padding(.horizontal, 10)
            
            Chart(ScoreByChart) { item in
                BarMark(
                    x: .value("總分長條圖", item.count),
                    y: .value("總分", item.name)
                )
                .foregroundStyle(item.color)
            }
            .padding(.horizontal, 10)
            .animation(.easeInOut(duration: 1), value: animate)
            .chartXScale(domain: 0...maxScore)
            .chartForegroundStyleScale(scoreDetails)
            .frame(height: 110)
            .onAppear{
                let scope = UserDefaults.standard.integer(forKey: "scope")
                
                returnValue1 = [
                    UserDefaults.standard.integer(forKey: "ChineseScore\(scope)"),
                    UserDefaults.standard.integer(forKey: "EnglishScore\(scope)"),
                    UserDefaults.standard.integer(forKey: "MathScore\(scope)"),
                    UserDefaults.standard.integer(forKey: "ScienceScore\(scope)"),
                    UserDefaults.standard.integer(forKey: "HistoryScore\(scope)"),
                    UserDefaults.standard.integer(forKey: "CivicsScore\(scope)"),
                    UserDefaults.standard.integer(forKey: "GeographyScore\(scope)"),
                    UserDefaults.standard.integer(forKey: "SocialScore\(scope)"),
                    UserDefaults.standard.integer(forKey: "ListeningScore\(scope)"),
                    UserDefaults.standard.integer(forKey: "CompositionScore\(scope)"),
                    UserDefaults.standard.integer(forKey: "AllScore\(scope)")]
                
                chartValueDecide("全部")
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(isLight ? Color(red: 0.937, green: 0.937, blue: 0.959):
                        Color(red: 0.11, green: 0.11, blue: 0.118))
        }
    }
}

struct scoreRatio_Previews: PreviewProvider {
    static var previews: some View {
        scoreRatio()
    }
}
