//
//  SummaryModel.swift
//  Gremo
//
//  Created by Andy Lin on 2023/12/10.
//

import Foundation
import SwiftUI

struct Count: Identifiable {
    let id = UUID()
    let examName: String
    var score: Double
}

struct LineChartValueItem: Identifiable {
    var id = UUID()
    let name: String
    var value: [Count]
    let color: Color
}
