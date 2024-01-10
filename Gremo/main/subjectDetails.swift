//
//  subjectDetails.swift
//  Gremo
//
//  Created by Andy Lin on 2023/8/15.
//

import SwiftUI
import Charts

struct subjectDetails: View {
    var returnValue: SubjectLink
    
    @State private var chartValue: [Score1] = [.init(name: "一週", count: 100, color: .accentColor),
                                               .init(name: "一段", count: 80, color: .accentColor),
                                               .init(name: "二週", count: 90, color: .accentColor),
                                               .init(name: "二段", count: 85, color: .accentColor),
                                               .init(name: "三週", count: 95, color: .accentColor),
                                               .init(name: "三段", count: 80, color: .accentColor)]
    
    @State private var subject: [SubjectLink] = [
        .init(label: "一週", key: "Chinese", scope: 1),
        .init(label: "一段", key: "Chinese", scope: 2),
        .init(label: "二週", key: "Chinese", scope: 3),
        .init(label: "二段", key: "Chinese", scope: 4),
        .init(label: "三週", key: "Chinese", scope: 5),
        .init(label: "三段", key: "Chinese", scope: 6)]
    
    private func calculate(subject: String) -> String {
        let allScore1 = UserDefaults.standard.string(forKey: "\(subject)Score1") ?? ""
        let allScore2 = UserDefaults.standard.string(forKey: "\(subject)Score2") ?? ""
        let allScore3 = UserDefaults.standard.string(forKey: "\(subject)Score3") ?? ""
        let allScore4 = UserDefaults.standard.string(forKey: "\(subject)Score4") ?? ""
        let allScore5 = UserDefaults.standard.string(forKey: "\(subject)Score5") ?? ""
        let allScore6 = UserDefaults.standard.string(forKey: "\(subject)Score6") ?? ""
        
        let jjj: [String] = [allScore1, allScore2, allScore3, allScore4, allScore5, allScore6]
        
        var average: Double = 0
        var index: Double = 0.0
        
        for i in 0..<jjj.count {
            if jjj[i] != "" || jjj[i] != "0" {
                average += Double(jjj[i]) ?? 0
                index += 1
            }
        }
        
        if index != 0 {
            average /= index
        }else {
            average = 0
        }
        
        return String(format: "%.2f", average)
    }
    
    var body: some View {
        VStack{
            
            HStack {
                Text("**\(returnValue.label)詳情**")
                    .font(.title2)

                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 5)
            
            HStack {
                Text("平均：\(String(format: "%.2f", returnValue.average))")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
            }
            .padding(.horizontal)
            
            Chart {
                RuleMark(y: .value("及格線", 60))
                    .foregroundStyle(.blue)
                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [7]))
                
                ForEach(chartValue) {
                    BarMark(
                        x: .value("", $0.name),
                        y: .value("", $0.count))
                }
            }
            .chartYScale(domain: 0...100)
            .frame(height: 160)
            .padding()
            
            List {
                
                ForEach(subject) { value in
                    
                    HStack {
                        Text(value.label)
                        
                        Spacer()
                        
                        Text(String(format: "%.2f", UserDefaults.standard.double(forKey: "\(value.key)Score\(value.scope)")))
                    }
                }
            }.listStyle(.inset)
        }
        .onAppear{
            subject = [.init(label: "一週", key: returnValue.key, scope: 1),
                       .init(label: "一段", key: returnValue.key, scope: 2),
                       .init(label: "二週", key: returnValue.key, scope: 3),
                       .init(label: "二段", key: returnValue.key, scope: 4),
                       .init(label: "三週", key: returnValue.key, scope: 5),
                       .init(label: "三段", key: returnValue.key, scope: 6)]
            
            chartValue = [.init(name: "一週", count: UserDefaults.standard.integer(forKey: "\(returnValue.key)Score1"), color: .accentColor),
                          .init(name: "一段", count: UserDefaults.standard.integer(forKey: "\(returnValue.key)Score2"), color: .accentColor),
                          .init(name: "二週", count: UserDefaults.standard.integer(forKey: "\(returnValue.key)Score3"), color: .accentColor),
                          .init(name: "二段", count: UserDefaults.standard.integer(forKey: "\(returnValue.key)Score4"), color: .accentColor),
                          .init(name: "三週", count: UserDefaults.standard.integer(forKey: "\(returnValue.key)Score5"), color: .accentColor),
                          .init(name: "三段", count: UserDefaults.standard.integer(forKey: "\(returnValue.key)Score6"), color: .accentColor)]
        }
//        .navigationTitle("**\(returnValue.name)詳情**")
    }
}

struct SubjectDetails: View {
    
    @State private var totalScoreSummary: [Count] = []
    
    let average: Double
    let subjectName: String
    let key: String
    
    var body: some View {
        VStack{
            
            HStack {
                Text("\(subjectName.isEmpty ? "總平均": subjectName)詳情")
                    .bold()
                    .font(.title2)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 5)
            
            HStack {
                Text("平均：\(String(format: "%.2f", average))")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
            }
            .padding(.horizontal)
            
            Chart {
                RuleMark(y: .value("及格線", 60))
                    .foregroundStyle(.blue)
                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [7]))
                
                ForEach(totalScoreSummary) { summary in
                    BarMark(x: .value("", summary.examName),
                            y: .value("", summary.score))
                }
            }
            .chartYScale(domain: 0...100)
            .frame(height: 160)
            .padding()
            
            List {
                
                ForEach(0..<totalScoreSummary.count, id: \.self) { i in
                    HStack {
                        Text(totalScoreSummary[i].examName)
                        
                        Spacer()
                        
                        Text(String(format: "%.2f", UserDefaults.standard.double(forKey: "\(key)Score\(i + 1)")))
                    }
                }
            }
        }.listStyle(.inset)
//    }
        .onAppear {
            var scores = [Count]()
            totalScoreSummary = []
            for i in 0..<6 {
                var examName: String {
                    let names = ["一週", "一段", "二週", "二段", "三週", "三段"]
                    return names[i]
                }
                
                let score = UserDefaults.standard.double(forKey: "\(key)Score\(i + 1)")
                
                totalScoreSummary.append(.init(examName: examName, score: score))
            }
            
        }
    }
}

struct subjectDetails_Previews: PreviewProvider {
    static var previews: some View {
        SubjectDetails(average: 0.0, subjectName: "國文", key: "Chinese")
//        Summary(viewModel: SummaryViewModel(globalViewModel: GremoModel()))
    }
}
