//
//  DetailsView.swift
//  Gremo
//
//  Created by Andy Lin on 2023/11/15.
//

import SwiftUI
import Charts

struct ScoreDetailsSquare<Content: View>: View {
    let name: String
    var geometry: GeometryProxy
    var averageScore: Double
    let color: [Double]
    @ViewBuilder var content: () -> Content
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(name)平均：\(String(format: "%.2f", averageScore))")
                .font(.title3)
                .foregroundColor(Color(hue: color[0], saturation: color[1], brightness: color[2]))
                .padding([.top, .horizontal])
            
            LazyVGrid(columns: columns, spacing: 10) {
                content()
                    .foregroundColor(.black)
                    .frame(width: geometry.size.width / 3 + 20, alignment: .leading)
            }
            .padding(.leading, 15)
            .padding([.bottom, .horizontal])
        }
        .background(Color(hue: color[0], saturation: color[1] - 0.8, brightness: color[2]))
        .cornerRadius(25)
        .padding()
    }
}

struct BarChartView: View {
    var chartData: [Score1]
    
    var body: some View {
        VStack {
            Chart {
                RuleMark(y: .value("及格線", 60))
                //中間那條60分的區分線
                    .foregroundStyle(.blue)
                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [7]))
                
                ForEach(chartData) { score in
                    BarMark(
                        x: .value("科目", score.name),
                        y: .value("成績", score.count))
                    .foregroundStyle(score.color)
                }
            }
            .chartYScale(domain: 0...100)
            //定義圖表Y軸最大值
            .padding(.horizontal, 10.0)
            .frame(height: 160.0)
            .chartForegroundStyleScale([
                "文科": chartColor(.lightBlue),
                "數理科": chartColor(.purpleBlue),
                "社會科": chartColor(.purple)
            ])
            
            HStack {
                Image(systemName: "line.diagonal")
                    .rotationEffect(Angle(degrees: 45))
                    .foregroundColor(.blue)
                    .padding(.leading, 7)
                
                Text("及格線（60)")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
            }
        }
    }
}
