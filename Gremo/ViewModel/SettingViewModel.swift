//
//  SettingViewModel.swift
//  Gremo
//
//  Created by Andy Lin on 2023/11/19.
//

import Foundation
import SwiftUI

class SettingViewModel: ObservableObject {
    @Published var globalViewModel: GremoViewModel
    
    @AppStorage("heightScore") var highScore: Double = 80
    @AppStorage("lowScore") var lowScore: Double = 60
    @AppStorage("isWeightedOn") var isWeightedOn: Bool = true
    
    @AppStorage("isScoreInColor") var isScoreInColor = true
    @Published var isShowDialog = false
    @AppStorage("heightColor") var heightColor = "green"
    @AppStorage("lowColor") var lowColor = "red"
    
    @Published var customHighColor: Color = Color.blue
    @Published var customLowColor: Color = Color.blue
    
    let userDefault = UserDefaults.standard
    
    init(globalViewModel: GremoViewModel) {
        self.globalViewModel = globalViewModel
        
        let colorData = ColorData()
        
        customHighColor = colorData.loadColor(colorType: .highStandard) ?? .blue
        customLowColor = colorData.loadColor(colorType: .lowStandard) ?? .blue
    }
    
    func resetSetting() {
        //科目開啟 關閉
        for (i, info) in globalViewModel.info.enumerated() {
            globalViewModel.info[i].isOn = info.subject != .social
            //排除社會科⬆️
            userDefault.set(info.subject != .social, forKey: "is\(info.key)On")
        }
        
        //加權分
        let weighteds: [Double] = [5, 3, 4, 0, 0, 1, 1, 3, 1, 1, 1, 3, 1, 1]
        for (i, info) in globalViewModel.info.enumerated() {
            let weighted = weighteds[i]
            globalViewModel.info[i].weighted = weighted
            userDefault.set(weighted, forKey: "\(info.key)Weighted")
        }
        
        //週考
        globalViewModel.isWeeklyExamOpen = true
        globalViewModel.numberOfExam = 2
        userDefault.set(true, forKey: "isWeeklyExamOpen")
        userDefault.set(2, forKey: "numberOfExam")
        
        highScore = 80
        lowScore = 60
        heightColor = "green"
        lowColor = "red"
        isWeightedOn = true
        isScoreInColor = true
        
        isShowDialog = false
        
//        userDefault.set("green", forKey: "heightColor")
//        userDefault.set("red", forKey: "lowColor")
//        userDefault.set(80, forKey: "heightScore")
//        userDefault.set(60, forKey: "lowScore")
//        userDefault.set(true, forKey: "isScoreInColor")
//        userDefault.set(true, forKey: "isWeightedOn")
    }
    
    
}

struct ColorData {
    let userDefault = UserDefaults.standard
    enum ColorType {
        case highStandard, lowStandard
        var key: String {
            switch self {
            case .highStandard:
                return "customHighColor"
            case .lowStandard:
                return "customLowColor"
            }
        }
    }
    func saveColor(_ color: Color, colorType type: ColorType) {
        let color = UIColor(color).cgColor
        
        guard let components = color.components else { return }
        
        userDefault.set(components, forKey: type.key)
    }
    
    func loadColor(colorType type: ColorType) -> Color? {
        guard let colorArray = userDefault.object(forKey: type.key) as? [CGFloat] else { return nil }
        let color = Color(red: colorArray[0], green: colorArray[1], blue: colorArray[2])
        
        return color
    }
}
