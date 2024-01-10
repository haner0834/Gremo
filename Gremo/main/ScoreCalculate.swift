//
//  ScoreCalculate.swift
//  Gremo
//
//  Created by Andy Lin on 2023/7/5.
//

import SwiftUI
import Foundation
import TipKit


struct ScoreCalculate: View {
    @EnvironmentObject var globalViewModel: GremoViewModel
    
    @Environment(\.colorScheme) private var colorScheme
    var isLight: Bool {
        colorScheme == .light
    }
    
    @StateObject var viewModel: ScoreCalculateViewModel
    
    @FocusState var focused: Subject?
    
    let userDefault = UserDefaults.standard
    
    @State private var columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 3)
    
    let LinearColor: [Color] = [
        Color(red: 0.615, green: 0.737, blue: 0.997),
        Color(red: 0.785, green: 0.662, blue: 0.999),
        Color(hue: 0.766, saturation: 0.367, brightness: 0.983)
    ]
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                HStack {
                    
                    LinearGradient(colors: LinearColor,
                                   startPoint: .leading,
                                   endPoint: .trailing)
                    .frame(width: 107, height: 50)
                    .mask {
                        Text("Gremo")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                    }
                    .padding(.leading, 25)
                    
//                    Text("Gremo")
//                        .font(.largeTitle)
//                        .fontWeight(.semibold)
//                        .foregroundColor(.accentColor)
//                        .padding(.leading, 30)
                    
                    Spacer()
                    
                    
                    if #available(iOS 17, *) {

                        NavigationLink {
                            Details(viewModel: DetailsViewModel(globalViewModel: globalViewModel))
                        } label: {
                            Image(systemName: "chart.bar.fill")
                                .font(.title2)
                                .padding(7)
                                .padding(.vertical, 4)
                                .background(Color.accentColor.opacity(0.3))
                                .cornerRadius(25)
                        }
                        .padding(.trailing, 20)
                        .popoverTip(CheckDetailsTip())
                    }else {
                        NavigationLink {
                            Details(viewModel: DetailsViewModel(globalViewModel: globalViewModel))
                        } label: {
                            Image(systemName: "chart.bar.fill")
                                .font(.title2)
                                .padding(7)
                                .padding(.vertical, 4)
                                .background(Color.accentColor.opacity(0.3))
                                .cornerRadius(25)
                        }
                        .padding(.trailing, 20)
                    }
                }
                
                LazyVGrid(columns: columns) {
                    let isWeeklyExamOpen = globalViewModel.isWeeklyExamOpen
                    let numberOfExam = globalViewModel.numberOfExam + 1
                    let range: Int = numberOfExam * 2
                    
                    ForEach(0..<6, id: \.self) { i in
                        var isWeeklyExamVisible: Bool {
                            if !viewModel.subjects.isWeeklyExamOpen {
                                return i % 2 == 1
                                //取出段考的部分
                            }
                            
                            return true
                        }
                        
                        if isWeeklyExamVisible && i < range {
                            ScopeButton(scope: i) {
                                withAnimation {
                                    focused = nil
                                    
                                    viewModel.scope = i
                                    
                                    viewModel.getScopeScore(i)
                                }
                            }
                            .opacity(viewModel.scope == i ? 1: 0.4)
                        }
                    }
                }
                .padding(.horizontal)
                .onChange(of: viewModel.scope) { newValue in
                    userDefault.set(newValue, forKey: "scope")
                }
                
                Form {
                    ForEach(0..<viewModel.subjects.info.count, id: \.self) { i in
                        //用i來代表是因為ScoreEditor的score用的是Binding<String>，沒辦法用遍歷整個array的東東來表示
                        //‼️‼️‼️‼️不要再亂改了‼️‼️‼️‼️
                        let item = viewModel.subjects.info[i]
                        let score = viewModel.subjects.info[i].score
                        
                        if item.isOn {
                            //我到7.0才有要把這些科目加進去：）
                            ScoreEditor(score: $globalViewModel.info[i].score,
                                        color: viewModel.textColor(score: Double(score) ?? 0, isAverage: false),
                                        label: item.name,
                                        weighted: item.weighted)
                            .focused($focused, equals: item.subject)
                            .onChange(of: item.score) { _ in
                                let score = Double(item.score) ?? 0
                                if score > 100  {
                                    viewModel.subjects.info[i].score = "100"
                                }
                                
                                viewModel.calculateAverageScore()
                                
                                viewModel.subjects.totalScore = viewModel.subjects.info.getTotalScore()
                                
                                if focused != nil {
                                    viewModel.saveScoreData()
                                }
                            }
                        }
                    }
                }
                .customPopoverTip()
                .frame(height: CGFloat(viewModel.subjects.info.filter { $0.isOn }.count * 45) + 50.0)
                .padding(.bottom, 16)
                .onChange(of: focused) { newValue in
                    for (i, info) in globalViewModel.info.enumerated() where Double(info.score) ?? 0 > 100 {
                        globalViewModel.info[i].score = "100"
                    }
                }
                
                VStack(alignment: .leading) {
                    HStack{
                        Text(String(format: "總        分：%.0f", viewModel.subjects.totalScore))
                            .padding(.leading, 13)
                            .padding(.top, 2)
                            .font(.title3)
                        
//                        Text("**總          分**：\(String(format: "%.0f", viewModel.subjects.totalScore))")
//                            .padding(.leading, 13)
//                            .padding(.top, 2)
//                            .font(.title3)
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.showWarning = true
                            
                        }, label: {
                            Text("刪除全部")
                        })
                        .foregroundColor(.red)
                        .padding(.trailing, 20)
                        .confirmationDialog("此動作將無法復原，確定繼續嗎？",
                                            isPresented: $viewModel.showWarning,
                                            titleVisibility: .visible) {
                            Button("確定", role: .destructive) {
                                viewModel.deleteScoreData()
                            }
                            
                            Button("取消", role: .cancel) {
                                viewModel.showWarning = false
                            }
                        } message: {
                            Text("將刪除此範圍所有的成績，包括已儲存的成績")
                        }
                        
                    }
                    Text(String(format: "平  均  分：%.2f", viewModel.subjects.averageScores.total))
                        .padding(.leading, 10)
                        .padding(2)
                        .font(.title3)
                        .foregroundColor(viewModel.textColor(score: viewModel.subjects.averageScores.total))
                    
                    AverageText(label: "文科",
                                value: viewModel.subjects.averageScores.arts,
                                color: chartColor(.lightBlue),
                                textColor: viewModel.textColor(score: viewModel.subjects.averageScores.arts))
                    
                    AverageText(label: "數理",
                                value: viewModel.subjects.averageScores.science,
                                color: chartColor(.purpleBlue),
                                textColor: viewModel.textColor(score: viewModel.subjects.averageScores.science))

                    AverageText(label: "社會",
                                value: viewModel.subjects.averageScores.social,
                                color: chartColor(.purple),
                                textColor: viewModel.textColor(score: viewModel.subjects.averageScores.social))
                    
                }
            }
            .onTapGesture {
                //被點擊（此視圖）時執行下列程式碼
                focused = nil
                //focus的類型是 @FocusState，且綁定Focus字典的類型，不能用true, false來定義，要用一個值或沒有值（nil）來分配
            }
            
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onEnded({ value in
                    focused = nil
                    viewModel.changeScope(value)
                })
            )
            //要把onEnded包在gesture裡面，所以最後一個括號是要包著onEnded
        }
        .onAppear {
            
            let numberOfExam = globalViewModel.numberOfExam + 1
            let isWeeklyExamOpen = userDefault.bool(forKey: "isWeeklyExamOpen")
            columns = Array(repeating: GridItem(.flexible()),
                            count: isWeeklyExamOpen ? numberOfExam * 2: numberOfExam)
            
            focused = nil
            
            viewModel.createInitialValue()
        }
    }
}

struct ScoreCalculate_Previews: PreviewProvider {
    static var previews: some View {
        ScoreCalculate(viewModel: ScoreCalculateViewModel(score: GremoViewModel()))
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
//            .task {
//                if #available(iOS 17, *) {
//                    try? Tips.resetDatastore()
//                    try? Tips.configure([
////                        .displayFrequency(.immediate),
//                        .datastoreLocation(.applicationDefault)
//                    ])
//                }
//            }
    }
}
