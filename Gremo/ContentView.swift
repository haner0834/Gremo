//
//  ScoreCalculate.swift
//  Gremo
//
//  Created by Andy Lin on 2023/6/19.
//
//選取範圍變註解：command + /
//上一步：command + z

//change scope icon name: repeat

import SwiftUI
import CoreData
import Foundation

let subjectVisible = ["Chinese", "English", "Math", "Science", "History", "Civics", "Geography", "Social", "Listening", "Composition"]
//理化：science, 生物： biology , 化學： chemistry, 物理： physic, 地科：geology , 自然：allScience

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @AppStorage("ChineseWeightedScore") private var chineseWeighted = 5
    @AppStorage("EnglishWeightedScore") private var englishWeighted = 3
    @AppStorage("MathWeightedScore") private var mathWeight = 4
    @AppStorage("ScienceWeightedScore") private var scienceWeight = 3
    @AppStorage("HistoryWeightedScore") private var historyWeight = 1
    @AppStorage("CivicsWeightedScore") private var civicsWeight = 1
    @AppStorage("GeographyWeightedScore") private var geographyWeight = 1
    @AppStorage("SocialWeightedScore") private var socialWeighted = 2
    @AppStorage("ListeningWeightedScore") private var listeningWeight = 1
    @AppStorage("CompositionWeightedScore") private var compositionWeight = 1
    @State private var heightValue = UserDefaults.standard.double(forKey: userdefaultsKey.highScore.rawValue)
    @State private var lowValue = UserDefaults.standard.double(forKey: userdefaultsKey.lowScore.rawValue)
    @State private var heightColor = UserDefaults.standard.string(forKey: userdefaultsKey.highColor.rawValue) ?? "green"
    @State private var lowColor = UserDefaults.standard.string(forKey: userdefaultsKey.lowColor.rawValue) ?? "red"
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var isLight: Bool {
        colorScheme == .light
    }

    @State private var showWarning = false
    @AppStorage("scope") private var scope = 1
    @State private var transparency:[Double] = [1, 1, 1, 1, 1, 1]

    @FocusState private var focus: Focused?
    
    @State private var chineseScore = ""
    @State private var englishScore = ""
    @State private var mathScore = ""
    @State private var scienceScore = ""
    @State private var historyScore = ""
    @State private var civicsScore = ""
    @State private var geographyScore = ""
    @State private var socialScore = ""
    @State private var listeningScore = ""
    @State private var compositionScore = ""
    @State private var AllScore = 0
    @State private var allScore = 0
    @State private var weightedScore = 20
    @State private var subject: [String] = ["0"]
    @State private var weighted = [5, 3, 4, 3, 1, 1, 1, 2, 1, 1]
    @State private var averageScore: Double = 0
    @State private var liberalArts: Double = 0
    @State private var science: Double = 0
    @State private var social: Double = 0
    @State private var textFieldValue: [TextFieldValue] = []
    
    
    //MARK: - 我是分隔線:D
//    @FocusState private var focused: Subject?
    
//    @StateObject private var viewModel = ScoreCalculateViewModel()
    
    let userDefault = UserDefaults.standard
    
    private func calculate(S: [String],W: [Int], plusIndex: Int) {
        var plI = 0
        var weighted: [Int] = []
        subject = S
        weightedScore = 0
        AllScore = 0
        
        if UserDefaults.standard.bool(forKey: "isWeightedOn") {
            weighted = W
        }else {
            for _ in 0..<W.count {
                weighted.append(1)
            }
        }
        
        for i in 0..<weighted.count {
            weightedScore += weighted[i]
        }
        
        for index in 0..<S.count {
            if plusIndex == 10 {
                if index < 2 {
                    plI = 0
                }else {
                    plI = 6
                }
            }else {
                plI = plusIndex
            }
            
            if subject[index].isEmpty || !UserDefaults.standard.bool(forKey: "is\(subjectVisible[index + plI])On") {
                weightedScore -= weighted[index]
                subject[index] = "0"
            }
        }
        
        if weightedScore > 0 {
            for index in 0..<subject.count {
                AllScore += Int(subject[index])! * weighted[index]
            }
        }
    }
    
    func getValue() {
        allScore = 0
        social = 0
        science = 0
        liberalArts = 0
        calculate(S: [chineseScore,
                      englishScore,
                      mathScore,
                      scienceScore,
                      historyScore,
                      civicsScore,
                      geographyScore,
                      socialScore,
                      listeningScore,
                      compositionScore],
                  W: [chineseWeighted,
                      englishWeighted,
                      mathWeight,
                      scienceWeight,
                      historyWeight,
                      civicsWeight,
                      geographyWeight,
                      socialWeighted,
                      listeningWeight,
                      compositionWeight],
                  plusIndex: 0)
        
        allScore = AllScore
        
        if AllScore == 0 {
            averageScore = 0
        }else {
            averageScore = Double(AllScore) / Double(weightedScore)
        }
        
        calculate(S: [chineseScore, englishScore, listeningScore, compositionScore],
                  W: [chineseWeighted, englishWeighted, listeningWeight, compositionWeight],
                  plusIndex: 10)
        if AllScore == 0 {
            liberalArts = 0
        }else {
            liberalArts = Double(AllScore) / Double(weightedScore)
        }
        
        calculate(S: [mathScore, scienceScore],
                  W: [mathWeight, scienceWeight], plusIndex: 2)
        if AllScore == 0{
            science = 0
        }else {
            science = Double(AllScore) / Double(weightedScore)
        }
        
        if !UserDefaults.standard.bool(forKey: "isSocialOn") {
            calculate(S: [historyScore, civicsScore, geographyScore],
                      W: [historyWeight, civicsWeight, geographyWeight],plusIndex: 4)
            if AllScore == 0{
                social = 0
            }else {
                social = Double(AllScore) / Double(weightedScore)
            }
        }else {
            calculate(S: [socialScore], W: [socialWeighted], plusIndex: 7)
            social = Double(socialScore) ?? 0
        }
    }
    
    //MARK: - build initial value
    func buildInitialValue() {
        for i in 0..<subjectVisible.count {
            if UserDefaults.standard.object(forKey: "\(subjectVisible[i])WeightedScore") == nil {
                UserDefaults.standard.set(weighted[i], forKey: "\(subjectVisible[i])WeightedScore")
            }
        }
        
        for i in 0..<subjectVisible.count {
            if UserDefaults.standard.object(forKey: "is\(subjectVisible[i])On") == nil {
                if subjectVisible[i] != "Social"{
                    UserDefaults.standard.set(true, forKey: "is\(subjectVisible[i])On")
                }else {
                    UserDefaults.standard.set(false, forKey: "is\(subjectVisible[i])On")
                }
            }
        }
        
        if UserDefaults.standard.object(forKey: "isWeightedOn") == nil {
            UserDefaults.standard.set(true, forKey: "isWeightedOn")
        }
        
        if UserDefaults.standard.object(forKey: userdefaultsKey.highScore.rawValue) == nil {
            UserDefaults.standard.set(80, forKey: userdefaultsKey.highScore.rawValue)
        }
        
        if UserDefaults.standard.object(forKey: userdefaultsKey.lowScore.rawValue) == nil {
            UserDefaults.standard.set(60, forKey: userdefaultsKey.lowScore.rawValue)
        }
        
        if UserDefaults.standard.object(forKey: userdefaultsKey.isScoreInColor.rawValue) == nil {
            UserDefaults.standard.set(true, forKey: userdefaultsKey.isScoreInColor.rawValue)
        }
    }
    
    //MARK: - colour(high: Bool) -> Color
    func colour(high: Bool) -> Color {
        if high {
            switch heightColor {
            case "green":
                return Color(hue: 0.319, saturation: 0.39, brightness: 0.924)
            case "blue":
                return .blue
            case "purple":
                return .accentColor
            default:
                return .black
            }
        }else {
            switch lowColor {
            case "red":
                return Color(hue: 0.0, saturation: 0.597, brightness: 0.994)
            case "orange":
                return .orange
            case "yellow":
                return .yellow
            default:
                return .black
            }
        }
    }
    
    //MARK: - ave(_ G: Double)
    func ave(_ G: Double) -> Color {
        if UserDefaults.standard.bool(forKey: userdefaultsKey.isScoreInColor.rawValue) {
            if G == 0 {
                return isLight ? .black: .white
                
            }else if G >= heightValue {
                return colour(high: true)
                
            }else if G < lowValue {
                return colour(high: false)
                
            }else {
                return Color.teal
            }
        }else {
            return isLight ? .black: .white
        }
    }
    
    //MARK: - score text field
    private func scoreEnter(subject: String, bindingValue: Binding<String>, equals: Focused, value: State<String>, key: String) -> some View {
        LabeledContent(subject) {
            TextField("\(subject)分數", text: bindingValue)
                .padding(.leading, 20)
                .keyboardType(.numberPad)
                .focused($focus, equals: equals)
                .onChange(of: focus) { newValue in
                    if newValue != equals{
                        //判斷目前取得/失去焦點的文字輸入盒是否為自己
                        if Int(value.wrappedValue) ?? 0 > 100 {
                            //判斷數字是否大於100
                            value.wrappedValue = "100"
                        }
                        
                        getValue()
                    }
                    UserDefaults.standard.set(value.wrappedValue, forKey: "\(key)Score\(scope)")
                    UserDefaults.standard.set(allScore, forKey: "AllScore\(scope)")
                    UserDefaults.standard.set(averageScore, forKey: "AverageScore\(scope)")
                    UserDefaults.standard.set(liberalArts, forKey: "LiberalArts\(scope)")
                    UserDefaults.standard.set(science, forKey: "Science\(scope)")
                    UserDefaults.standard.set(social, forKey: "Social\(scope)")
                }
        }
    }
    
    //MARK: - scope button
    private func scopeButton(value: Int) -> some View {
        var jjj = ""
        var list:[Double] = []
        
        switch value {
        case 1:
            jjj = "一週"
        case 2:
            jjj = "一段"
        case 3:
            jjj = "二週"
        case 4:
            jjj = "二段"
        case 5:
            jjj = "三週"
        case 6:
            jjj = "三段"
        default:
            jjj = ""
        }
        
        for i in 0...5 {
            if value != i + 1 {
                list.append(0.5)
            }else {
                list.append(1)
            }
        }
        
//        changeScope()
        
        return Button(jjj) {
            focus = nil
            scope = value
            transparency = list
            readScore()
            getValue()
        }
        .foregroundColor(isLight ? .white: .black)
        .padding(8)
        .background(.tint)
        .opacity(transparency[value - 1])
        .cornerRadius(12)
        .padding(.horizontal, 1)
    }
    
    //MARK: - readScore
    private func readScore() {
        chineseScore = UserDefaults.standard.string(forKey: "ChineseScore\(scope)") ?? ""
        englishScore = UserDefaults.standard.string(forKey: "EnglishScore\(scope)") ?? ""
        mathScore = UserDefaults.standard.string(forKey: "MathScore\(scope)") ?? ""
        scienceScore = UserDefaults.standard.string(forKey: "ScienceScore\(scope)") ?? ""
        historyScore = UserDefaults.standard.string(forKey: "HistoryScore\(scope)") ?? ""
        civicsScore = UserDefaults.standard.string(forKey: "CivicsScore\(scope)") ?? ""
        geographyScore = UserDefaults.standard.string(forKey: "GeographyScore\(scope)") ?? ""
        socialScore = UserDefaults.standard.string(forKey: "SocialScore\(scope)") ?? ""
        listeningScore = UserDefaults.standard.string(forKey: "ListeningScore\(scope)") ?? ""
        compositionScore = UserDefaults.standard.string(forKey: "CompositionScore\(scope)") ?? ""
    }
    
    private func changeScope() {
        transparency = []
        
        for i in 0...5 {
            if scope != i + 1 {
                transparency.append(0.5)
            }else {
                transparency.append(1)
            }
        }
    }
    
    func processDelete() {
        chineseScore = ""
        englishScore = ""
        mathScore = ""
        scienceScore = ""
        historyScore = ""
        civicsScore = ""
        geographyScore = ""
        socialScore = ""
        listeningScore = ""
        compositionScore =  ""
        
        for i in 0..<subjectVisible.count {
            UserDefaults.standard.set("", forKey: "\(subjectVisible[i])Score\(scope)")
        }
        UserDefaults.standard.set("", forKey: "AllScore\(scope)")
        UserDefaults.standard.set("", forKey: "AverageScore\(scope)")
        UserDefaults.standard.set("", forKey: "SocialScore\(scope)")
        UserDefaults.standard.set("", forKey: "ScienceScore\(scope)")
        UserDefaults.standard.set("", forKey: "LiberalArts\(scope)")
        
        getValue()
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
//                VStack{
                //VStack(alignment: .leading){
                HStack{
                    Text("Gremo")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    //                            .foregroundColor(.accentColor)
                        .foregroundColor(.accentColor)
                        .padding(.leading, 30)
                    
                    Spacer()
                    
                    NavigationLink(destination: Details(viewModel: DetailsViewModel(globalViewModel: GremoViewModel()) )) {
                        Image(systemName: "chart.bar.fill")
                            .font(.title2)
                            .padding(7)
                            .padding(.vertical, 4)
                            .background(isLight ? Color(red: 0.913, green: 0.849, blue: 1.0):
                                            Color(red: 0.362, green: 0.25, blue: 0.501))
                            .cornerRadius(25)
                    }
                    .padding(.trailing, 20)
                }
                    
                HStack{
                    ForEach([1, 2, 3, 4, 5, 6], id: \.self) { scope in
                        scopeButton(value: scope)
                    }
                }
                
                Form{
                    ForEach(textFieldValue) { value in
                        HStack {
                            scoreEnter(subject: value.name,
                                       bindingValue: value.binding,
                                       equals: value.focus,
                                       value: value.value,
                                       key: value.key)
                            
//                            Text("×\(value)")
//                                .foregroundColor(.gray)
//                                .font(.footnote)

                        }

//                        ScoreEditor(score: value.binding,
//                                    name: value.name,
//                                    key: value.key,
//                                    weighted: 5)
                    }
                    
//                    ForEach(0..<viewModel.subjectScoreItem.count, id: \.self) { i in
//                        let userDefault = UserDefaults.standard
//                        if userDefault.bool(forKey: "is\(viewModel.subjectScoreItem[i].key)On") {
//                            ScoreEditor(score: $viewModel.subjectScoreItem[i].score,
//                                        name: viewModel.subjectScoreItem[i].name,
//                                        key: viewModel.subjectScoreItem[i].key,
//                                        weighted: viewModel.subjectScoreItem[i].weighted)
//                            .focused($focused, equals: viewModel.subjectScoreItem[i].subject)
//                            .onChange(of: focused) { newValue in
//                                if newValue != viewModel.subjectScoreItem[i].subject {
//                                    //判斷目前取得/失去焦點的文字輸入盒是否為自己
//                                    if let score = Int(viewModel.subjectScoreItem[i].score), score > 100 {
//                                        viewModel.subjectScoreItem[i].score = "100"
//                                    }
//                                }
//
//
//                                userDefault.set(viewModel.subjectScoreItem[i].score, forKey: "\(viewModel.subjectScoreItem[i].key)Score\(scope)")
//                                userDefault.set(allScore, forKey: "AllScore\(scope)")
//                                userDefault.set(averageScore, forKey: "AverageScore\(scope)")
//                                userDefault.set(liberalArts, forKey: "LiberalArts\(scope)")
//                                userDefault.set(science, forKey: "Science\(scope)")
//                                userDefault.set(social, forKey: "Social\(scope)")
//                            }
//                        }
//                    }
                }
//                .multilineTextAlignment(.trailing)
//                .onChange(of: focus) { newValue in
//                    if newValue == nil {
//                        getValue()
//                    }
//                }
                .frame(height: Double(textFieldValue.count * 45) + 50.0)
//                .frame(height: Double(viewModel.subjectScoreItem.filter { UserDefaults.standard.bool(forKey: "is\($0.key)On") }.count * 45) + 50.0)
                .padding(.bottom, 16)
                    
                VStack(alignment: .leading){
                    HStack{
//                        Text("總        分：\(String(allScore))")
                        Text("總        分：\(allScore)")
                            .padding(.leading, 13)
                            .padding(.top, 2)
                            .font(.title2)
                        
                        Spacer()
                        
                        Button(action: {
                            showWarning = true
                            
                        }, label: {
//                            Image(systemName: "wrongwaysign")
//                              .imageScale(.large)
                            Text("刪除全部")
                        })
                        .foregroundColor(.red)
                        .padding(.trailing, 20)
                        .confirmationDialog("此動作將無法復原，確定繼續嗎？",
                                            isPresented: $showWarning,
                                            titleVisibility: .visible) {
                            Button("確定", role: .destructive) {
                                processDelete()
                            }
                            
                            Button("取消", role: .cancel) {
                                showWarning = false
                            }
                        } message: {
                            Text("將刪除此範圍所有的成績，包括已儲存的成績")
                        }
                    }
                    Text("平  均  分：\(String(format: "%.2f", averageScore))")
                        .padding(.leading, 10)
                        .padding(2)
                        .font(.title2)
                        .foregroundColor(ave(averageScore))
                    
                    HStack{
                        Circle()
                            .padding(.leading, 10)
                            .frame(width: 25)
                            .foregroundColor(chartColor(.lightBlue))
                        Text("文科平均：\(String(format: "%.2f", liberalArts))")
                            .padding(.leading, 10)
                            .padding(2)
                            .font(.title2)
                            .padding(.top, 2)
                            .foregroundColor(ave(liberalArts))
                    }
                    
                    HStack{
                        Circle()
                            .padding(.leading, 10)
                            .frame(width: 25)
                            .foregroundColor(chartColor(.purpleBlue))
                        Text("數理平均：\(String(format: "%.2f", science))")
                            .padding(.leading, 10)
                            .padding(2)
                            .font(.title2)
                            .padding(.top, 2)
                            .foregroundColor(ave(science))
                    }
                    
                    HStack{
                        Circle()
                            .padding(.leading, 10)
                            .frame(width: 25)
                            .foregroundColor(chartColor(.purple))
                        Text("社會平均：\(String(format: "%.2f", social))")
                            .padding(.leading, 10)
                            .padding(2)
                            .font(.title2)
                            .padding(.top, 2)
                            .foregroundColor(ave(social))
                    }
                }
//                }
            }
            .onTapGesture {
                //被點擊（此視圖）時執行下列程式碼
                focus = nil
                //focus的類型是 @FocusState，且綁定Focus字典的類型，不能用true, false來定義，要用一個值或沒有值（nil）來分配
            }
            
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onEnded({ value in
                    if value.translation.width > 0 {
                        //right
                        if scope > 1 {
                            scope -= 1
                            
                            changeScope()
                            
                            readScore()
                            
                            getValue()
                            
                            focus = nil
                        }
                    }else if value.translation.width < 0 {
                        //left
                        if scope < 6 {
                            scope += 1
                            
                            changeScope()
                            
                            readScore()
                            
                            getValue()
                            
                            focus = nil
                        }
                    }
                }))
            //要把onEnded包在gesture裡面，所以最後一個括號是要包著onEnded
        }
        .onAppear {
//            scope = UserDefaults.standard.integer(forKey: "scope")
            
            changeScope()

            readScore()

            buildInitialValue()

            let standard: [TextFieldValue] = [
                .init(focus: .chinese, name: "國文",
                      value: _chineseScore,
                      binding: $chineseScore,
                      key: "Chinese"),
                .init(focus: .english,
                      name: "英文",
                      value: _englishScore,
                      binding: $englishScore,
                      key: "English"),
                .init(focus: .math,
                      name: "數學",
                      value: _mathScore,
                      binding: $mathScore,
                      key: "Math"),
                .init(focus: .science,
                      name: "理化",
                      value: _scienceScore,
                      binding: $scienceScore,
                      key: "Science"),
                .init(focus: .history,
                      name: "歷史",
                      value: _historyScore,
                      binding: $historyScore, key: "History"),
                .init(focus: .civics,
                      name: "公民",
                      value: _civicsScore,
                      binding: $civicsScore,
                      key: "Civics"),
                .init(focus: .geography,
                      name: "地理",
                      value: _geographyScore,
                      binding: $geographyScore,
                      key: "Geography"),
                .init(focus: .social,
                      name: "社會",
                      value: _socialScore,
                      binding: $socialScore,
                      key: "Social"),
                .init(focus: .listening,
                      name: "英聽",
                      value: _listeningScore,
                      binding: $listeningScore,
                      key: "Listening"),
                .init(focus: .composition,
                      name: "作文",
                      value: _compositionScore,
                      binding: $compositionScore,
                      key: "Composition")]

            textFieldValue = []
            for i in 0..<subjectVisible.count {
                let userdefault = UserDefaults.standard
                if userdefault.bool(forKey: "is\(subjectVisible[i])On") {
                    textFieldValue.append(standard[i])
                }
            }

            heightValue = UserDefaults.standard.double(forKey: userdefaultsKey.highScore.rawValue)
            lowValue = UserDefaults.standard.double(forKey: userdefaultsKey.lowScore.rawValue)
            heightColor = UserDefaults.standard.string(forKey: userdefaultsKey.highColor.rawValue) ?? "green"
            lowColor = UserDefaults.standard.string(forKey: userdefaultsKey.lowColor.rawValue) ?? "red"
            getValue()
            focus = nil
            
            //取得儲存的加權分設定
//            for i in 0..<viewModel.subjectScoreItem.count {
//                let weighted = userDefault.double(forKey: "\(viewModel.subjectScoreItem[i].key)WeightedScore")
//                //獲取資訊
//                viewModel.subjectScoreItem[i].weighted = weighted
//            }
//
//            //取得儲存的分數
//            for i in 0..<viewModel.subjectScoreItem.count {
//                //要和外部的subjectScoreItem溝通，需要用到i來追蹤循環次數並傳回應改變項
//                if let score = userDefault.string(forKey: "\(viewModel.subjectScoreItem[i].key)Score\(scope)") {
//                    //排除nil的可能
//                    viewModel.subjectScoreItem[i].score = score
//                }
//            }
        }
    }
    
    //MARK: - new logic
    func isOnForm(subject: String) -> Bool {
        let userDefault = UserDefaults.standard
        return userDefault.bool(forKey: "is\(subject)On")
    }
}

struct page: View {
    @State private var showPage = false
    var body: some View {
        VStack {
            Text("kkk")
            
            if showPage {
                Text("jjjjj")
                    .transition(.move(edge: .leading))
            }else {
//                scoreRatio(returnValue1: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
                Text("skskkkkkkskksks")
                    .transition(.move(edge: .trailing))
            }
        }
        .gesture(DragGesture(minimumDistance: 20)
            .onEnded({ value in
                if value.translation.width > 0 {
                    withAnimation {
                        showPage = true
                    }
                }else {
                    withAnimation {
                        showPage = false
                    }
                }
            })
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//        
//        Details()
//        
//        scoreRatio(returnValue1: [100,90,80,70,60,50,40,30,20,10,1000])
//        
//        Home()
//    }
//}

#Preview("ContentView", body: {
    ContentView()
})
