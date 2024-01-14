//
//  ScoreCalculateViewModel.swift
//  Gremo
//
//  Created by Andy Lin on 2023/9/10.
//

import SwiftUI
import Foundation

extension [SubjectInfo] {
    //用subject來找第幾項
    func getScore(for type: Subject) -> String {
        return self[type.rawValue].score.isEmpty ? "0": self[type.rawValue].score
    }
    
    //用subject來找第幾項
    func getIndex(for type: Subject) -> Int {
        return type.rawValue
    }
    
    //找出能用的加權分
    func getAvailibleWeighted() -> [Double] {
        var weightedes: [Double] = []
        
        for item in self {
            let isEntered: Bool = !item.score.isEmpty
            let isSubjectOn: Bool = item.isOn
            let isAvailible: Bool = isEntered && isSubjectOn
            
            weightedes.append(isAvailible ? item.weighted: 0)
        }
        
        return weightedes
    }
    
    func getTotalScore() -> Double {
        //如果沒有將此科目開啟使用，就不計算
        var totalScore = Double()
        
        for item in self {
            //排除沒開啟、非數字輸入、沒輸入
            if item.isOn, let score = Double(item.score) {
                let result = score * item.weighted
                totalScore += result
            }
        }
        
        return totalScore
    }
    
    func getAverageScore(forType type: SubjectType) -> Double {
        /*
         把輸入的平均分類型轉換成[SubjectScoreInfo]，傳出一個新的array
         用這個array計算總分
         取得能用的加權加總（沒輸入的不要算進去）
         計算後，把這項數據除以上面那些科目對應的加權分
         回傳計算後的數據
        */
        
        //把輸入的平均分類型轉換成[SubjectScoreInfo]，傳出一個新的array
        
        //取出要用的科目
        let filteredArray = self.filter { scoreInfo in
            switch type {
            case .total:
                return true
            case .arts:
                return scoreInfo.subject.isArtsSubject
            case .science:
                return scoreInfo.subject.isScienceSubject
            case .social:
                return scoreInfo.subject.isSocialSubject
            }
        }
        
        var newArray: [SubjectInfo] = filteredArray
        let weightedes = filteredArray.getAvailibleWeighted()
        
        for i in 0..<newArray.count {
            newArray[i].weighted = weightedes[i]
        }
        
        //用這個array計算總分
        let totalScore = filteredArray.getTotalScore()
        
        //取得加權分加總
        let totalWeighted = filteredArray.reduce(0.0) { partialResult, scoreInfo in
            let isAvailable = !scoreInfo.score.isEmpty && scoreInfo.isOn
            return partialResult + (isAvailable ? scoreInfo.weighted: 0)
        }
        
        //計算後，把這項數據除以上面那些科目對應的加權分
        if totalWeighted != 0 {
            let averageScore = totalScore / totalWeighted
            //回傳計算後的數據
            return averageScore
        }
        
        //都沒有輸入的話就回傳0
        return 0
    }
}

class ScoreCalculateViewModel: ObservableObject {
    
    @Published var subjects: GremoViewModel
    
    @Published var scope: Int = 0
    
    @Published var showWarning = false
    
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
        
        var highColor: Color {
            let setedHighColor = userDefault.string(forKey: "heightColor") ?? ""
            
            switch setedHighColor {
            case "green":
                return isAverage ? Color("Green"): Color(red: 0.559, green: 0.879, blue: 0.643)
            case "blue":
                return .blue
            case "purple":
                return .accentColor
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
            default:
                return Color("White-Black")
            }
        }
        
        if score >= highStandard {
            return highColor
        }
        
        if score < lowStandard && score != 0 {
            return lowColor
        }
        
        if score < highStandard && score >= lowStandard {
            return isAverage ? .teal: Color(red: 0.555, green: 0.831, blue: 0.878)
        }
        
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
    
    func saveScoreData() {
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
        self.scope = isWeeklyExamOpen ? scope: (isScopeEven ? scope + 1: scope)
        //如果週考有開啟，就用儲存的scope就好了，否則就看他是不是偶數，是的話就加一
        
        getScopeScore(scope)
        
        calculateAverageScore()
        
        subjects.totalScore = subjects.info.getTotalScore()
    }
}
