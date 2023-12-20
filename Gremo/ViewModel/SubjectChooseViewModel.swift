//
//  SubjectChooseViewModel.swift
//  Gremo
//
//  Created by Andy Lin on 2023/11/22.
//

import Foundation

class SubjectChooseViewModel: ObservableObject {
    @Published var globalViewModel: GremoViewModel
    
    init(globalViewModel: GremoViewModel) {
        self.globalViewModel = globalViewModel
    }
}
