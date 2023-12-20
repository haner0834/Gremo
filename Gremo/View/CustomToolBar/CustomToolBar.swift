//
//  CustomToolBar.swift
//  Gremo
//
//  Created by Andy Lin on 2023/12/19.
//

import Foundation
import SwiftUI

struct NameItem {
    let label: String
    let systemName: String
}

struct ToolBarView: View {
    @State private var selectIndex: Int = 0
    
    var isToolbarVisible: Bool
    
    let names: [NameItem]
    
    var content: [AnyView]
    
    @State private var columns: [GridItem] = []
    
    init<Views>(isToolbarVisible: Bool = true,
                names: [NameItem],
                @ViewBuilder content: @escaping () -> TupleView<Views>) {
        self.content = content().getViews
        self.isToolbarVisible = isToolbarVisible
        self.names = names
    }
    
    var body: some View {
        if names.count == content.count && content.count > 0 {
            GeometryReader { geometry in
                VStack {
                    VStack {
                        ForEach(content.indices, id: \.self) { i in
                            if selectIndex == i {
                                content[i]
                            }
                        }
                    }
                    .frame(maxHeight: .infinity)
                    
                    if isToolbarVisible {
                        VStack {
                            Divider()
                            
                            LazyVGrid(columns: columns) {
                                ForEach(content.indices, id: \.self) { i in
                                    VStack {
                                        Image(systemName: names[i].systemName)
                                            .font(.title2)
                                            .foregroundColor(i == selectIndex ? .accentColor: .secondary)
                                        
                                        Text(names[i].label)
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                            .foregroundColor(i == selectIndex ? .accentColor: .secondary)
                                    }
                                    .frame(width: (geometry.size.width / CGFloat(content.count)) - 10,
                                           height: 45,
                                           alignment: .top)
                                    .background(Color(.contrary))
                                    .onTapGesture {
                                        selectIndex = i
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .frame(height: 41)
                        .padding(.horizontal, 3)
                        .padding(.top, -1.5)
                    }
                }
                .onAppear {
                    for _ in content.indices {
                        columns.append(GridItem(.flexible()))
                    }
                }
            }
        }else {
            Text("The number of input views cannot be less than two, and the number of input views must be the same as names")
        }
    }
}

extension TupleView {
    var getViews: [AnyView] {
        makeArray(from: value)
    }
    
    private struct GenericView {
        let body: Any
        
        var anyView: AnyView? {
            AnyView(_fromValue: body)
        }
    }
    
    private func makeArray<Tuple>(from tuple: Tuple) -> [AnyView] {
        func convert(child: Mirror.Child) -> AnyView? {
            withUnsafeBytes(of: child.value) { ptr -> AnyView? in
                let binded = ptr.bindMemory(to: GenericView.self)
                return binded.first?.anyView
            }
        }
        
        let tupleMirror = Mirror(reflecting: tuple)
        return tupleMirror.children.compactMap(convert)
    }
}

#Preview {
    let kkk: [NameItem] = [
        .init(label: "", systemName: "house.fill"),
        .init(label: "", systemName: "doc.plaintext.fill"),
        .init(label: "", systemName: "gearshape.fill")
    ]
    
    return ToolBarView(names: kkk, content: {
        ScoreCalculate(viewModel: ScoreCalculateViewModel(score: GremoViewModel()))
            .environmentObject(GremoViewModel())
        
        Text("????")
        
        Text(":D")
    })
}
