//
//  SummaryView.swift
//  Gremo
//
//  Created by Andy Lin on 2023/12/12.
//

import Foundation
import SwiftUI
import Charts

struct NavigationBarOfGroup: View {
    var action: () -> Void
    
    var body: some View {
        HStack {
            Text("分數趨勢")
                .font(.title3.bold())
            
            Spacer()
            
            Button(action:{
                action()
                
            }, label: {
                Image(systemName: "info.circle")
                    .font(.title2)
                    .padding(.bottom, 1)
                
            })
            .padding(.trailing, 10)
            
        }
    }
}

struct NavigationButtonValue {
    var average: Double
    var subjectName: String
    var key: String
    var imageName: String
    var comparedScore: Double
    var textColor: Color
}

struct NavigationButton: View {
    let value: NavigationButtonValue
    
    var body: some View {
        NavigationLink {
            SubjectDetails(average: value.average, subjectName: value.subjectName, key: value.key)
        } label: {
            HStack{
                Text("\(value.subjectName)總平均")
                
                Spacer()
                
                VStack {
                    Text(String(format: "%.2f", value.average))
                    //平均分
                    
                    HStack {
                        Image(systemName: value.imageName)
                            .bold()
                            .padding(.trailing, -5)
                        
                        Text(String(format: "%.2f", value.comparedScore))
                        //改變的分數
                    }
                    .font(.caption)
                    .foregroundColor(value.textColor)
                    .padding(.bottom, 2)
                }
            }
        }
    }
}

struct SummaryChartView: View {
    var minScore: Double
    var scoreSummary: [LineChartValueItem]
    let scale: KeyValuePairs<String, Color>
    
    var body: some View {
        Chart {
            if minScore <= 60 {
                RuleMark(y: .value("及格線", 60))
                    .foregroundStyle(.blue.opacity(0.7))
                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [7, 16]))
            }
            
            ForEach(scoreSummary) { summary in
                ForEach(summary.value) { score in
                    PointMark(
                        x: .value("", score.examName),
                        y: .value("", score.score)
                    )
                    
                    LineMark(
                        x: .value("name", score.examName),
                        y: .value("count", score.score)
                    )
                }
                .foregroundStyle(by: .value("key", summary.name))
            }
        }
        .chartYScale(domain: (minScore - 10)...100)
        .chartForegroundStyleScale(scale)//這裡用了之後就可以不用再前面用.foregroundStyle()了
        .frame(height: 180)
    }
}
