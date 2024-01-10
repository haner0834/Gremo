//
//  subjectChoose.swift
//  Gremo
//
//  Created by Andy Lin on 2023/8/2.
//

import SwiftUI

struct ToggleValue: Identifiable {
    var id = UUID()
    var value: Binding<Bool>
    var label: String
}

struct subjectChoose: View {
    @StateObject var viewModel: SubjectChooseViewModel
    
    @EnvironmentObject var globalViewModel: GremoViewModel
    
    var body: some View {
        List {
            Section("文科") {
                ForEach(0..<globalViewModel.info.count, id: \.self) { i in
                    let info = globalViewModel.info[i]
                    if info.subject.isArtsSubject {
                        Toggle(info.name, isOn: $globalViewModel.info[i].isOn)
                            .onChange(of: globalViewModel.info[i].isOn) { newValue in
                                UserDefaults.standard.set(newValue, forKey: "is\(info.key)On")
                            }
                    }
                }
            }
            
            Section("數理科") {
                ForEach(0..<globalViewModel.info.count, id: \.self) { i in
                    let info = globalViewModel.info[i]
                    if info.subject.isScienceSubject {
                        Toggle(info.name, isOn: $globalViewModel.info[i].isOn)
                            .onChange(of: globalViewModel.info[i].isOn) { newValue in
                                UserDefaults.standard.set(newValue, forKey: "is\(info.key)On")
                            }
                    }
                }
            }
            
            Section("社會科") {
                ForEach(0..<globalViewModel.info.count, id: \.self) { i in
                    let info = globalViewModel.info[i]
                    if info.subject.isSocialSubject {
                        Toggle(info.name, isOn: $globalViewModel.info[i].isOn)
                            .onChange(of: globalViewModel.info[i].isOn) { newValue in
                                processSubjectOpen(i, newValue: newValue, key: info.key)
                            }
                    }
                }
            }
        }
        .listStyle(.grouped)
        .navigationTitle("設定科目")
    }
    
    func processSubjectOpen(_ i: Int, newValue: Bool, key: String) {
        if !newValue {
            UserDefaults.standard.set(newValue, forKey: "is\(key)On")
            return
        }
        
        let infos = globalViewModel.info
        let isOn = [infos.getIndex(for: .history),
                    infos.getIndex(for: .civics),
                    infos.getIndex(for: .geography)]
        
        if globalViewModel.info[i].subject != .social {
            globalViewModel.info[infos.getIndex(for: .social)].isOn = false
        }else {
            for index in isOn {
                globalViewModel.info[index].isOn = false
            }
        }
        
        for _ in isOn {
            UserDefaults.standard.set(newValue, forKey: "is\(key)On")
        }
    }
}

struct subjectChoose_Previews: PreviewProvider {
    static var previews: some View {
        subjectChoose(viewModel: SubjectChooseViewModel(globalViewModel: GremoViewModel()))
            .environmentObject(GremoViewModel())
        Home(viewModel: GremoViewModel())
    }
}
