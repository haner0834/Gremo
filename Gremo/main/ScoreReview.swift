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
                HStack {
                    Text("2023 - 上(2 to 6)")
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
        }
    }
}

#Preview {
    ScoreReview()
}
