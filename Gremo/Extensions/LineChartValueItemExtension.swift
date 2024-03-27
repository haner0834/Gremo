//
//  LineChartValueItemExtension.swift
//  Gremo
//
//  Created by Andy Lin on 2024/3/24.
//

import Foundation

extension [LineChartValueItem] {
    func minScore(maxScale: Double = 100) -> Double {
        //給一個要取得的最大值，大於的就不取用
        var min: Double = maxScale
        //只取用value([Count(name: String, score: Double)])的部分
        for value in self.map({ $0.value }) {
            //只取用score(Double)的部分
            let scores: [Double] = value.map { $0.score }
            for score in scores where score < min {
                //如果這個數字小於目前取得的最小數字，那就把最小數字更新為這個數字
                min = score
            }
        }
        
        return min
    }
}
