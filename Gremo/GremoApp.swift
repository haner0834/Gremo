//
//  GremoApp.swift
//  Gremo
//
//  Created by Andy Lin on 2023/6/19.
//

import SwiftUI

@main
struct GremoApp: App {
    @StateObject private var viewModel = GremoViewModel()
    
    var body: some Scene {
        WindowGroup {
            Home(viewModel: viewModel)

        }
    }
}

