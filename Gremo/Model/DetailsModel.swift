//
//  DetailsModel.swift
//  Gremo
//
//  Created by Andy Lin on 2023/11/15.
//

import SwiftUI

struct Score1: Identifiable {
    var id = UUID()
    var name: String
    var count: Int
    var color: Color
}

struct ScoreDetailsSquareValue: Identifiable {
    let id = UUID()
    let name: String
    var averageScore: Double
    var color: [Double]
    var info: [SubjectInfo]
    
    init(_ name: String,averageScore: Double, color: [Double], info: [SubjectInfo]) {
        self.name = name
        self.averageScore = averageScore
        self.color = color
        self.info = info
    }
}

enum colorChoice {
    case lightBlue
    case purpleBlue
    case purple
    case yellow
    case green
    case pink
    case orange
    case greenblue
    case blue
    case brown
}

