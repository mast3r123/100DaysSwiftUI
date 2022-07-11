//
//  ContentView.swift
//  HotProspects
//
//  Created by master on 7/9/22.
//

import SwiftUI



struct ContentView: View {
    
    @State private var output = ""
    
    var body: some View {
        Text(output)
            .task {
                await fetchRedings()
            }
    }
    
    func fetchRedings() async {
        let fetchTask = Task { () -> String in
            let url = URL(string: "https://hws.dev/readings.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let readings = try JSONDecoder().decode([Double].self, from: data)
            return "Found \(readings.count)"
        }
        
        let result = await fetchTask.result
        
        switch result {
        case .success(let str):
            output = str
            
        case .failure(let error):
            output = "Download error: \(error.localizedDescription)"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
