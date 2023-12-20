//
//  Details.swift
//  Gremo
//
//  Created by Andy Lin on 2023/6/28.
//
//上一步：command + Z

import SwiftUI
import Charts
import TipKit


struct Details: View {
    
    @StateObject var viewModel: DetailsViewModel
    
    @GestureState var dragOffset = CGSize.zero
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                
                GroupBox {
                    
                    HStack(alignment: .bottom){
                        Text("各科分數")
                            .font(.title3.bold())
                        
                        Spacer()
                        
                        Text("範圍：\(viewModel.scopeText(for: viewModel.scope))")
                            .padding(.bottom, 2)
                            .foregroundColor(.gray)
                            .font(.callout)
                    }
                    
                    ZStack {
                        let positions = [viewModel.x1, viewModel.x2, viewModel.x3]
                        
                        //position.width:手勢偏移量最後的數字，用以防止drageOffset在手勢消失後自動歸零的問題
                        //dragOffset: 追蹤手勢的偏移量
                        /*只用一個position來追蹤最後位置的用意在於，結束後position還是會被清空，
                         真正造成視圖重疊的原因應該在dragOffset*/
                        ForEach(0..<3, id: \.self) { i in
//                            viewModel.ChartView(scope: viewModel.changeChartScope()[i])
                            BarChartView(chartData: viewModel.chartData(scope: viewModel.changeChartScope()[i]))
                                .offset(x: positions[i] + viewModel.position.width + dragOffset.width)
                        }
                    }
                    .onChange(of: viewModel.scope) { newValue in
                        viewModel.animate = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            viewModel.animate = false
                        }
                    }
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                         //更新方法
                        .updating($dragOffset, body: { (currentPosition, state, transaction) in
                            state = currentPosition.translation
                        })
                        .onEnded({ value in
                            viewModel.dragGesture(value)
                        })
                )
                .padding()
                
                GroupBox("分數佔比") {
                    HStack {
                        Text("加權分")
                            .padding(.trailing, 90)
                        
                        Picker("", selection: $viewModel.isHasWeighted) {
                            Text("開啟")
                                .tag(true)
                            
                            Text("關閉")
                                .tag(false)
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: viewModel.isHasWeighted) { newValue in
                            viewModel.animate = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                viewModel.animate = false
                            }
                            viewModel.changeChartData(viewModel.pickerValue)
                        }
                    }
                    .padding(.horizontal, 10)
                    
                    HStack {
                        Text("類型")
                            .padding(.trailing, 50)
                        
                        Picker("", selection: $viewModel.pickerValue) {
                            let patterns: [String] = ["全部", "文科", "數理科", "社會科"]
                            
                            ForEach(patterns, id: \.self) { typeName in
                                Text(typeName)
                                    .tag(typeName)
                            }
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: viewModel.pickerValue) { newValue in
                            viewModel.animate = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                viewModel.animate = false
                            }
                            viewModel.changeChartData(newValue)
                        }
                    }
                    .padding(.horizontal, 10)
                    
                    Chart {
                        ForEach(viewModel.subjectInfo) { info in
                            let isHasWeighted = viewModel.isHasWeighted
                            
                            BarMark(x: .value("score", info.calculateScore(isHasWeighted: isHasWeighted)),
                                    y: .value("name", "分數")
                            )
                            .foregroundStyle(info.color)
                        }
                    }
                    .chartXScale(domain: 0...viewModel.max)
                    .chartForegroundStyleScale(viewModel.scoreInfo)
                    .frame(height: 120)
                    .animation(.easeIn(duration: 0.7), value: viewModel.animate)
                }
                .padding()
                
                HStack{
                    VStack(alignment: .leading) {
                        Text(String(format: "總        分： %.0f",
                                    viewModel.totalScore))
                        
                        //要把類型換成string在文本顯示方面才不會有分隔點（1,000、1,111,111 <-這種的）
                            .padding(.leading)
                            .padding(.bottom, 2)
                            .padding(.top, 5)
                        Text(String(format: "平  均  分：%.2f",
                                    viewModel.averageScore.total))
                            .padding(.leading)
                    }
                    
                    Spacer()
                }
                
                ForEach(viewModel.squareValue) { value in
                    ScoreDetailsSquare(name: value.name,
                                       geometry: geometry,
                                       averageScore: value.averageScore,
                                       color: value.color) {
                        ForEach(value.info) { item in
                            if item.isOn {
                                Text(String(format: "\(item.name)： %.0f", Double(item.score) ?? 0.0))
                            }
                        }
                    }
                }
                
                Text(viewModel.weightedText)
                    .font(.caption2)
                    .padding(.top, 30)
            }
            .navigationTitle("分數詳情")
            .onAppear {
                viewModel.initializationPosition()
//                if #available(iOS 17, *) {
//                    CheckDetailsTip().invalidate(reason: .actionPerformed)
//                }
            }
//            .onDisappear {
//                viewModel.globalViewModel.readScoreData(scope: 0)
//            }
        }
    }
}

struct Details_Previews: PreviewProvider {
    static var previews: some View {
        Details(viewModel: DetailsViewModel(globalViewModel: GremoViewModel()))
        
        Home(viewModel: GremoViewModel())
    }
}
