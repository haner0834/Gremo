//
//  SummaryViewModel.swift
//  Gremo
//
//  Created by Andy Lin on 2023/12/9.
//

import Foundation
import SwiftUI

class SummaryViewModel: ObservableObject {
    @Published var globalViewModel: GremoViewModel
    
    @Published var scoreSummary: [LineChartValueItem] = []//for line chart
    
    let userDefault = UserDefaults.standard
    
    init(globalViewModel: GremoViewModel) {
        self.globalViewModel = globalViewModel
    }

    func initializeData() {
        for info in globalViewModel.info {
            if userDefault.object(forKey: "is\(info.key)InChart") == nil {
                userDefault.set(info.subject == .social ? false: true, forKey: "is\(info.key)InChart")
            }
        }
        
        scoreSummary = []
        //幹要把變數值清空啦北七ㄋㄧˋ
        //三個字 超級可悲
        
        addScoreSummary("Average", subjectName: "平均", color: .accentColor)
        
        for info in globalViewModel.info where info.isOn && userDefault.bool(forKey: "is\(info.key)InChart") {
            addScoreSummary(info.key, subjectName: info.name, color: info.color)
        }
    }
    
    func addScoreSummary(_ key: String, subjectName: String, color: Color) {
        var scores = [Count]()
        let examNames = ["一週", "一段", "二週", "二段", "三週", "三段"]
        for i in 0..<6 {
            let examName = examNames[i]
            
            let score = UserDefaults.standard.double(forKey: "\(key)Score\(i + 1)")
            if score > 0 {
                scores.append(.init(examName: examName, score: score))
            }
        }
        
        if scores.count != 0 {
            scoreSummary.append(
                .init(name: subjectName,
                      value: scores,
                      color: color)
            )
        }
    }
    
    func getAverage(key: String) -> Double {
        let isSubjectOn = userDefault.bool(forKey: "is\(key)On")
        if key != "Average" {
            guard isSubjectOn else { return 0 }
        }
        
        var scores: [String] = []
        for i in 0..<6 {
            var score: String {
                if key == "Average" {
                    return String(userDefault.double(forKey: "\(key)Score\(i + 1)"))
                }
                return userDefault.string(forKey: "\(key)Score\(i + 1)") ?? ""
            }
            scores.append(score)
        }
        
        let newArray = scores.filter {
            if key == "Average" {
                return Double($0)! != 0
            }
            return !$0.isEmpty
        }
        
        var total = Double()
        for i in 0..<newArray.count {
            total += Double(newArray[i]) ?? 0
        }
        
        var average = Double()
        let divideValue = Double(newArray.count)
        
        if divideValue != 0 {
            average = total / divideValue
        }else {
            average = 0
        }
        
        return average
    }
    
    func getImageName(_ score: Double) -> String {
        let highStandard = userDefault.double(forKey: "heightScore")
        let lowStandard = userDefault.double(forKey: "lowSscore")
        
        if score > highStandard {
            return "chevron.up"
        }
        
        if score < lowStandard {
            return "chevron.down"
        }
        
        return "chevron.up"
    }
    
    func getImageColor(_ score: Double) -> Color {
        if score > 0 { return Color(.green) }
        //有上升
        
        if score < 0 { return Color(.red) }
        //下降
        
        return .gray
        //沒升沒降or都是0
    }
    
    func compareScore(key: String) -> Double {
        let isSubjectOn = userDefault.bool(forKey: "is\(key)On")
        //if the subject was accepted to show on chart (skip average status)
        guard isSubjectOn || key == "Average" else { return 0 }
        
        var scores: [String] = []
        for i in 0..<6 {
            let score = key == "Average" ? String(userDefault.double(forKey: "\(key)Score\(i + 1)")): userDefault.string(forKey: "\(key)Score\(i + 1)") ?? ""
            scores.append(score)
        }
        
        var result = Double()
        let newList = scores.filter { key != "Average" ? !$0.isEmpty: Double($0)! != 0 }
        if newList.count > 1 {
            let i = newList.count - 1
            let front = Double(newList[i]) ?? 0
            let back = Double(newList[i - 1]) ?? 0
            result = front - back
            print("subject name: \(key), front: \(front), back: \(back), result: \(result)")
        }
        
        return result
    }
}
