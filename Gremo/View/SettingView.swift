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
    let color: Color
    
    init(_ label: String, value: Binding<Double>, color: Color) {
        self.label = label
        self.value = value
        self.color = color
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(label)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("", value: value, format: .number)
                    .keyboardType(.numberPad)
                    .overlay(RoundedRectangle(cornerRadius: 7)
                        .stroke(Color.accentColor.opacity(0.7), lineWidth: 2)
                        .padding(.horizontal, -16)
                    )
                    .frame(width: 30)
                    .padding(.trailing, 5)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Slider(value: value, in: 1...100, step: 1)
                .padding(.trailing)
                .padding(.vertical, -5)
                .listStyle(.inset)
                .tint(color)
        }
    }
}

struct ChooseHighColor: View {
    @Binding var color: Color
    
    var body: some View {
        Section {
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
            
            HStack{
                Image(systemName: "square.fill")
                    .foregroundColor(color)
                Text("自訂")
            }
            .tag("custom")
            
            ColorPicker(selection: $color, supportsOpacity: false) {
                HStack {
                    Image(systemName: "square.fill")
                        .foregroundColor(color)
                    Text("選擇顏色")
                }
            }
        }
    }
}

struct ChooseLowColor: View {
    @Binding var color: Color
    
    var body: some View {
        Section {
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
            
            HStack{
                Image(systemName: "square.fill")
                    .foregroundColor(color)
                Text("自訂")
            }
            .tag("custom")
            
            ColorPicker(selection: $color, supportsOpacity: false) {
                HStack {
                    Image(systemName: "square.fill")
                        .foregroundColor(color)
                    Text("選擇顏色")
                }
            }
        }
    }
}

#Preview {
    StandardSlider("hello", value: .constant(80), color: .accentColor)
}
