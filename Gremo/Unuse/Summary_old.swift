//
//  Summary_old.swift
//  Gremo
//
//  Created by Andy Lin on 2023/12/10.
//

import Foundation
import SwiftUI
import Charts

struct LineChart: Identifiable{
    var id = UUID()
    var count: Double
    var name: String
    var color: Color
}

struct AllLineValue: Identifiable {
    var id: String
    var value: [LineChart]
}

struct SubjectLink: Identifiable {
    var id = UUID()
    var label: String
    var key: String
    var scope = 1
    var average: Double = 0
}

struct Summary_old: View {
    @EnvironmentObject var globalViewModel: GremoViewModel
    @Environment(\.colorScheme) private var colorScheme
    
    @State var ShowEdit = false
    
    @State private var allSummary: [LineChart] = []
    @State private var chineseSummary: [LineChart] = []
    @State private var englishSummary: [LineChart] = []
    @State private var mathSummary: [LineChart] = []
    @State private var scienceSummary: [LineChart] = []
    @State private var historySummary: [LineChart] = []
    @State private var civicsSummary: [LineChart] = []
    @State private var geographySummary: [LineChart] = []
    @State private var socialSummary: [LineChart] = []
    @State private var listeningSummary: [LineChart] = []
    @State private var compositionSummary: [LineChart] = []
    @State private var allValue: [AllLineValue] = []
    
    let subjectLink: [SubjectLink] = [.init(label: "", key: "Average"),
                                      .init(label: "國文", key: "Chinese"),
                                      .init(label: "英文", key: "English"),
                                      .init(label: "數學", key: "Math"),
                                      .init(label: "理化", key: "Science"),
                                      .init(label: "歷史", key: "History"),
                                      .init(label: "公民", key: "Civics"),
                                      .init(label: "地理", key: "Geography"),
                                      .init(label: "社會", key: "Social"),
                                      .init(label: "英聽", key: "Listening"),
                                      .init(label: "作文", key: "Composition")]
    
    private var isLight: Bool {
        colorScheme == .light
    }
    
    //MARK: - scope(for: Int) -> String
    private func scope(for scope: Int) -> String{
        switch scope {
        case 1:
            return "一週"
        case 2:
            return "一段"
        case 3:
            return "二週"
        case 4:
            return "二段"
        case 5:
            return "三週"
        case 6:
            return "三段"
        default:
            return "e04怎麼有bug"
        }
    }
    
    //MARK: - build chart value
    private func buildChartValue() {
        
        let hhh: [State<[LineChart]>] = [_chineseSummary, _englishSummary, _mathSummary, _scienceSummary, _historySummary, _civicsSummary, _geographySummary, _socialSummary, _listeningSummary, _compositionSummary, _allSummary]
        
        let subject: [String] = ["Chinese", "English", "Math", "Science", "History", "Civics", "Geography", "Social", "Listening", "Composition", "Average"]
        
        let colorList: [Color] = [
            chartColor(.lightBlue),
            chartColor(.yellow),
            chartColor(.green),
            chartColor(.purpleBlue),
            chartColor(.purple),
            chartColor(.orange),
            chartColor(.greenblue),
            chartColor(.blue),
            chartColor(.pink),
            chartColor(.brown),
            .accentColor]
        
        allSummary = []
        chineseSummary = []
        englishSummary = []
        mathSummary = []
        scienceSummary = []
        historySummary = []
        civicsSummary = []
        geographySummary = []
        socialSummary = []
        listeningSummary = []
        compositionSummary = []
        
        for index in 0..<hhh.count {
            for i in 0..<6 {
                let key = "\(subject[index])Score\(i + 1)"
                if UserDefaults.standard.double(forKey: key) != 0 {
                    let count = UserDefaults.standard.double(forKey: key)
                    
                    hhh[index].wrappedValue.append(LineChart(count: count,
                                                             name: scope(for: i + 1),
                                                             color: colorList[index]))
                }
            }
        }
    }
    
    //MARK: - scale( ) -> chart scale
    private func scale() -> KeyValuePairs<String, Color> {
        return ["平均": .accentColor,
                "國文": chartColor(.lightBlue),
                "英文": chartColor(.yellow),
                "數學": chartColor(.green),
                "理化": chartColor(.purpleBlue),
                "歷史": chartColor(.purple),
                "公民": chartColor(.orange),
                "地理": chartColor(.greenblue),
                "社會": chartColor(.blue),
                "英聽": chartColor(.pink),
                "作文": chartColor(.brown)]
    }
    
    //MARK: - all average score
    private func allAverageScore(forSubject subject: String) -> Double {
        let allScore1 = UserDefaults.standard.string(forKey: "\(subject)Score1") ?? ""
        let allScore2 = UserDefaults.standard.string(forKey: "\(subject)Score2") ?? ""
        let allScore3 = UserDefaults.standard.string(forKey: "\(subject)Score3") ?? ""
        let allScore4 = UserDefaults.standard.string(forKey: "\(subject)Score4") ?? ""
        let allScore5 = UserDefaults.standard.string(forKey: "\(subject)Score5") ?? ""
        let allScore6 = UserDefaults.standard.string(forKey: "\(subject)Score6") ?? ""
        
        var jjj: [String] = [allScore1, allScore2, allScore3, allScore4, allScore5, allScore6]
        
        var weighted: Double = 6
        
        var average: Double = 0
        var all: Double = 0
        
        for i in 0..<jjj.count {
            if jjj[i].isEmpty || jjj[i] == "0" {
                //平均分(average score)的類型是Double，轉換成文字會是"0"，而不是""
                weighted -= 1
                jjj[i] = "0"
            }
        }
        
        for i in 0..<jjj.count {
            all += Double(jjj[i]) ?? 0
        }
        
        if all != 0 || weighted != 0 {
            average = all / weighted
        }else {
            average = 0
        }
        
        return average
    }
    
    //MARK: - compare score
    private func compareScore(for subject: String) -> (value: Double, name: String, color: Color) {
        
        func decideColor(_ value: String) -> Color{
            if Double(value) ?? 0 > 0 {
                return Color(.green)
            }else if Double(value) ?? 0 < 0 {
                return Color(.red)
            }
            return .gray
        }
        
        let stanard = subject == "Average" ? "0": ""
        
        let score1 = UserDefaults.standard.string(forKey: "\(subject)Score1") ?? stanard
        let score2 = UserDefaults.standard.string(forKey: "\(subject)Score2") ?? stanard
        let score3 = UserDefaults.standard.string(forKey: "\(subject)Score3") ?? stanard
        let score4 = UserDefaults.standard.string(forKey: "\(subject)Score4") ?? stanard
        let score5 = UserDefaults.standard.string(forKey: "\(subject)Score5") ?? stanard
        let score6 = UserDefaults.standard.string(forKey: "\(subject)Score6") ?? stanard
        
        let jjj: [String] = [score1, score2, score3, score4, score5, score6]
        
        var scoreTemporaryStorage = ""
        
        var systemName: String {
            if Double(scoreTemporaryStorage) ?? 0 >= 0 {
                return "chevron.up"
            }
            return "chevron.down"
        }
        
        var index = 0
        
        for i in 0..<jjj.count {
            /*
             if subject != "Average"
             => data of score:
                not entered: ""
                entered: "\(score)"
             
             else(subject == "Average")
             => data of score:
                not entered: "0"
                entered: "\(average)"
             
             but there's another way:
             if user never has never opened the page of the scope, then it'll save nothing to "Average\(scope)"
             the data will show: ""(it's empty)
             so, the only way is to load all the data of SubjectInfo and make it to an array,
             then check the score whether entered(no one of score is empty)
             if is, then do the logic with "nothing entered"
             */
            if subject != "Average" {
                if Double(jjj[i]) ?? 0 != 0 || !jjj[i].isEmpty {
                    scoreTemporaryStorage = jjj[i]
                    index = i
                }
            }else {
                if Double(jjj[i]) ?? 0 != 0 || !jjj[i].isEmpty {
                    scoreTemporaryStorage = jjj[i]
                    index = i
                }
            }
        }
        
        let uuu = index
        
        for _ in 0...uuu {
            if index > 0 {
                index -= 1
            }
            
            if subject != "Average" {
                if Double(jjj[index]) ?? 0 != 0 || !jjj[index].isEmpty {
                    let ggg = Double(jjj[uuu]) ?? 0
                    let fff = Double(jjj[index]) ?? 0
                    let ddd = String(ggg - fff)
                    scoreTemporaryStorage = String(ddd)
                    
                    break
                }
            }else {
                if Double(jjj[index]) ?? 0 != 0 && !jjj[index].isEmpty {
                    let ggg = Double(jjj[uuu]) ?? 0
                    let fff = Double(jjj[index]) ?? 0
                    let ddd = String(ggg - fff)
                    scoreTemporaryStorage = String(ddd)
                    
                    break
                }
            }
        }
        
        return (Double(scoreTemporaryStorage) ?? 0, systemName, decideColor(scoreTemporaryStorage))
    }
    
    //MARK: - minValue
    func minValue() -> Int {
        let userdefault = UserDefaults.standard
        var min = 100
        
        for i in 0..<6 {
            let scoreArray: [Int] = [
                userdefault.integer(forKey: "ChineseScore\(i + 1)"),
                userdefault.integer(forKey: "EnglishScore\(i + 1)"),
                userdefault.integer(forKey: "MathScore\(i + 1)"),
                userdefault.integer(forKey: "ScienceScore\(i + 1)"),
                userdefault.integer(forKey: "HistoryScore\(i + 1)"),
                userdefault.integer(forKey: "CivicsScore\(i + 1)"),
                userdefault.integer(forKey: "GeographyScore\(i + 1)"),
                userdefault.integer(forKey: "SocialScore\(i + 1)"),
                userdefault.integer(forKey: "ListeningScore\(i + 1)"),
                userdefault.integer(forKey: "CompositionScore\(i + 1)")
            ]
            
            let arr = scoreArray.filter{ $0 != 0 }
            
            if let minValue = arr.min(), min > minValue {
                min = minValue
            }
        }
        return min - 10
    }
    
    //MARK: - body: some View
    var body: some View {
        NavigationStack {
            List {
                GroupBox{
                    VStack {
                        
                        NavigationBarOfGroup(action: {
                            ShowEdit.toggle()
                        })
                        
                        Chart {
                            if minValue() <= 60 {
                                RuleMark(y: .value("及格線", 60))
                                    .foregroundStyle(.blue)
                                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [7]))
                            }
                            
                            ForEach(allValue) { summary in
                                ForEach(summary.value) { score in
                                    PointMark(
                                        x: .value("", score.name),
                                        y:  .value("", score.count)
                                    )
                                    .foregroundStyle(score.color)
                                    
                                    LineMark(
                                        x: .value("name", score.name),
                                        y: .value("count", score.count)
                                    )
                                    .foregroundStyle(score.color)
                                }
                                .foregroundStyle(by: .value("key", summary.id))
//                                .symbol(by: .value("", summary.id))
                            }
                        }
                        .chartYScale(domain: minValue()...100)
                        .chartForegroundStyleScale(scale())
                        .frame(height: 180)
                        .sheet(isPresented: $ShowEdit) {
                            LinechartSetting()
                                .environmentObject(globalViewModel)
                                .presentationDetents([.fraction(0.7), .large])
//                                .presentationCompactAdaptation(.automatic)
                        }
                    }
                }
                
                
                ForEach(subjectLink) { value in
                    NavigationLink(destination:subjectDetails(returnValue:
                            SubjectLink(label: value.label,
                                        key: value.key,
                                        average: allAverageScore(forSubject: value.key)) ) ) {
                        HStack{
                            Text("\(value.label)總平均")
                            
                            Spacer()
                            
                            VStack {
                                Text(String(format: "%.2f", allAverageScore(forSubject: value.key)))
                                
                                HStack {
                                    Image(systemName: compareScore(for: value.key).name)
                                        .bold()
                                        .padding(.trailing, -5)
                                    
                                    Text(String(format: "%.2f", compareScore(for: value.key).value))
                                }
                                .font(.caption)
                                .foregroundColor(compareScore(for: value.key).color)
                                .padding(.bottom, 2)
                            }
                        }
                    }
                }
            }
            .listStyle(.inset)
            //.frame(height: 430)
            
        }
        .onAppear{
            
            //創建還沒被儲存的分數資料
            for item in subjectLink {
                //整個科目有六個成績
                for i in 0..<6 {
                    if UserDefaults.standard.object(forKey: "\(item.key)Score\(i + 1)") == nil {
                        UserDefaults.standard.set("", forKey: "\(item.key)Score\(i + 1)")
                    }
                }
            }
            
            //創建科目是否要出現在圖表上的初始值
            for item in subjectLink {
                let userDefault = UserDefaults.standard
                let isCreated = userDefault.object(forKey: "is\(item.key)InChart") != nil
                
                if !isCreated && item.key != "Average" {
                    //不要創建平均的初始值，我就是硬要他看自己的平均怎樣：）
                    let isSocial = item.key == "Social"
                    //是社會科的話就創建false的值
                    userDefault.set(isSocial ? false: true, forKey: "is\(item.key)InChart")
                }
            }
            
            buildChartValue()
            
            let standard = [AllLineValue(id: "平均", value: allSummary),
                            AllLineValue(id: "國文", value: chineseSummary),
                            AllLineValue(id: "英文", value: englishSummary),
                            AllLineValue(id: "數學", value: mathSummary),
                            AllLineValue(id: "理化", value: scienceSummary),
                            AllLineValue(id: "歷史", value: historySummary),
                            AllLineValue(id: "公民", value: civicsSummary),
                            AllLineValue(id: "地理", value: geographySummary),
                            AllLineValue(id: "社會", value: socialSummary),
                            AllLineValue(id: "英聽", value: listeningSummary),
                            AllLineValue(id: "作文", value: compositionSummary)]
                
            allValue = [standard[0]]
            
            for (i, item) in standard.enumerated() {
                let userDefault = UserDefaults.standard
                let isSubjectInChart = userDefault.bool(forKey: "is\(subjectLink[i].key)InChart")
                let isAvailible = isSubjectInChart && subjectLink[i].key != "Average"
                
                if isAvailible {
                    allValue.append(item)
                }
            }
        }
    }
}

struct Summary_old_Preview: PreviewProvider {
    static var previews: some View {
        Summary_old()
        
        Home(viewModel: GremoViewModel())
    }
}

