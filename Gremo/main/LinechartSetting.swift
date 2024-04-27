//
//  LinechartSetting.swift
//  Gremo
//
//  Created by Andy Lin on 2023/8/23.
//

import SwiftUI

struct LinechartSetting: View {
    @EnvironmentObject var globalViewModel: GremoViewModel
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    @State private var checkBoxValue: [CheckBoxValueItem] = []
    
    
    private var isLight: Bool {
        colorScheme == .light
    }
    
    var body: some View {
        VStack {
            HStack {
                Button("全選") {
                    for i in 0..<checkBoxValue.count where checkBoxValue[i].isOn {
                        withAnimation {
                            checkBoxValue[i].isInChart.toggle()
                        }
                    }
                }

                Spacer()
                
                Label("選擇科目", systemImage: "checklist")
                    .font(.title2.bold())

                Spacer()

                Image(systemName: "xmark.circle.fill")
                    .font(.title2.bold())
                    .foregroundColor(.secondary)
                    .onTapGesture {
                        dismiss()
                    }
            }
            .padding([.horizontal, .top])
            
            List {
                Section {
                    ForEach(0..<checkBoxValue.count, id: \.self) { i in
                        let value = checkBoxValue[i]
                        CheckBox(value: $checkBoxValue[i].isInChart, title: value.name, isOn: value.isOn)
                            .onChange(of: checkBoxValue[i].isInChart) { newValue in
                                UserDefaults.standard.set(newValue, forKey: "is\(value.key)InChart")
                                globalViewModel.info[i].isInChart = newValue
                            }
                    }
                } footer: {
                    Text("尚未開啟的科目將無法改變加權分 :D")
                        .foregroundStyle(.gray)
                        .font(.caption)
                }
            }
        }
        .listStyle(.automatic)
        .background(isLight ? Color(red: 0.949, green: 0.949, blue: 0.971): Color(red: 0.11, green: 0.11, blue: 0.118))
        .onAppear {
            for info in globalViewModel.info {
                var isSubjectInChart: Bool = UserDefaults.standard.bool(forKey: "is\(info.key)InChart")
                checkBoxValue.append(.init(name: info.name, key: info.key, isInChart: isSubjectInChart, isOn: info.isOn))
            }
        }
    }
}

struct CheckBoxValueItem: Identifiable {
    var id = UUID()
    let name: String
    let key: String
    var isInChart: Bool
    let isOn: Bool
}

struct CheckBox: View {
    @Binding var value: Bool
    let title: String
    let isOn: Bool
    
    var imageName: String {
        if value { return "checkmark.circle.fill" }
        return "circle"
    }
    
    
    var body: some View {
        Button(action: {
            withAnimation {
                value.toggle()
            }
        }, label: {
            HStack {
                Image(systemName: imageName)
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                
                Text(title)
                    .foregroundStyle(Color(.whiteBlack).opacity(isOn ? 1: 0.5))
            }
        })
        .disabled(!isOn)
    }
}

struct LinechartSetting_Previews: PreviewProvider {
    static var previews: some View {
        LinechartSetting()
            .environmentObject(GremoViewModel())
        Summary(viewModel: SummaryViewModel(globalViewModel: GremoViewModel()))
            .environmentObject(GremoViewModel())
        Home(viewModel: GremoViewModel())
    }
}
