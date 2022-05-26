//
//  ContentView.swift
//  Moonshot
//
//  Created by master on 5/22/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isGrid = false
    
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    var body: some View {
        NavigationView {
            Group {
                if !isGrid {
                    withAnimation {
                        MissionGridView(missions: missions, astronauts: astronauts)
                    }
                    
                } else {
                    withAnimation {
                        MissionListView(missions: missions, astronauts: astronauts)
                    }
                    
                }
            }
            .navigationTitle("Moonshot")
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(role: .none) {
                        withAnimation {
                            isGrid.toggle()
                        }
                    } label: {
                        Image(systemName: isGrid ? "square.grid.2x2" : "rectangle.grid.1x2")
                    }
                    .buttonStyle(.plain)
                }
            }
            .background(.darkBackground)
            .preferredColorScheme(.dark)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
