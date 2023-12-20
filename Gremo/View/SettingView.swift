//
//  SettingView.swift
//  Gremo
//
//  Created by Andy Lin on 2023/11/22.
//

import SwiftUI

struct StandardSlider: View {
    let label: String
    var value: Binding<Double>
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text(label)
                    
                    Spacer()
                }
                    
                Slider(value: value, in: 1...100, step: 1)
                    .padding(.trailing)
                    .padding(.vertical, -5)
            }
            
            TextField("", value: value, format: .number)
                .keyboardType(.numberPad)
                .overlay(RoundedRectangle(cornerRadius: 7)
                    .stroke(Color.accentColor.opacity(0.7), lineWidth: 2)
                    .padding(.horizontal, -16))
                .frame(width: 30)
                .padding(.trailing, 5)
                .multilineTextAlignment(.trailing)
        }
    }
}
