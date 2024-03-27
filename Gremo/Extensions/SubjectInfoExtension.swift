//
//  SubjectInfoExtension.swift
//  Gremo
//
//  Created by Andy Lin on 2024/3/24.
//

import Foundation

extension SubjectInfo {
    func calculateScore(isHasWeighted: Bool) -> Double {
        if let score = Double(self.score) {
            let weighted = isHasWeighted ? self.weighted: 1
            return score * weighted
        }
        return 0
    }
}

extension Array where Element == SubjectInfo {
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
            let isAllowsCalculate: Bool = item.isAllowsCalculate
            let isAvailible: Bool = isEntered && isSubjectOn && isAllowsCalculate
            
            weightedes.append(isAvailible ? item.weighted: 0)
        }
        
        return weightedes
    }
    
    func getTotalScore() -> Double {
        //如果沒有將此科目開啟使用，就不計算
        var totalScore = Double()
        
        for item in self {
            //排除沒開啟、非數字輸入、沒輸入
            if item.isOn && item.isAllowsCalculate, let score = Double(item.score) {
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
            let isAvailable = !scoreInfo.score.isEmpty && scoreInfo.isOn && scoreInfo.isAllowsCalculate
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
