//
//  AstronautScrollView.swift
//  Moonshot
//
//  Created by master on 5/25/22.
//

import SwiftUI

struct AstronautScrollView: View {
    
    let crew: [MissionView.CrewMember]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(crew, id: \.role) { crewMember in
                    NavigationLink {
                        AstronautView(astronaut: crewMember.astronaut)
                    } label: {
                        HStack {
                            Image(crewMember.astronaut.id)
                                .resizable()
                                .frame(width: 120, height: 83)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .strokeBorder(.white, lineWidth: 1)
                                )
                            
                            VStack(alignment: .leading) {
                                Text(crewMember.astronaut.name)
                                    .foregroundColor(.white)
                                    .font(crewMember.role == "Commander" ? .title3.bold() : .headline)
                                
                                Text(crewMember.role)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
    
    init(crew: [MissionView.CrewMember]) {
        self.crew = crew
    }
}

struct AstronautScrollView_Previews: PreviewProvider {
    
    static var previews: some View {
        AstronautScrollView(crew: [MissionView.CrewMember]())
    }
}
