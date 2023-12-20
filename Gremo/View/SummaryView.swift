//
//  SummaryView.swift
//  Gremo
//
//  Created by Andy Lin on 2023/12/12.
//

import Foundation
import SwiftUI

struct NavigationBarOfGroup: View {
    var action: () -> Void
    
    var body: some View {
        HStack {
            Text("分數趨勢")
                .font(.title3.bold())
            
            Spacer()
            
            Button(action:{
                action()
                
            }, label: {
                Image(systemName: "info.circle")
                    .font(.title2)
                    .padding(.bottom, 1)
                
            })
            .padding(.trailing, 10)
            
        }
    }
}

struct NavigationButton: View {
    let average: Double
    let subjectName: String
    let key: String
    let imageName: String
    let comparedScore: Double
    let textColor: Color
    
    var body: some View {
        NavigationLink {
            SubjectDetails(average: average, subjectName: subjectName, key: key)
        } label: {
            HStack{
                Text("\(subjectName)總平均")
                
                Spacer()
                
                VStack {
                    Text(String(format: "%.2f", average))
                    //平均分
                    
                    HStack {
                        Image(systemName: imageName)
                            .bold()
                            .padding(.trailing, -5)
                        
                        Text(String(format: "%.2f", comparedScore))
                        //改變的分數
                    }
                    .font(.caption)
                    .foregroundColor(textColor)
                    .padding(.bottom, 2)
                }
            }
        }
    }
}

