//
//  GlobalViewModel.swift
//  Gremo
//
//  Created by Andy Lin on 2023/11/14.
//

import Foundation
import SwiftUI

//全局變數
class GremoViewModel: ObservableObject {
    
    @Published var info: [SubjectInfo]
    
    @Published var averageScores: AverageScore
    
    @Published var totalScore = Double()
    
    @Published var isScoreInColor = true
    
    @Published var isWeeklyExamOpen = true
    
    @Published var numberOfExam: Int = 2
    
    let userDefault = UserDefaults.standard
    
    init() {
        self.info = [
            .init(score: "", weighted: 5, subject: .chinese, isOn: true, color: chartColor(.lightBlue)),
            .init(score: "", weighted: 3, subject: .english, isOn: true, color: chartColor(.yellow)),
            .init(score: "", weighted: 4, subject: .math, isOn: true, color: chartColor(.green)),
            .init(score: "", weighted: 1, subject: .chemistry, isOn: false, color: .primary),
            .init(score: "", weighted: 1, subject: .physic, isOn: false, color: .gray),
            .init(score: "", weighted: 1, subject: .biology, isOn: true, color: .teal),
            .init(score: "", weighted: 1, subject: .geology, isOn: true, color: Color(hue: 0.082, saturation: 0.387, brightness: 0.799)),
            .init(score: "", weighted: 3, subject: .science, isOn: true, color: chartColor(.purpleBlue)),
            .init(score: "", weighted: 1, subject: .history, isOn: true, color: chartColor(.purple)),
            .init(score: "", weighted: 1, subject: .civics, isOn: true, color: chartColor(.orange)),
            .init(score: "", weighted: 1, subject: .geography, isOn: true, color: chartColor(.greenblue)),
            .init(score: "", weighted: 3, subject: .social, isOn: false, color: chartColor(.blue)),
            .init(score: "", weighted: 1, subject: .listening, isOn: true, color: chartColor(.pink)),
            .init(score: "", weighted: 1, subject: .essay, isOn: true, color: chartColor(.brown))
        ]
        
        self.isScoreInColor = userDefault.bool(forKey: "isScoreInColor")
        
        self.averageScores = AverageScore(total: 0, arts: 0, science: 0, social: 0)
        
        if let isWeeklyExamOpen = userDefault.object(forKey: "isWeeklyExamOpen") {
            self.isWeeklyExamOpen = isWeeklyExamOpen as? Bool ?? true
        }else {
            userDefault.set(true, forKey: "isWeeklyExamOpen")
        }
        
        for i in 0..<info.count {
            //取得儲存的加權分設定
            if let weighted = userDefault.object(forKey: "\(info[i].key)WeightedScore"){
                //獲取資訊，儲存過就取用，沒儲存過就儲存初始數值
                info[i].weighted = weighted as? Double ?? 0
            }else {
                userDefault.set(info[i].weighted, forKey: "\(info[i].key)WeightedScore")
            }
            
            //取得儲存的科目是否開啟設定
            if let isOn = userDefault.object(forKey: "is\(info[i].key)On") {
                //獲取資訊
                info[i].isOn = isOn as? Bool ?? false
            }else {
                userDefault.set(info[i].isOn, forKey: "is\(info[i].key)On")
            }
        }
        
        //取得儲存的考試次數設定
        if let numberOfExam = userDefault.object(forKey: "numberOfExam") {
            self.numberOfExam = numberOfExam as? Int ?? 0
        }else {
            userDefault.set(numberOfExam, forKey: "numberOfExam")
        }
    }
    
    func readScoreData(scope: Int) {
        let keys: [String] = info.map { $0.key }
        
        for (i, key) in keys.enumerated() {
            if let score = userDefault.string(forKey: "\(key)Score\(scope + 1)") {
                withAnimation {
                    info[i].score = score
                }
            }else {
                info[i].score = ""
            }
        }
    }
    
    func averageCalculate() {
        let arts = info.getAverageScore(forType: .arts)
        let total = info.getAverageScore(forType: .total)
        let science = info.getAverageScore(forType: .science)
        let social = info.getAverageScore(forType: .social)
        
        averageScores = AverageScore(total: total, arts: arts, science: science, social: social)
    }
    
}

extension Subject {
    var isArtsSubject: Bool {
        self == .chinese || self == .english || self == .listening || self == .essay
    }
    
    var isSocialSubject: Bool {
        self == .history || self == .civics || self == .geography || self == .social
    }
    
    var isScienceSubject: Bool {
        self == .math || self == .chemistry || self == .physic || self == .biology || self == .geology || self == .science
    }
    
    var isAvailable: Bool {
        return true
    }
}

extension SubjectInfo {
    func calculateScore(isHasWeighted: Bool) -> Double {
        if let score = Double(self.score) {
            let weighted = isHasWeighted ? self.weighted: 1
            return score * weighted
        }
        return 0
    }
}
