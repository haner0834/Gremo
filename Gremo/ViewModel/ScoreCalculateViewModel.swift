//
//  ScoreCalculateViewModel.swift
//  Gremo
//
//  Created by Andy Lin on 2023/9/10.
//

import SwiftUI
import Foundation

class ScoreCalculateViewModel: ObservableObject {
    
    @Published var subjects: GremoViewModel
    
    @Published var scope: Int = 0
    
    @Published var showWarning = false
    
    @Published var isShowAlert: Bool = false
    
    @Published var changeSubject: Subject? = nil
    @Published var changeType: ChangeType? = nil
    
    @Published var alertItem: AlertItem = AlertItem(title: nil, message: "左側按鈕復原", buttomTitle: "復原")
    
    let userDefault: UserDefaults = UserDefaults.standard
    
    
    init(score: GremoViewModel) {
        self.subjects = score
    }
    
    
    func isSubjectOn(key: String) -> Bool {
        return userDefault.bool(forKey: "is\(key)On")
    }
    
    func textColor(score: Double, isAverage: Bool = true) -> Color {
        if !subjects.isScoreInColor { return Color(.whiteBlack).opacity(isAverage ? 1: 0.15) }
        
        let highStandard = userDefault.double(forKey: "heightScore")
        let lowStandard = userDefault.double(forKey: "lowScore")
        
        let colorData = ColorData()
        
        var highColor: Color {
            let setedHighColor = userDefault.string(forKey: "heightColor") ?? ""
            
            switch setedHighColor {
            case "green":
                return isAverage ? Color("Green"): Color(red: 0.559, green: 0.879, blue: 0.643)
            case "blue":
                return .blue
            case "purple":
                return .accentColor
            case "custom":
                if let color = colorData.loadColor(colorType: .highStandard) {
                    return color
                }
                return .primary
            default:
                return Color("White-Black")
            }
        }
        
        var lowColor: Color {
            let setedLowColor = userDefault.string(forKey: "lowColor") ?? ""
            
            switch setedLowColor {
            case "red":
                return isAverage ? Color("Red"): Color(red: 0.999, green: 0.575, blue: 0.551)
                //Color(hue: 0.0, saturation: 0.597, brightness: 0.994)
            case "orange":
                return .orange
            case "yellow":
                return .yellow
            case "custom":
                if let color = colorData.loadColor(colorType: .lowStandard) {
                    return color
                }
                return .primary
            default:
                return Color("White-Black")
            }
        }
        
        if score >= highStandard { return highColor }
        
        if score < lowStandard && score != 0 { return lowColor }
        
        if score < highStandard && score >= lowStandard { return isAverage ? .teal: Color(red: 0.555, green: 0.831, blue: 0.878) }
        
        return Color("White-Black").opacity(isAverage ? 1: 0.15)
    }
    
    func getScopeScore(_ scope: Int) {
        let keys: [String] = subjects.info.map { $0.key }
        
        for (i, item) in keys.enumerated() {
            if let score = userDefault.string(forKey: "\(item)Score\(scope + 1)") {
                withAnimation {
                    subjects.info[i].score = score
                }
            }else {
                subjects.info[i].score = ""
            }
        }
    }
    
    func changeScope(_ value: DragGesture.Value) {
        let numberOfExam = subjects.numberOfExam + 1
        let lowStandard = subjects.isWeeklyExamOpen ? 0: 1
        let highStandard = (numberOfExam * 2) - 1
        withAnimation {
            if value.translation.width > 0 {
                //right
                if scope > lowStandard {
                    scope -= subjects.isWeeklyExamOpen ? 1: 2
                }
            }else if value.translation.width < 0 {
                //left
                if scope < highStandard {
                    scope += subjects.isWeeklyExamOpen ? 1: 2
                }
            }
        }
        
        getScopeScore(scope)
    }
    
    func saveAllScoreData() {
        //儲存輸入的分數
        let keys = subjects.info.map { $0.key }
        
        for (i, key) in keys.enumerated() {
            userDefault.set(subjects.info[i].score, forKey: "\(key)Score\(scope + 1)")
        }
        print("saved data")
        
        userDefault.set(subjects.averageScores.total, forKey: "AverageScore\(scope + 1)")
///        userDefault.set(averageScores.arts, forKey: "LiberalArts\(scope)")
///        userDefault.set(averageScores.science, forKey: "Science\(scope)")
///        userDefault.set(averageScores.social, forKey: "Social\(scope)")
        ///應該可以再出現時就計算，也不會花太多時間（？反正現在就先不除存，到時後看看
    }
    
    func saveScoreData(_ score: String, forKey key: String) {
        userDefault.set(score, forKey: "\(key)Score\(scope + 1)")
        print("saved data(score: '\(score)', key: \("\(key)Score\(scope + 1)"))")
    }
    
    func calculateAverageScore() {
        let totalAverage = subjects.info.getAverageScore(forType: .total)
        let artsAverage = subjects.info.getAverageScore(forType: .arts)
        let scienceAverage = subjects.info.getAverageScore(forType: .science)
        let socialAverage = subjects.info.getAverageScore(forType: .social)
        
        withAnimation {
            let averageScores = AverageScore(total: totalAverage, arts: artsAverage, science: scienceAverage, social: socialAverage)
            subjects.averageScores = averageScores
        }
    }
    
    func deleteScoreData() {
        //不用更改AverageScore是因為已經跟分數綁在一起了
        userDefault.set(0, forKey: "AverageScore\(scope + 1)")
        for (i, info) in subjects.info.enumerated() {
            subjects.info[i].score = ""
            userDefault.set("", forKey: "\(info.key)Score\(scope + 1)")
        }
    }
    
    fileprivate func processFirstUse() {
        //取得儲存的分數
        for i in 0..<subjects.info.count {
            //要和外部的subjectScoreItem溝通，需要用到i來追蹤循環次數並傳回應改變項
            let key = subjects.info[i].key
            if let score = userDefault.string(forKey: "\(key)Score\(scope + 1)") {
                //排除nil的可能
                subjects.info[i].score = score
            }
        }
        
        if userDefault.object(forKey: "heightColor") == nil {
            userDefault.set("green", forKey: "heightColor")
        }
        
        if userDefault.object(forKey: "lowColor") == nil {
            userDefault.set("red", forKey: "lowColor")
        }
        
        if userDefault.object(forKey: "heightScore") == nil {
            userDefault.set(80, forKey: "heightScore")
        }
        
        if userDefault.object(forKey: "lowScore") == nil {
            userDefault.set(60, forKey: "lowScore")
        }
    }
    
    func createInitialValue() {
        let isFirstUse = userDefault.object(forKey: "isFirstUse") == nil || userDefault.bool(forKey: "isFirstUse")
        
        if isFirstUse {
            processFirstUse()
        }else {
            userDefault.set(false, forKey: "isFirstUse")
        }
        
        //取得儲存的scope
        let scope = userDefault.integer(forKey: "scope")
        let isScopeEven: Bool = scope % 2 == 0 //even is available when weekly exam is open
        let isWeeklyExamOpen = subjects.isWeeklyExamOpen
//        self.scope = (isWeeklyExamOpen || !isScopeEven) ? scope: scope + 1
        //如果週考有開啟，就用儲存的scope就好了，否則就看他是不是偶數，是的話就加一
        let numberOfExam = (subjects.numberOfExam + 1) * (isWeeklyExamOpen ? 2: 1)
        if isWeeklyExamOpen || !isScopeEven {
            self.scope = scope < numberOfExam ? scope: numberOfExam - 1
        }else {
            self.scope = scope < numberOfExam ? scope + 1: numberOfExam - 1
        }
        
        getScopeScore(scope)
        
        calculateAverageScore()
        
        subjects.totalScore = subjects.info.getTotalScore()
    }
    
    func calculateScore() {
        calculateAverageScore()
        
        subjects.totalScore = subjects.info.getTotalScore()
    }
    
    func changeAllowsCalculate(for subject: Subject) {
        let index = subject.rawValue
        subjects.info[index].isAllowsCalculate.toggle()
        
        let isAllowsCalculate = subjects.info[index].isAllowsCalculate
        changeSubject = subject
        changeType = isAllowsCalculate ? .openCalculate: .closeCalculate
        
        if isShowAlert {
            isShowAlert = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                isShowAlert = true
            }
        }else {
            isShowAlert = true
        }
        
        calculateScore()
        
        let key = subjects.info[index].key
        userDefault.set(isAllowsCalculate, forKey: "is\(key)AllowsCalculate")
    }
    
    func changeIsSubjectOn(for subject: Subject) {
        let index = subject.rawValue
        subjects.info[index].isOn.toggle()
        
        let isOn = subjects.info[index].isOn
        changeSubject = subject
        changeType = isOn ? .cancelDelete: .delete
        
        if isShowAlert {
            isShowAlert = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                isShowAlert = true
            }
        }else {
            isShowAlert = true
        }
        
        calculateScore()
        
        let key = subjects.info[index].key
        userDefault.set(isOn, forKey: "is\(key)On")
    }
    
    func processRestore() {
        withAnimation {
            if changeType == .delete || changeType == .cancelDelete {
                changeIsSubjectOn(for: changeSubject ?? .chinese)
            }else {
                changeAllowsCalculate(for: changeSubject ?? .chinese)
            }
        }
    }
    
    func processScoreChanging(for item: SubjectInfo, newScore: String, focus: Subject?, index: Int) {
        ///Three types of score changing
        /// - User is typing                                        -> `focus != nil`
        /// - Change scope(read stored data)          -> `focus == nil`
        /// - Delete all score by delete-all button      -> `focus == nil && subjects.info.filter({ !$0.score.isEmpty }).isEmpty`
        
        if focus == nil && subjects.info.filter({ !$0.score.isEmpty }).isEmpty {
            ///Delete all
            calculateScore()
            saveAllScoreData()
            return
        }else if focus == nil {
            ///Initializing page(change scope)
            calculateScore()
            return
        }
        
        //判斷輸入的東西是否符合標準
        if let score = Double(newScore), focus != nil {
            ///User is typing
            
            ///Limit score by 0 to 100
            if score > 100 {
                subjects.info[index].score = "100"
            }else if score < 0 {
                subjects.info[index].score = "0"
            }
            
            calculateScore()
            saveAllScoreData()
            
        }else if newScore.isEmpty {
            calculateScore()
            saveAllScoreData()
        }
    }
}
