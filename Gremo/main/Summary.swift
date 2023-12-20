//
//  Summary.swift
//  Gremo
//
//  Created by Andy Lin on 2023/8/13.
//

import SwiftUI
import Charts

struct Summary: View {
    
    @StateObject var viewModel: SummaryViewModel
    
    @EnvironmentObject var globalViewModel: GremoViewModel
    
    @State private var isShowEdit: Bool = false
    
    let scale: KeyValuePairs<String, Color> = [
        "平均": .accentColor,
        "國文": chartColor(.lightBlue),
        "英文": chartColor(.yellow),
        "數學": chartColor(.green),
        "理化": chartColor(.purpleBlue),
        "歷史": chartColor(.purple),
        "公民": chartColor(.orange),
        "地理": chartColor(.greenblue),
        "社會": chartColor(.blue),
        "英聽": chartColor(.pink),
        "作文": chartColor(.brown)]
    
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    GroupBox{
                        VStack {
                            NavigationBarOfGroup(action: {
                                isShowEdit.toggle()
                            })
                            
//                            HStack {
//                                Text("分數趨勢")
//                                    .font(.title3.bold())
//                                
//                                Spacer()
//                            }
                            
                            Chart {
                                if viewModel.scoreSummary.minScore() <= 60 {
                                    RuleMark(y: .value("及格線", 60))
                                        .foregroundStyle(.blue.opacity(0.7))
                                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [7, 16]))
                                }
                                
                                ForEach(viewModel.scoreSummary) { summary in
                                    ForEach(summary.value) { score in
                                        PointMark(
                                            x: .value("", score.examName),
                                            y: .value("", score.score)
                                        )
                                        //.foregroundStyle(summary.color)
                                        
                                        LineMark(
                                            x: .value("name", score.examName),
                                            y: .value("count", score.score)
                                        )
                                        //.foregroundStyle(summary.color)
                                    }
                                    .foregroundStyle(by: .value("key", summary.name))
                                    //.symbol(by: .value("", summary.name))
                                }
                            }
                            .chartYScale(domain: (viewModel.scoreSummary.minScore() - 10)...100)
                            .chartForegroundStyleScale(scale)
                            .frame(height: 180)
                            .sheet(isPresented: $isShowEdit) {
                                LinechartSetting()
                                    .environmentObject(globalViewModel)
                                    .presentationDetents([.fraction(0.7), .large])
                            }
                        }
                    }
                    
                    let key = "Average"
                    let comparedScore = viewModel.compareScore(key: key)
                    NavigationButton(average: viewModel.getAverage(key: key),
                                     subjectName: "",
                                     key: key,
                                     imageName: viewModel.getImageName(comparedScore),
                                     comparedScore: comparedScore,
                                     textColor: viewModel.getImageColor(comparedScore))
                    .frame(minHeight: 37)
                    
                    
                    ForEach(globalViewModel.info) { info in
                        let average = viewModel.getAverage(key: info.key)
                        let comparedScore = viewModel.compareScore(key: info.key)
                        if info.isOn && info.subject.isAvailable {
                            NavigationButton(average: average,
                                             subjectName: info.name,
                                             key: info.key,
                                             imageName: viewModel.getImageName(comparedScore),
                                             comparedScore: comparedScore,
                                             textColor: viewModel.getImageColor(comparedScore))
                            .frame(minHeight: 37)
                        }
                        //.disabled(!info.isOn)
                    }
                } footer: {
                    Label("未開啟的科目無法看詳情 :D", systemImage: "exclamationmark.circle.fill")
                        .foregroundStyle(.yellow.opacity(0.7))
                }
            }
            .listStyle(.inset)
            
        }
        .onAppear{
            viewModel.initializeData()
        }
    }
}


struct Summary_Previews: PreviewProvider {
    static var previews: some View {
        Summary(viewModel: SummaryViewModel(globalViewModel: GremoViewModel()))
            .environmentObject(GremoViewModel())
        
        Home(viewModel: GremoViewModel())
        
    }
}

