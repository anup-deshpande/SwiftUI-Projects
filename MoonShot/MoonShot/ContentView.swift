//
//  ContentView.swift
//  MoonShot
//
//  Created by Anup Deshpande on 11/7/20.
//

import SwiftUI

struct CrewListView: View{
    var mission: Mission
    var crewNames: [Astronaut]
    
    var body: some View{
        ForEach(crewNames){ crewMember in
            Text(crewMember.name)
                .font(.subheadline)
        }
    }
    
    init(mission: Mission, astronauts: [Astronaut]) {
        self.mission = mission
        
        let crew = mission.crew
        var matches = [Astronaut]()
        
        for crewNames in crew{
            if let match = astronauts.first(where: { (astronaut) -> Bool in
                return astronaut.id == crewNames.name
            }){
                matches.append(match)
            }
        }
        
        self.crewNames = matches
        
    }
}

struct ContentView: View {
    
    let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    @State private var showingLaunchDate = true
    
    var body: some View {
        NavigationView{
            List(missions){ mission in
                NavigationLink(destination: MissionView(mission: mission, astronauts: astronauts)) {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                    
                    VStack(alignment: .leading){
                        Text(mission.displayName)
                            .font(.headline)
                        
                        if showingLaunchDate{
                            Text(mission.formattedLaunchDate)
                                .font(.subheadline)
                        }else{
                            CrewListView(mission: mission, astronauts: astronauts)
                        }
                        
                    }
                }
            }
            .navigationBarItems(trailing: Button(action: toggleButtonTapped, label: {
                Text("\(showingLaunchDate == true ? "Crew Members" : "Launch Dates")")
            }))
            .navigationBarTitle("Moonshot")
        }
    }
    
    func toggleButtonTapped(){
        showingLaunchDate.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
