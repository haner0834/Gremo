//
//  GremoApp.swift
//  Gremo
//
//  Created by Andy Lin on 2023/6/19.
//

import SwiftUI
import TipKit

@main
struct GremoApp: App {
    @StateObject private var viewModel = GremoViewModel()
    
    var body: some Scene {
        WindowGroup {
            Home(viewModel: viewModel)
                .task {
                    if #available(iOS 17, *) {
//                        try? Tips.resetDatastore()
                        try? Tips.configure([
    //                        .displayFrequency(.immediate),
                            .datastoreLocation(.applicationDefault)
                        ])
                    }
                }
        }
    }
}

