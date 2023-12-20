//
//  Setting.swift
//  Gremo
//
//  Created by Andy Lin on 2023/7/25.
//

import SwiftUI
import Charts
import UIKit

//extension State: Equatable where Value: Equatable {
//    public static func == (lhs: State<Value>, rhs: State<Value>) -> Bool {
//        lhs.wrappedValue == rhs.wrappedValue
//    }
//}

enum userdefaultsKey: String{
    case ChineseWeightedScore = "ChineseWeightedScore"
    case EnglishWeightedScore = "EnglishWeightedScore"
    case MathWeightedScore = "MathWeightedScore"
    case ScienceWeightedScore = "ScienceWeightedScore"
    case HistoryWeightedScore = "HistoryWeightedScore"
    case CivicsWeightedScore = "CivicsWeightedScore"
    case GeographyWeightedScore = "GeographyWeightedScore"
    case SocialWeightedScore = "SocialWeightedScore"
    case ListeningWeightedScore = "ListeningWeightedScore"
    case CompositionWeightedScore = "CompositionWeightedScore"
    case highScore = "heightScore"
    case lowScore = "lowScore"
    case highColor = "heightColor"
    case lowColor = "lowColor"
    case isScoreInColor = "isScoreInColor"
}

struct Setting: View {
    
    @StateObject var viewModel: SettingViewModel
    
    @EnvironmentObject var globalViewModel: GremoViewModel
    
    @Environment(\.colorScheme) private var colorScheme
    private var isLight: Bool {
        colorScheme == .light
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("設定")
                    .font(.title2.bold())
                    .padding()
                List {
                    Section {
                        Toggle("顏色表示成績", isOn: $globalViewModel.isScoreInColor)
                            .onChange(of: globalViewModel.isScoreInColor) { newValue in
                                UserDefaults.standard.set(newValue, forKey: "isScoreInColor")
                            }
                        
                        StandardSlider(label: "高分變色標準", value: $viewModel.highScore)
                            .disabled(!globalViewModel.isScoreInColor)
//                            .focused($focus)
                            .onChange(of: viewModel.highScore) { newValue in
                                viewModel.highScore = newValue > 100 ? 100: newValue < viewModel.lowScore ? viewModel.lowScore: newValue
                            }
                        
                        StandardSlider(label: "低分變色標準", value: $viewModel.lowScore)
                            .disabled(!globalViewModel.isScoreInColor)
                            .onChange(of: viewModel.lowScore) { newValue in
                                viewModel.lowScore = newValue > 100 ? 100: newValue > viewModel.highScore ? viewModel.highScore: newValue
                            }
                        
                        Picker(selection: $viewModel.heightColor) {
                            HStack{
                                Image(systemName: "square.fill")
                                    .foregroundColor(Color(.green))
                                Text("綠色")
                            }
                            .tag("green")
                            
                            HStack{
                                Image(systemName: "square.fill")
                                    .foregroundColor(.blue)
                                Text("藍色")
                            }
                            .tag("blue")
                            
                            HStack{
                                Image(systemName: "square.fill")
                                    .foregroundColor(.accentColor)
                                Text("紫色")
                            }
                            .tag("purple")
                        } label: {
                            Text("自訂顏色（高分）")
                        }
                        .pickerStyle(.navigationLink)
                        .disabled(!globalViewModel.isScoreInColor)
                        
                        Picker(selection: $viewModel.lowColor) {
                            HStack{
                                Image(systemName: "square.fill")
                                    .foregroundColor(Color(.red))
                                
                                Text("紅色")
                            }
                            .tag("red")
                            
                            HStack{
                                Image(systemName: "square.fill")
                                    .foregroundColor(.orange)
                                
                                Text("橘色")
                            }
                            .tag("orange")
                            
                            HStack{
                                Image(systemName: "square.fill")
                                    .foregroundColor(.yellow)
                                
                                Text("黃色")
                            }
                            .tag("yellow")
                            
                        } label: {
                            Text("自訂顏色（低分）")
                        }
                        .pickerStyle(.navigationLink)
                        .disabled(!globalViewModel.isScoreInColor)
                        
                    } header: {
                        Text("成績表示方法")
                    } footer: {
                        Text("超過變色標準時的顏色")
                    }
                    
                    Section{
                        NavigationLink(destination: {
                            subjectChoose(viewModel: SubjectChooseViewModel(globalViewModel: globalViewModel))
                                .environmentObject(globalViewModel)
                        }, label: {
                            HStack {
                                Image(systemName: "switch.2")
                                    .bold()
                                
                                Text("科目設定")
                            }
                        })
                    } footer: {
                        Text("主頁面顯示的科目")
                    }
                    
                    Section{
                        HStack {
                            Image(systemName: "chart.pie")
                                .font(.body.bold())
                            
                            Toggle("加權分", isOn: $viewModel.isWeightedOn)
                        }
                        
                        NavigationLink(destination: {
                            WeightedSetting()
                                .environmentObject(globalViewModel)
                        }, label: {
                            Image(systemName: "slider.horizontal.3")
                                .bold()
                            
                            Text("各科加權分")
                        })
                        .disabled(!viewModel.isWeightedOn)
                        
                    }
                    
                    Section("考試範圍") {
                        HStack {
                            Text("週考")
                                .padding(.trailing, 50)
                            
                            Picker(selection: $globalViewModel.isWeeklyExamOpen) {
                                Text("開啟")
                                    .tag(true)
                                
                                Text("關閉")
                                    .tag(false)
                                
                            } label: {
                                Text("週考")
                            }
                            .pickerStyle(.segmented)
                            .onChange(of: globalViewModel.isWeeklyExamOpen) { newValue in
                                UserDefaults.standard.set(newValue, forKey: "isWeeklyExamOpen")
                            }
                        }
                        
                        HStack {
                            Text("考試次數")
                                .padding(.trailing, 16)
                            
                            Picker(selection: $globalViewModel.numberOfExam) {
                                ForEach(0..<3) { i in
                                    Text(String(i + 1))
                                        .tag(i)
                                }
                                
                            } label: {
                                Text("")
                            }
                            .pickerStyle(.segmented)
                            .onChange(of: globalViewModel.numberOfExam) { newValue in
                                UserDefaults.standard.set(newValue, forKey: "numberOfExam")
                            }
                        }
                    }
                    
                    
                    Section {
                        Button("重置設定") {
                            viewModel.isShowDialog = true
                        }
                        .foregroundColor(.red)
                    }
                    .confirmationDialog("此動作無法復原，確定要繼續嗎？",
                                        isPresented: .constant(viewModel.isShowDialog),
                                        titleVisibility: .visible) {
                        Button("重置設定", role: .destructive) { viewModel.resetSetting() }
                        
                        Button("取消", role: .cancel) { viewModel.isShowDialog = false }
                    } message: {
                        Text("將刪除所有個人化設定")
                    }
                    
                    Section {
                        
//                        Text("[前往評分](https://apps.apple.com/app/gremo/id6450648780)")
                        Link(destination: URL(string: "https://apps.apple.com/app/gremo/id6450648780")!) {
                            Text("前往評分")
                        }
                        
                        //跳轉到app store的gremo頁面
                        //my app in App Store: https://apps.apple.com/app/gremo/id6450648780
                        
//                        Text("[回報問題](https://www.instagram.com/gremo_0717/)")
                        
                        Link(destination: URL(string: "https://www.instagram.com/gremo_0717/")!) {
                            Text("回報問題")
                        }
                        //my instagram: https://www.instagram.com/gremo_0717/
                    } footer: {
                        Text("請自己按下那個發送訊息，我會以最快的速度回覆你")
                    }
                }
                .listStyle(.grouped)
            }
            .background(isLight ? Color(red: 0.949, green: 0.949, blue: 0.971) : .black)
        }
        .scrollDismissesKeyboard(.interactively)
        //要把這個放在整個視圖的最大區，也就是放在最後，來修飾整個頁面的鍵盤消失辦法
    }
}

struct Setting_Previews: PreviewProvider {
    static var previews: some View {
        Setting(viewModel: SettingViewModel(globalViewModel: GremoViewModel()))
            .environmentObject(GremoViewModel())
        Home(viewModel: GremoViewModel())
    }
}
