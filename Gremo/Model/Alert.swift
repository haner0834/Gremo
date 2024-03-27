//
//  Alert.swift
//  Gremo
//
//  Created by Andy Lin on 2024/3/24.
//

import Foundation
import SwiftUI

final class AlertContext {
    static let closedSubject = AlertItem(title: "你已將此科目關閉計算",
                                  message: "左側按鈕復原",
                                  buttomTitle: "復原")
    static let openedSubject = AlertItem(title: "你已將此科目開啟計算",
                                  message: "左側按鈕復原",
                                  buttomTitle: "復原")
    static let deleteSubject = AlertItem(title: "你已將此科目刪除",
                                  message: "如果要復原，可以至設定->科目設定來開啟",
                                  buttomTitle: "復原")
    static let cancelDeleteSubject = AlertItem(title: "你已將此科目復原",
                                  message: "如果要復原，可以至設定->科目設定來關閉",
                                  buttomTitle: "復原")
}

struct AlertItem: Identifiable {
    let id = UUID()
    let title: String?
    let message: String?
    let buttomTitle: String
}
