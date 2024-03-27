//
//  BottomAlert.swift
//  Gremo
//
//  Created by Andy Lin on 2024/3/24.
//

import Foundation
import SwiftUI

struct BottomAlert<Content: View>: View {
    let title: String?
    let message: String?
    var button: Button<Text>?
    @ViewBuilder var content: () -> Content
    
    @Binding var isShow: Bool
    @GestureState private var offset = CGSize.zero
    @State private var dragOffset = CGSize.zero
    
    init(isShow: Binding<Bool>,
         title: String? = nil,
         message: String? = nil,
         button: Button<Text>? = nil,
         @ViewBuilder content: @escaping () -> Content) {
        _isShow = isShow
        self.content = content
        self.title = title
        self.message = message
        self.button = button
    }
    
    var body: some View {
        content()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                if isShow {
                    HStack(alignment: .bottom) {
                        VStack {
                            if let title {
                                Text(title)
                                    .bold()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            if let message {
                                Text(message)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundStyle(Color.secondary)
                                    .font(.callout)
                            }
                        }
                        if let button {
                            button
                                .bold()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.bottomAlertBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .padding()
                    .transition(.move(edge: .bottom))
                    .offset(y: (offset.height - 7) + dragOffset.height)
                    .onAppear(perform: processDisappearAlert)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .updating($offset, body: updateOffset)
                            .onEnded(processEndDrag)
                    )
                }
            }
    }
    
    func updateOffset(currentPosition: DragGesture.Value, state: inout CGSize, transion: inout Transaction) -> Void {
        if currentPosition.translation.height > 0 {
            state = currentPosition.translation
        }else {
            state.height = 0.16 * currentPosition.translation.height
        }
    }
    
    func processEndDrag(_ value: GestureStateGesture<DragGesture, CGSize>.Value) {
        dragOffset.height = value.translation.height
        if value.translation.height > 0 {
            withAnimation {
                isShow = false
            }
        }else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                withAnimation {
                    isShow = false
                }
            }
        }
        dragOffset = .zero
    }
    
    func processDisappearAlert() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            if offset.height == 0 {
                withAnimation {
                    isShow = false
                }
            }
        }
    }
}

extension BottomAlert {
    init(isShow: Binding<Bool>,
         alertItem: AlertItem,
         button: Button<Text>?,
         @ViewBuilder content: @escaping () -> Content) {
        _isShow = isShow
        self.content = content
        self.title = alertItem.title
        self.message = alertItem.message
        self.button = button
    }
}

extension View {
    @ViewBuilder
    func bottomAlert(isShow : Binding<Bool>,
                     title  : String? = nil,
                     message: String? = nil,
                     button : Button<Text>? = nil) -> some View {
        BottomAlert(isShow: isShow, title: title, message: message, button: button) {
            self
        }
    }
    @ViewBuilder
    func bottomAlert(isShow : Binding<Bool>,
                     alertItem: AlertItem,
                     button : Button<Text>? = nil) -> some View {
        BottomAlert(isShow: isShow, alertItem: alertItem, button: button) {
            self
        }
    }
}

#Preview {
    let button = Button("ckick") {
        print("hello world")
    }
    return Text("hello world")
        .bottomAlert(isShow: .constant(true),
                     title: "this is title",
                     message: "this is message",
                     button: button)
}

#Preview {
    ScoreCalculate(viewModel: ScoreCalculateViewModel(score: GremoViewModel()))
        .environmentObject(GremoViewModel())
}
