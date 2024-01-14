//
//  Home.swift
//  Gremo
//
//  Created by Andy Lin on 2023/11/8.
//

import SwiftUI
import Foundation

struct Home: View {
    
    @StateObject private var viewModel: GremoViewModel
    
    @Environment(\.colorScheme) private var color
    
    private var isLight: Bool {
        color == .light
    }
    
    init(viewModel: GremoViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    let names: [NameItem] = [
        .init(label: "", systemName: "house.fill"),
        .init(label: "", systemName: "doc.plaintext.fill"),
        .init(label: "", systemName: "gearshape.fill")
    ]
    
    var body: some View {
        if #available(iOS 17, *) {
            ToolBarView(names: names) {
                ScoreCalculate(viewModel: ScoreCalculateViewModel(score: viewModel))
                    .environmentObject(viewModel)
                
                Summary(viewModel: SummaryViewModel(globalViewModel: viewModel))
                    .environmentObject(viewModel)
                
                Setting(viewModel: SettingViewModel(globalViewModel: viewModel))
                    .environmentObject(viewModel)
            }
            .onAppear {
                Task { await ShowWhyDisableTip.showWhyDisable.donate() }
            }
        }else {
            TabView {
                
                ScoreCalculate(viewModel: ScoreCalculateViewModel(score: viewModel))
                    .environmentObject(viewModel)
                    .tabItem{
                        Image(systemName: "house.fill")
                    }
                    .toolbarBackground(Color(.contrary), for: .tabBar)
                
                Summary(viewModel: SummaryViewModel(globalViewModel: viewModel))
                    .environmentObject(viewModel)
                    .tabItem{
                        Image(systemName: "doc.plaintext")
                    }
                    .toolbarBackground(Color(.contrary), for: .tabBar)
                
                //            Text("review")
                //                .tabItem{
                //                    Image(systemName: "gobackward")
                //                }
                //                .toolbarBackground(Color(.contrary), for: .tabBar)
                
                Setting(viewModel: SettingViewModel(globalViewModel: viewModel))
                    .environmentObject(viewModel)
                    .tabItem{
                        Image(systemName: "gearshape.fill")
                    }
                    .toolbarBackground(Color(.contrary), for: .tabBar)
            }
        }
    }
}

#Preview {
    Home(viewModel: GremoViewModel())
}
