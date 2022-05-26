//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by master on 5/3/22.
//

import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.weight(.bold))
            .foregroundStyle(.white)
            .padding()
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct FlagImage: ViewModifier {
    
    var image: String
    
    func body(content: Content) -> some View {
        Image(image)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
    
    func image(with source: String) -> some View {
        modifier(FlagImage(image: source))
    }
}

struct ContentView: View {
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var scoreDescription = ""
    @State private var attempts = 8
    @State private var showingReset = false
    @State private var tappedFlag = 0
    @State private var degree: Double = 0
    @State private var opacity: Double = 1
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    var foreverAnimation: Animation {
            Animation.linear(duration: 2.0)
                .repeatForever(autoreverses: false)
        }
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [.init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3), .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)], center: .top, startRadius: 200, endRadius: 700).ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the flag")
                    .titleStyle()
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                            .foregroundColor(.white)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            image(with: countries[number])
                        }
                        .rotation3DEffect(.degrees((tappedFlag == number) ? degree : 0), axis: (x: 0, y: 1, z: 0))
                        .animation(.easeInOut.speed(1), value: degree)
                        .rotation3DEffect(.degrees((tappedFlag != number) ? -degree : 0), axis: (x: 0, y: 1, z: 0))
                        .opacity((tappedFlag != number) ? opacity : 1)
                        .animation(.easeInOut.speed(0.5), value: degree)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }.alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(scoreDescription.isEmpty ? "Your score is \(score)" : scoreDescription)
        }.alert("Game over", isPresented: $showingReset) {
            Button("Restart", action: restart)
        } message: {
            Text("Your score is \(score)/8\n Please tap restart to play again")
        }
    }
    
    func flagTapped(_ number: Int) {
        tappedFlag = number
        
        withAnimation {
            degree += 360
            opacity = 0.25
        }
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Oops!"
            scoreDescription = "That's the flag of \(countries[number])"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            showingScore = true
        }
    }
    
    func restart() {
        askQuestion()
        attempts = 8
        score = 0
    }
    
    func askQuestion() {
        withAnimation {
            opacity = 1
            degree = 0
        }
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        scoreDescription = ""
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
