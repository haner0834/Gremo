//
//  ScoreReview.swift
//  Gremo
//
//  Created by Andy Lin on 2023/12/20.
//

import SwiftUI

struct ScoreReview: View {
    var body: some View {
        ScrollView {
            HStack {
                Text("Score Review")
                    .font(.title).bold()
                    
                Spacer()
            }
            .padding(.horizontal)
            
            VStack {
                NavigationLink {
                    Text("review")
                } label: {
                    HStack {
                        Text("2023 - 上(2 to 6)")
                            .font(.title2).bold()
                        
                        Spacer()
                        
                        
                        Image(systemName: "chevron.up")
                            .bold()
                            .rotationEffect(.degrees(90))
                    }
                    .foregroundStyle(.black)
                }
                
//                HStack {
//                    Image(systemName: "gobackward")
//                        .bold()
//                    
//                    Text("see review")
//                    
//                    Spacer()
//                }
//                .padding([.top, .horizontal], 7)
                
//                MultiDatePicker(/*@START_MENU_TOKEN@*/"Label"/*@END_MENU_TOKEN@*/, selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Binding<Set<DateComponents>>@*/.constant([])/*@END_MENU_TOKEN@*/)
            }
            .padding()
            .padding(.vertical)
            .background(
                LinearGradient(colors: [Color(red: 0.712, green: 0.843, blue: 0.999),
                                        Color(red: 0.989, green: 0.838, blue: 0.832)
                                       ],
                               startPoint: .leading,
                               endPoint: .trailing)
                    .cornerRadius(20)
            )
            .padding()
            
            VStack {
                HStack {
                    Text("2023 - 下(8 to 1)")
                        .font(.title2).bold()
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "chevron.up")
                            .bold()
                            .rotationEffect(.degrees(90))
                    }
                }
            }
            .padding()
            .padding(.vertical)
            .background(
                LinearGradient(colors: [Color.blue.opacity(0.3),
                                        Color.red.opacity(0.2)
                                       ],
                               startPoint: .leading,
                               endPoint: .trailing)
                    .cornerRadius(20)
            )
            .padding()
        }
    }
}

struct TextView: View {
    var value: Double
    private var text: [Int]
    init(value: Double) {
        self.value = value
        self.text = Self.getTextArray(value)
    }
    var body: some View {
        HStack {
            ForEach(0..<text.count, id: \.self) { i in
                Text(String(text[i]))
            }
        }
    }
    
    static func getTextArray(_ value: Double) -> [Int] {
        var val: [Int] = []
        let jjj = String(value)
        for index in jjj {
            if let text = Int(String(index)), String(index) != "." {
                val.append(text)
            }
        }
        return val
    }
}

#Preview {
    NavigationStack {
        ScoreReview()
    }
}

#Preview(body: {
    TextView(value: 105)
})
