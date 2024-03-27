//
//  ScoreCalculateModel.swift
//  Gremo
//
//  Created by Andy Lin on 2023/10/23.
//

import Foundation
import SwiftUI

enum Focused: Hashable {
    case chinese
    case english
    case math
    case science
    case history
    case civics
    case geography
    case social
    case listening
    case composition
}

struct TextFieldValue: Identifiable {
    var id = UUID()
    var focus: Focused
    var name: String
    var value: State<String>
    var binding: Binding<String>
    var key: String
}

enum ChangeType {
    case delete, cancelDelete, openCalculate, closeCalculate
    
    var alertItem: AlertItem {
        switch self {
        case .delete:
            return AlertContext.deleteSubject
        case .cancelDelete:
            return AlertContext.cancelDeleteSubject
        case .openCalculate:
            return AlertContext.openedSubject
        case .closeCalculate:
            return AlertContext.closedSubject
        }
    }
}

//MARK: - structs

struct AverageScore {
    var total: Double
    var arts: Double
    var science: Double
    var social: Double
    
    init(total: Double, arts: Double, science: Double, social: Double) {
        self.total = total
        self.arts = arts
        self.science = science
        self.social = social
    }
}
