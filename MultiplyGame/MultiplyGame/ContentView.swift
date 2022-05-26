//
//  ContentView.swift
//  MultiplyGame
//
//  Created by master on 5/19/22.
//

import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.weight(.bold))
            .foregroundColor(.black)
    }
}

struct CenterModifier: ViewModifier {
    func body(content: Content) -> some View {
        VStack(spacing: 15) {
            Spacer()
            content
            Spacer()
        }
    }
}

struct Question {
    
    var answerOne: Int
    var answerTwo: Int
    var answerThree: Int
    
    var numberOne: Int
    var numberTwo: Int
    
    var correctAnswer: Int
    
    init(answerOne: Int, answerTwo: Int, answerThree: Int, numberOne: Int, numberTwo: Int, correctAnswer: Int) {
        
        self.answerOne = answerOne
        self.answerTwo = answerTwo
        self.answerThree = answerThree
        
        self.numberOne = numberOne
        self.numberTwo = numberTwo
        
        self.correctAnswer = correctAnswer
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
    
    func centerStyle() -> some View {
        modifier(CenterModifier())
    }
    
}

struct ContentView: View {
    
    @State private var tableSelection = 2
    @State private var answer = ""
    @State private var numberOfQuestions: Int = 5
    @State private var totalQuestions: Int = 5
    @State private var currentQuestion = 0
    @State private var questions: [Question] = []
    @State private var isHidden: Bool = false
    @State private var showingScore = false
    @State private var showingReset = false
    @State private var scoreTitle = ""
    @State private var score = 0
    
    var body: some View {
        NavigationView {
            List {
                if isHidden && totalQuestions > 0 {
                    Section {
                        Text("Question No: \(currentQuestion + 1)")
                            .font(.title)
                        Text("\(questions[currentQuestion].numberOne) x \(questions[currentQuestion].numberTwo) =")
                            .titleStyle()
                        Text("Select your answer")
                            .font(.title3)
                            .foregroundColor(.gray)
                        HStack(alignment: .center, spacing: 20) {
                            Button("\(questions[currentQuestion].answerOne)") {
                                answerQuestion(for: questions[currentQuestion].answerOne)
                            }
                            .frame(maxWidth: .infinity)
                            .buttonStyle(BorderlessButtonStyle())
                            .padding()
                            .background(.blue)
                            .foregroundColor(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            Button("\(questions[currentQuestion].answerTwo)") {
                                print("Called")
                                answerQuestion(for: questions[currentQuestion].answerTwo)
                            }
                            .frame(maxWidth: .infinity)
                            .buttonStyle(BorderlessButtonStyle())
                            .padding()
                            .background(.blue)
                            .foregroundColor(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            Button("\(questions[currentQuestion].answerThree)") {
                                answerQuestion(for: questions[currentQuestion].answerThree)
                            }
                            .frame(maxWidth: .infinity)
                            .buttonStyle(BorderlessButtonStyle())
                            .padding()
                            .background(.blue)
                            .foregroundColor(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                        }.font(.title2.bold())
                        
                    }
                    .centerStyle()
                }
                
                if !showingScore {
                    Section(header: Text("Upto which number do you know the tables?")
                        .font(.headline)) {
                            Stepper( "\(tableSelection.formatted())", value: $tableSelection, in: 2...12, step: 1)
                        }
                    Section(header: Text("No. of questions?")
                        .font(.headline)) {
                            Stepper( "\(numberOfQuestions.formatted())", value: $numberOfQuestions, in: 5...15, step: 5)
                        }
                    Section {
                        Button("Start Game") {
                            restart()
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                        .font(.title2.bold())
                    }
                }
                
                if showingScore {
                    Section {
                        Text("Current Score: \(score)")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                            .font(.title2.bold())
                    }
                }
            }
            .navigationTitle("Multiply")
            .toolbar {
                Button(action: {
                    restart()
                }) {
                    Image(systemName: "arrow.triangle.2.circlepath").imageScale(.large)
                }
            }
            .alert("Game over", isPresented: $showingReset) {
                Button("Restart", action: restart)
                Button("Cancel") {
                    
                }
            } message: {
                Text("Your score is \(score)/\(numberOfQuestions)\n Please tap restart to play again")
            }
        }
    }
    
    func generateQuestions() {
        self.questions = []
        totalQuestions = numberOfQuestions
        for _ in 0..<numberOfQuestions {
            
            var ans: [Int] = []
            
            let multiply = Int.random(in: 1...12)
            let numberToMultiply = Int.random(in: 2...tableSelection)
            
            let answer = multiply * numberToMultiply
            var nums = [Int](1...100)
            if answer < 100 {
                nums.remove(at: answer)
            }
            
            let answerOne = Int(arc4random_uniform(UInt32(nums.count)))
            
            nums.remove(at: answerOne)
            
            let answerTwo = Int(arc4random_uniform(UInt32(nums.count)))
            
            ans.append(answer)
            ans.append(answerOne)
            ans.append(answerTwo)
            
            ans.shuffle()
            
            let question = Question(answerOne: ans[0], answerTwo: ans[1], answerThree: ans[2], numberOne: multiply, numberTwo: numberToMultiply, correctAnswer: answer)
            
            self.questions.append(question)
        }
        
        withAnimation {
            isHidden = true
            showingScore = true
        }
    }
    
    func answerQuestion(for answer: Int) {
        if answer == questions[currentQuestion].correctAnswer {
            score += 1
        }
        askQuestion()
    }
    
    func restart() {
        withAnimation {
            score = 0
            currentQuestion = 0
            generateQuestions()
        }
    }
    
    func askQuestion() {
        
        withAnimation {
            totalQuestions -= 1
        }
        
        currentQuestion += 1
        
        if totalQuestions == 0 {
            showingReset = true
            
            withAnimation {
                isHidden = true
                showingScore = false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension ClosedRange where Element: Hashable {
    func random(without excluded:[Element]) -> Element {
        let valid = Set(self).subtracting(Set(excluded))
        let random = Int(arc4random_uniform(UInt32(valid.count)))
        return Array(valid)[random]
    }
}
