//
//  ScoreCalculateView.swift
//  Gremo
//
//  Created by Andy Lin on 2023/10/23.
//

import Foundation
import SwiftUI

struct ScopeButton: View {
    let scope: Int
    let action: () -> Void
    
    var label: String {
        let text: [String] = ["一週", "一段", "二週", "二段", "三週", "三段"]
        
        for (i, item) in text.enumerated() {
            if scope == i {
                return item
            }
        }
        
        return "error: cannot find scope"
    }
    
    var body: some View {
        ZStack {
            Color.accentColor
            
            Text(label)
                .foregroundColor(Color("ContraryColor"))
                .padding(.vertical, 8)
        }
        .cornerRadius(12)
        .padding(.horizontal, 1)
        .onTapGesture {
            action()
        }
    }
}

struct ScoreEditor: View {
    @Binding var score: String
    var color: Color
    let label: String
    let weighted: Double
    
    var body: some View {
        HStack {
            VStack {
                Text(label)
                
//                if !score.isEmpty {
                Rectangle()
                    .frame(width: 35, height: 3)
                    .foregroundColor(color)
                    .cornerRadius(1)
                    .padding(.top, -7)
//                }
            }
            
            TextField("\(label)分數", text: $score)
                .padding(.leading, 20)
                .keyboardType(.numberPad)

            Text("× \(String(format: "%.0f", weighted))")
                .font(.footnote)
                .foregroundColor(.gray)
        }
    }
}

struct AverageText: View {
    let label: String
    var value: Double
    var color: Color
    var textColor: Color
    
    var body: some View {
        HStack{
            Circle()
                .padding(.leading, 10)
                .frame(width: 25)
                .foregroundColor(color)
            Text(String(format: "\(label)平均：%.2f", value))
                .padding(.leading, 10)
                .padding(2)
                .font(.title2)
                .padding(.top, 2)
                .foregroundColor(textColor)
        }
    }
}

#Preview(body: {
    ScopeButton(scope: 1) { }
    
//    HStack {
//        Text("science")
//            .padding(5)
//            .background(Color("Green").opacity(0.4))
//            .cornerRadius(10)
//    }
})
