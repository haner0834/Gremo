//
//  timer.swift
//  Gremo
//
//  Created by Andy Lin on 2023/6/27.
//

import SwiftUI

struct StopwatchView: View {
    @State private var isRunning = [false, false, false, false, false, false, false, false]
    @State private var elapsedTime: [TimeInterval] = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    @State private var timer: Timer?
    @State private var buttonTitle = ["play.fill", "play.fill", "play.fill", "play.fill", "play.fill", "play.fill", "play.fill", "play.fill"]
    @State private var clickCount = 0
    
    func formattedElapsedTime(_ Value: Int) -> String {
        let hours = Int(elapsedTime[Value] / 3600)
        let minutes = Int((elapsedTime[Value] / 60).truncatingRemainder(dividingBy: 60))
        let seconds = Int(elapsedTime[Value].truncatingRemainder(dividingBy: 60))
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func handleClick(_ Value: Int) {
        if isRunning[Value] {
            stopTimer(Value)
        } else {
            startTimer(Value)
        }
        
        isRunning[Value].toggle()
    }
    
    func startTimer(_ Value: Int) {
        buttonTitle[Value] = "pause.fill"
        for i in 0...7 {
            if isRunning[i] && i != Value{
                isRunning[i] = false
                stopTimer(i)
            }
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            elapsedTime[Value] += 1.0
            elapsedTime[8] += 1.0
        }
    }
    
    func stopTimer(_ Value: Int) {
        buttonTitle[Value] = "play.fill"
        timer?.invalidate()
        timer = nil
    }
    
    func titleText()  -> String{
        elapsedTime[8] = 0
        for i in 0...7{
            elapsedTime[8] += elapsedTime[i]
        }
        return String(elapsedTime[8])
    }
    
    var body: some View {
        VStack {
            Text(formattedElapsedTime(8))
                .font(.largeTitle)
                .padding([.bottom, .top] , 20)
            VStack {
                HStack{
                    Button(action: {
                        handleClick(0)
                    }, label: {
                        Image(systemName: buttonTitle[0])
                            .imageScale(.large)
                            .foregroundColor(Color(hue: 0.545, saturation: 0.472, brightness: 1.0))
                    })
                    .padding(.leading, 20)
                    .padding(.trailing, 10)
                    Text("國文")
                        .font(.title2)
                    Spacer()
                    Text("\(formattedElapsedTime(0))")
                        .font(.title2)
                        .padding(.trailing, 20)
                        .foregroundColor(.gray)
                }
                .padding(.top, 10)
                
                HStack{
                    Button(action: {
                        handleClick(1)
                    }, label: {
                        Image(systemName: buttonTitle[1])
                            .imageScale(.large)
                            .foregroundColor(Color(hue: 0.164, saturation: 0.431, brightness: 0.978))
                    })
                    .padding(.leading, 20)
                    .padding(.trailing, 10)
                    Text("英文")
                        .font(.title2)
                    Spacer()
                    Text("\(formattedElapsedTime(1))")
                        .font(.title2)
                        .padding(.trailing, 20)
                        .foregroundColor(.gray)
                }
                .padding(.top, 10)
                
                HStack{
                    Button(action: {
                        handleClick(2)
                    }, label: {
                        Image(systemName: buttonTitle[2])
                            .imageScale(.large)
                            .foregroundColor(Color(hue: 0.294, saturation: 0.59, brightness: 0.982))
                    })
                    .padding(.leading, 20)
                    .padding(.trailing, 10)
                    Text("數學")
                        .font(.title2)
                    Spacer()
                    Text("\(formattedElapsedTime(2))")
                        .font(.title2)
                        .padding(.trailing, 20)
                        .foregroundColor(.gray)
                }
                .padding(.top, 10)
                
                HStack{
                    Button(action: {
                        handleClick(3)
                    }, label: {
                        Image(systemName: buttonTitle[3])
                            .imageScale(.large)
                            .foregroundColor(Color(hue: 0.704, saturation: 0.59, brightness: 0.982))
                    })
                    .padding(.leading, 20)
                    .padding(.trailing, 10)
                    Text("理化")
                        .font(.title2)
                    Spacer()
                    Text("\(formattedElapsedTime(3))")
                        .font(.title2)
                        .padding(.trailing, 20)
                        .foregroundColor(.gray)
                }
                .padding(.top, 10)
                
                HStack{
                    Button(action: {
                        handleClick(4)
                    }, label: {
                        Image(systemName: buttonTitle[4])
                            .imageScale(.large)
                            .foregroundColor(Color(hue: 0.929, saturation: 0.59, brightness: 0.982))
                    })
                    .padding(.leading, 20)
                    .padding(.trailing, 10)
                    Text("歷史")
                        .font(.title2)
                    Spacer()
                    Text("\(formattedElapsedTime(4))")
                        .font(.title2)
                        .padding(.trailing, 20)
                        .foregroundColor(.gray)
                }
                .padding(.top, 10)
                
                HStack{
                    Button(action: {
                        handleClick(5)
                    }, label: {
                        Image(systemName: buttonTitle[5])
                            .imageScale(.large)
                            .foregroundColor(Color(hue: 0.114, saturation: 0.59, brightness: 0.982))
                    })
                    .padding(.leading, 20)
                    .padding(.trailing, 10)
                    Text("公民")
                        .font(.title2)
                    Spacer()
                    Text("\(formattedElapsedTime(5))")
                        .font(.title2)
                        .padding(.trailing, 20)
                        .foregroundColor(.gray)
                }
                .padding(.top, 10)
                
                HStack{
                    Button(action: {
                        handleClick(6)
                    }, label: {
                        Image(systemName: buttonTitle[6])
                            .imageScale(.large)
                            .foregroundColor(Color(hue: 0.6, saturation: 0.59, brightness: 0.982))
                        //Color(hue: 0.455, saturation: 0.59, brightness: 0.982)
                    })
                    .padding(.leading, 20)
                    .padding(.trailing, 10)
                    Text("地理")
                        .font(.title2)
                    Spacer()
                    Text("\(formattedElapsedTime(6))")
                        .font(.title2)
                        .padding(.trailing, 20)
                        .foregroundColor(.gray)
                }
                .padding(.top, 10)
                
                HStack{
                    Button(action: {
                        handleClick(7)
                    }, label: {
                        Image(systemName: buttonTitle[7])
                            .imageScale(.large)
                    })
                    .padding(.leading, 20)
                    .padding(.trailing, 10)
                    Text("英聽")
                        .font(.title2)
                    Spacer()
                    Text("\(formattedElapsedTime(7))")
                        .font(.title2)
                        .padding(.trailing, 20)
                        .foregroundColor(.gray)
                }
                .padding(.top, 10)
            }
            Spacer()
        }
        .accentColor(.purple)
    }
}

struct ㄒㄒ: View {
    var body: some View {
        VStack {
            LinearGradient(colors: [.blue, Color("Pink")],
                           startPoint: .leading,
                           endPoint: .trailing)
            .frame(width: 110)
            .mask {
                Text("Me :D")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
        }
    }
}

struct timer_Previews: PreviewProvider {
    static var previews: some View {
        ㄒㄒ()
        
        StopwatchView()
        Home(viewModel: GremoViewModel())
    }
}
