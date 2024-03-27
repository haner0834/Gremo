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
                .font(.callout)
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
    var info: SubjectInfo
    
    var circleColor: Color {
        if info.subject.isArtsSubject {
            return chartColor(.lightBlue)
        }
        if info.subject.isScienceSubject {
            return chartColor(.purpleBlue)
        }
        if info.subject.isSocialSubject {
            return chartColor(.purple)
        }
        return .primary
    }
    
    var body: some View {
        HStack {
            Circle()
                .foregroundStyle(circleColor)
                .frame(width: 10)
                .padding(.trailing, 7)
            
            VStack {
                Text(info.name)
                
//                if !score.isEmpty {
                Rectangle()
                    .frame(width: 35, height: 3)
                    .foregroundColor(color)
                    .cornerRadius(1)
                    .padding(.top, -7)
//                }
            }
            
            TextField("\(info.name)分數", text: $score)
                .padding(.leading, 20)
                .keyboardType(.numberPad)

            Text("× \(String(format: "%.0f", info.weighted))")
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
                .font(.title3)
                .padding(.top, 2)
                .foregroundColor(textColor)
        }
    }
}

struct ChangeCalculateButton: View {
    let isAllowCalculate: Bool
    let action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            Label("", systemImage: "lock\(isAllowCalculate ? "": ".open")")
        }
        .tint(.orange)
    }
}

struct CloseSubjectButton: View {
    let action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            Label("", systemImage: "trash")
        }
        .tint(.red)
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
