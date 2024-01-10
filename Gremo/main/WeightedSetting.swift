//
//  WeightedSetting.swift
//  Gremo
//
//  Created by Andy Lin on 2023/8/27.
//

import SwiftUI
import Foundation

struct WeightedSetting: View {
    
    @EnvironmentObject var globalViewModel: GremoViewModel
    
    var body: some View {
        List {
            
            CustomSlider(info: $globalViewModel.info,
                         filter: .arts,
                         name: "文科")
            
            CustomSlider(info: $globalViewModel.info,
                         filter: .science,
                         name: "數理科")
            
            CustomSlider(info: $globalViewModel.info,
                         filter: .social,
                         name: "社會科")
            
            Section { } footer: {
                Text("未開啟的科目無法改變加權分 :D")
            }
        }
        .listStyle(.grouped)
        .navigationTitle("加權分設定")
    }
}

struct WeightedSetting_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WeightedSetting()
                .environmentObject(GremoViewModel())
        }
        
        Home(viewModel: GremoViewModel())
    }
}


struct CustomSlider: View {
    @Binding var info: [SubjectInfo]
    let filter: SubjectType
    let name: String
    
    var body: some View {
        Section(name) {
            ForEach(0..<info.count, id: \.self) { i in
                let info = self.info[i]
                var isAvailalbe: Bool {
                    switch filter {
                    case .arts:
                        return info.subject.isArtsSubject
                    case .science:
                        return info.subject.isScienceSubject
                    case .social:
                        return info.subject.isSocialSubject
                    default:
                        return false
                    }
                }
                
                if isAvailalbe {
                    HStack{
                        Text(String(format: "\(info.name)：%.0f", self.info[i].weighted))
                        Slider(value: $info[i].weighted, in: 1...10, step: 1)
                            .padding(.leading)
                            .disabled(!info.isOn)
                    }
                    .onChange(of: self.info[i].weighted) { newValue in
                        UserDefaults.standard.set(newValue, forKey: "\(info.key)WeightedScore")
                    }
                }
            }
        }
    }
}
