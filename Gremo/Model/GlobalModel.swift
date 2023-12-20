//
//  GlobalModel.swift
//  Gremo
//
//  Created by Andy Lin on 2023/11/18.
//

import Foundation
import SwiftUI

enum Subject: Int {
    case chinese, english, math, chemistry, physic, biology, geology, science, history, civics, geography, social, listening, essay
    
//    case selfDef, selfDef2, selfDef3, selfDef4
}

enum SubjectType {
    case total, arts, science, social
}

struct SubjectInfo: Identifiable {
    let id = UUID()
    var score: String
    var weighted: Double
    var isOn: Bool
    let subject: Subject
    let color: Color
    let name: String
    let key: String
    
    init(score: String, weighted: Double, subject: Subject, isOn: Bool, color: Color) {
        self.score = score
        self.weighted = weighted
        self.subject = subject
        self.isOn = isOn
        self.color = color
        self.name = SubjectInfo.subjectName(subject)
        self.key = SubjectInfo.subjectKeyName(subject)
    }
    
    static func subjectName(_ subject: Subject) -> String {
        switch subject {
        case .chinese:
            return "國文"
        case .english:
            return "英文"
        case .math:
            return "數學"
        case .chemistry:
            return "化學"
        case .physic:
            return "物理"
        case .biology:
            return "生物"
        case .geology:
            return "地科"
        case .science:
            return "理化"
        case .history:
            return "歷史"
        case .civics:
            return "公民"
        case .geography:
            return "地理"
        case .social:
            return "社會"
        case .listening:
            return "英聽"
        case .essay:
            return "作文"
        }
    }
    
    static func subjectKeyName(_ subject: Subject) -> String {
        switch subject {
        case .chinese:
            return "Chinese"
        case .english:
            return "English"
        case .math:
            return "Math"
        case .chemistry:
            return "Chemistry"
        case .physic:
            return "Physic"
        case .biology:
            return "Biology"
        case .geology:
            return "Geology"
        case .science:
            return "Science"
        case .history:
            return "History"
        case .civics:
            return "Civics"
        case .geography:
            return "Geography"
        case .social:
            return "Social"
        case .listening:
            return "Listening"
        case .essay:
            return "Composition"
        }
    }
}
