//
//  ContentView.swift
//  RockPaperScissor
//
//  Created by master on 5/8/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var score = 0
    @State private var attempts = 10
    @State private var showingReset = false
    @State private var win: Bool = Bool.random()
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    var moves = ["👊🏻", "✋🏻", "✌🏻"]
    
    @State private var currentMove = Int.random(in: 0...2)
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [.init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3), .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)], center: .top, startRadius: 400, endRadius: 700).ignoresSafeArea()
            VStack(alignment: .center, spacing: 20) {
                Spacer()
                Text("Select your move \nto \(win ? "Win" : "Lose")")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                Text(moves[currentMove])
                    .font(.system(size: 200))
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                HStack() {
                    VStack {
                        Button("👊🏻") {
                            tappedMove(with: 0)
                        }
                        Text("Rock")
                            .font(.subheadline.bold())
                    }
                    .padding(15)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    VStack {
                        Button("✋🏻") {
                            tappedMove(with: 1)
                        }
                        Text("Paper")
                            .font(.subheadline.bold())
                    }
                    .padding(15)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    VStack {
                        Button("✌🏻") {
                            tappedMove(with: 2)
                        }
                        Text("Scissor")
                            .font(.subheadline.bold())
                    }
                    .padding(15)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }.font(.system(size: 70))
                    .foregroundColor(.white)
                Spacer()
                Text("Current Score:  \(score)")
                    .font(.title2.weight(.semibold)).foregroundColor(.white)
                Spacer()
            }.padding()
            .alert(scoreTitle, isPresented: $showingScore) {
                Button("Continue", action: askQuestion)
            } message: {
                Text("Your score is \(score)")
            }.alert("Game over", isPresented: $showingReset) {
                Button("Restart", action: restart)
            } message: {
                Text("Your score is \(score)/10\n Please tap restart to play again")
            }
        }
    }
    
    func tappedMove(with selection: Int) {
        print(currentMove)
        switch currentMove {
        case 0:
            if win {
                if selection == 1 {
                    scoreTitle = "Correct"
                    score += 1
                } else {
                    scoreTitle = "Oops!"
                }
            } else {
                if selection != 1 {
                    scoreTitle = "Correct"
                    score += 1
                } else {
                    scoreTitle = "Oops!"
                }
            }
        case 1:
            if win {
                if selection == 2 {
                    scoreTitle = "Correct"
                    score += 1
                } else {
                    scoreTitle = "Oops!"
                }
            } else {
                if selection != 2 {
                    scoreTitle = "Correct"
                    score += 1
                } else {
                    scoreTitle = "Oops!"
                }
            }
        case 2:
            if win {
                if selection == 0 {
                    scoreTitle = "Correct"
                    score += 1
                } else {
                    scoreTitle = "Oops!"
                }
            } else {
                if selection != 0 {
                    scoreTitle = "Correct"
                    score += 1
                } else {
                    scoreTitle = "Oops!"
                }
            }
        default:
            break
        }
        showingScore = true
    }
    
    func restart() {
        askQuestion()
        attempts = 10
        score = 0
    }
    
    func askQuestion() {
        currentMove = Int.random(in: 0...2)
        win = Bool.random()
        attempts -= 1
        if attempts == 0 {
            showingReset = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
