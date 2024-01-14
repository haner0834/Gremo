//
//  TipsModel.swift
//  Gremo
//
//  Created by Andy Lin on 2024/1/10.
//

import Foundation
import TipKit

@available(iOS 17, *)
struct NewFunctions: Tip {
    static let newFunctionEvent = Event(id: "newFunctionEvent")
    
    var title: Text {
        Text("新功能")
    }
    
    var message: Text? {
        Text("把各科的加權分放到輸入格旁邊、\n把科目的分類用顏色顯示")
    }
    
    
    var image: Image? {
        Image(systemName: "star.circle")
    }

    var rules: [Rule] {
        #Rule(Self.newFunctionEvent) { event in
            event.donations.count > 1
            //開啟app超過1次
        }
    }
}

@available(iOS 17, *)
struct CheckDetailsTip: Tip {
    static let checkDetailsEvent = Event(id: "checkDetailsEvent")
    
    var title: Text {
        Text("查看你的成績詳情")
    }
    
    var message: Text? {
        Text("將成績繪製成圖表")
    }
    
    var rules: [Rule] {
        #Rule(Self.checkDetailsEvent) { event in
            event.donations.count == 0
        }
    }
}

@available(iOS 17, *)
struct ShowWhyDisableTip: Tip {
    static let showWhyDisable = Event(id: "showWhyDisable")
    
    var title: Text {
        Text("已禁用關閉的科目")
    }
    
    var message: Text? {
        Text("若將科目關閉，將無法在此頁面查看成績 :D")
    }
    
    var image: Image? {
        Image(systemName: "xmark.circle")
    }
    
    var rules: [Rule] {
        #Rule(Self.showWhyDisable) { event in
            event.donations.count < 3
        }
    }
}

extension View {
    func customPopoverTip() -> some View {
        if #available(iOS 17, *) {
            return self.popoverTip(NewFunctions())
        }else {
           return self
        }
    }
}
