//
//  DetailsViewModel.swift
//  Gremo
//
//  Created by Andy Lin on 2023/9/10.
//

import SwiftUI
import Charts

func chartColor(_ color: colorChoice) -> Color {
    switch color {
    case .lightBlue:
        return Color(hue: 0.55, saturation: 0.5, brightness: 1.0)
        //return Color(hue: 0.55, saturation: 0.59, brightness: 1.0)
    case .purpleBlue:
        return Color(hue: 0.68, saturation: 0.5, brightness: 0.982)
    case .purple:
        return Color(hue: 0.8, saturation: 0.59, brightness: 0.982)
    case .yellow:
        return Color(hue: 0.164, saturation: 0.431, brightness: 0.978)
        //return Color(hue: 0.164, saturation: 0.431, brightness: 0.978)
    case .green:
        return Color(hue: 0.294, saturation: 0.59, brightness: 0.982)
    case .pink:
        return Color(hue: 0.929, saturation: 0.59, brightness: 0.982)
    case .orange:
        return Color(hue: 0.04, saturation: 0.59, brightness: 0.982)
    case .greenblue:
        return Color(hue: 0.455, saturation: 0.59, brightness: 0.982)
    case .blue:
        return Color(hue: 0.6, saturation: 0.59, brightness: 0.982)
    case .brown:
        return Color(hue: 0.001, saturation: 0.36, brightness: 0.617)
    }
}

class DetailsViewModel: ObservableObject {
    
    let scoreInfo: KeyValuePairs<String, Color> = [
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

    @Published var scope = UserDefaults.standard.integer(forKey: "scope") + 1
    @Published var x1: CGFloat = 0
    @Published var x2: CGFloat = 390
    @Published var x3: CGFloat = 390
    
    @Published var position = CGSize.zero
    
    @Published var pickerValue = "全部"
    @Published var isHasWeighted = true
    
    @Published var max = 2000
    @Published var animate = false
    
    @Published var subjectInfo: [SubjectInfo] = []
    
    @Published var globalViewModel: GremoViewModel
    
    @Published var squareValue: [ScoreDetailsSquareValue]
    
    @Published var averageScore: AverageScore
    
    @Published var totalScore: Double
    
    var weightedText: String {
        var text = "加權分標準："
        for info in subjectInfo {
            if info.isOn {
                text += "\(info.name)（\(String(format: "%.0f", info.weighted))），"
            }
        }
        
        //刪除最後留下來的"，"
        text.removeLast()
        
        text.append("\n\n 註： 尚未開啟的科目之加權分不會出現在此")
        
        return text
    }
    
    
    
    init(globalViewModel: GremoViewModel) {
        self.globalViewModel = globalViewModel
        
        self.subjectInfo = globalViewModel.info
        
        self.averageScore = globalViewModel.averageScores
        
        self.totalScore = globalViewModel.totalScore
        
        squareValue = [
            .init("文科",
                  averageScore: globalViewModel.averageScores.arts,
                  color: [0.55, 1.0, 1.0],
                  info: globalViewModel.info.filter { $0.subject.isArtsSubject }),
            .init("數理科",
                  averageScore: globalViewModel.averageScores.science,
                  color: [0.68, 1.0, 0.982],
                  info: globalViewModel.info.filter { $0.subject.isScienceSubject }),
            .init("社會科",
                  averageScore: globalViewModel.averageScores.social,
                  color: [0.8, 1.0, 0.982],
                  info: globalViewModel.info.filter { $0.subject.isSocialSubject })
        ]
    }
    
    
    
    func chartData(scope: Int) -> [Score1] {
        let userDefault = UserDefaults.standard
        var data: [Score1] = []
        
        for item in subjectInfo {
            var color: Color {
                if item.subject.isArtsSubject {
                    return chartColor(.lightBlue)
                }else if item.subject.isScienceSubject {
                    return chartColor(.purpleBlue)
                }else if item.subject.isSocialSubject {
                    return chartColor(.purple)
                }
                
                return .black
            }
            
            if item.isOn {
                let savedData = userDefault.integer(forKey: "\(item.key)Score\(scope)")
                data.append(.init(name: item.name, count: savedData, color: color))
            }
        }
        
        return data
    }

    //MARK: scopeText(for: Int) -> String
    func scopeText(for scope: Int) -> String {
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
            return "eror: con not find scope"
        }
    }
    
    func changeChartData(_ type: String) {
        let newArray = subjectInfo.filter { info in
            switch type {
            case "全部":
                return true
            case "文科":
                return info.subject.isArtsSubject && info.isOn
            case "數理科":
                return info.subject.isScienceSubject && info.isOn
            case "社會科":
                return info.subject.isSocialSubject && info.isOn
            default:
                return false
            }
        }
        
        //計算圖表的最大值是多少
        max = 0
        for item in newArray {
            if item.isOn {
                max += isHasWeighted ? Int(item.weighted) * 100: 100
            }
        }

        readScoreData(scope: scope)
        
        //取出不需要的分數（文科、數理科、社會科的差別）
        for (i, info) in subjectInfo.enumerated() {
            switch type {
            case "全部":
                subjectInfo[i].score = info.score
            case "文科":
                subjectInfo[i].score = info.subject.isArtsSubject ? info.score: "0"
            case "數理科":
                subjectInfo[i].score = info.subject.isScienceSubject ? info.score: "0"
            case "社會科":
                subjectInfo[i].score = info.subject.isSocialSubject ? info.score: "0"
            default:
                subjectInfo[i].score = "error"
            }
        }
    }
    
    //MARK: dragGesture(_ value: )
    func dragGesture(_ value: GestureStateGesture<DragGesture, CGSize>.Value) {
        
        var isRight: Bool {
            value.translation.width > 0
        }
        
        var isBlocked: Bool = false
        
        self.position.width = value.translation.width
        
        if abs(value.translation.width) > 100 {
            //abs(_ x:):取絕對值
            let lowStandard = globalViewModel.isWeeklyExamOpen ? 1: 2
            let numberOfExam = globalViewModel.numberOfExam + 1
            let highStandard = numberOfExam * 2 
            if isRight {
                
                if scope > lowStandard {
                    isBlocked = false
                    
                    scope -= globalViewModel.isWeeklyExamOpen ? 1: 2
                    
//                    x1 = -390 + position.width
                    x2 = -390 + position.width
                    x3 = 0 + position.width
                    
                    withAnimation(.easeOut(duration: 0.3)) {
                        x1 = 0
                        x2 = 0
                        x3 = 390
                    }
                    
                    x1 = -390
//                    x2 = 0
//                    x3 = 390
                }else {
                    isBlocked = true
                }
            }else {
                
                if scope < highStandard {
                    isBlocked = false
                    
                    scope += globalViewModel.isWeeklyExamOpen ? 1: 2
                    
                    x1 = 0 + position.width
                    x2 = 390 + position.width
                    x3 = 390 + position.width
                    
                    withAnimation(.easeOut(duration: 0.3)) {
                        x1 = -390
                        x2 = 0
//                        x3 = 0
                    }
                    
//                    x1 = -390
//                    x2 = 0
                    x3 = 390
                }else {
                    isBlocked = true
                }
            }
        }
        if !isBlocked {
            changeChartData(pickerValue)
        }
        
        if abs(value.translation.width) < 100 || isBlocked {
            withAnimation(.interpolatingSpring(stiffness: 50, damping: 7, initialVelocity: 5)) {
                self.position.width = 0
            }
        }else {
            self.position.width = 0
        }
    }
    
    func readScoreData(scope: Int) {
        let userDefault = UserDefaults.standard
        for (i, info) in subjectInfo.enumerated() {
            subjectInfo[i].score = userDefault.string(forKey: "\(info.key)Score\(scope)") ?? ""
        }
        squareValue = [
            .init("文科",
                  averageScore: subjectInfo.getAverageScore(forType: .arts),
                  color: [0.55, 1.0, 1.0],
                  info: subjectInfo.filter { $0.subject.isArtsSubject }),
            .init("數理科",
                  averageScore: subjectInfo.getAverageScore(forType: .science),
                  color: [0.68, 1.0, 0.982],
                  info: subjectInfo.filter { $0.subject.isScienceSubject }),
            .init("社會科",
                  averageScore: subjectInfo.getAverageScore(forType: .social),
                  color: [0.8, 1.0, 0.982],
                  info: subjectInfo.filter { $0.subject.isSocialSubject })
        ]
        
        let total = subjectInfo.getAverageScore(forType: .total)
        averageScore.total = total
        totalScore = subjectInfo.getTotalScore()
    }
    
    //MARK: changeChartScope
    func changeChartScope() -> [Int] {
        for i in 0..<6 {
            if scope == i + 1 {
                return [i, i + 1, i + 2]
                //i: 上一個範圍
                //i + 1: 當前範圍
                //i + 2: 下一個範圍
            }
        }
        return [0, 0, 0]
    }
    
    func initializationPosition() {
        x1 = -390
        x2 = 0
        x3 = 390
        
        changeChartData("全部")
//        changeChartValue(for: "全部")
    }
}
