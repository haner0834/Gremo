//
//  Summary.swift
//  Gremo
//
//  Created by Andy Lin on 2023/8/13.
//

import SwiftUI
import Charts
import TipKit

struct Summary: View {
    
    @StateObject var viewModel: SummaryViewModel
    
    @EnvironmentObject var globalViewModel: GremoViewModel
    
    @State private var isShowEdit: Bool = false
    
    @State private var scale: KeyValuePairs<String, Color> = [
        "平均": .accentColor,
        "國文": chartColor(.lightBlue),
        "英文": chartColor(.yellow),
        "數學": chartColor(.green),
        "物理": Color("White-Black"),
        "化學": .secondary,
        "生物": .teal,
        "地科": Color(hue: 0.082, saturation: 0.387, brightness: 0.799),
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
                            SummaryChartView(minScore: viewModel.scoreSummary.minScore(),
                                             scoreSummary: viewModel.scoreSummary,
                                             scale: scale)
                            .sheet(isPresented: $isShowEdit) {
                                LinechartSetting()
                                    .environmentObject(globalViewModel)
                                    .presentationDetents([.fraction(0.7), .large])
                            }
                        }
                    }
                    
                    if #available(iOS 17, *) {
                        TipView(ShowWhyDisableTip())
                    }
                    
                    let key = "Average"
                    let comparedScore = viewModel.compareScore(key: key)
                    let value: NavigationButtonValue =
                        .init(average: viewModel.getAverage(key: key),
                              subjectName: "",
                              key: key,
                              imageName: viewModel.getImageName(comparedScore),
                              comparedScore: comparedScore,
                              textColor: viewModel.getImageColor(comparedScore))
                    NavigationButton(value: value)
                    .frame(minHeight: 37)
                    
                    
                    ForEach(globalViewModel.info) { info in
                        let average = viewModel.getAverage(key: info.key)
                        let comparedScore = viewModel.compareScore(key: info.key)
                        let value: NavigationButtonValue = 
                            .init(average: average,
                                  subjectName: info.name,
                                  key: info.key,
                                  imageName: viewModel.getImageName(comparedScore),
                                  comparedScore: comparedScore,
                                  textColor: viewModel.getImageColor(comparedScore))
                        if #available(iOS 17, *) {
                            if ShowWhyDisableTip.showWhyDisable.donations.count > 2 {
                                if info.isOn {
                                    NavigationButton(value: value)
                                    .frame(minHeight: 37)
                                }
                            }else {
                                NavigationButton(value: value)
                                .frame(minHeight: 37)
                                .disabled(!info.isOn)
                            }
                        }else if info.isOn {
                            NavigationButton(value: value)
                            .frame(minHeight: 37)
                        }
                    }
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
            .task {
                if #available(iOS 17, *) {
                    try? Tips.resetDatastore()
                    try? Tips.configure([
//                        .displayFrequency(.immediate),
                        .datastoreLocation(.applicationDefault)
                    ])
                }
            }
        
        Home(viewModel: GremoViewModel())
            .task {
                if #available(iOS 17, *) {
                    try? Tips.resetDatastore()
                    try? Tips.configure([
//                        .displayFrequency(.immediate),
                        .datastoreLocation(.applicationDefault)
                    ])
                }
            }
        
    }
}

