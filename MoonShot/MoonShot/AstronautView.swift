//
//  AstronautView.swift
//  MoonShot
//
//  Created by Anup Deshpande on 11/7/20.
//

import SwiftUI

struct AstronautView: View {
    
    let astronaut: Astronaut
    let missions: [Mission]
    
    var body: some View {
        GeometryReader{ geometry in
            ScrollView(.vertical){
                VStack{
                    Image(self.astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)
                    
                    Text(self.astronaut.description)
                        .padding()
                        .layoutPriority(1)
                    
                    ForEach(missions){ mission in
                        HStack{
                            Image(mission.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 44, height: 44)
                            
                            VStack(alignment: .leading){
                                Text(mission.displayName)
                                    .font(.headline)
                                
                                Text(mission.formattedLaunchDate)
                                    .font(.caption)
                            }
                            
                            Spacer()
                        }
                        .padding()
                    }
                }
            }
        }
        .navigationBarTitle(Text(astronaut.name), displayMode: .inline)
    }
    
    init(astronaut: Astronaut){
        self.astronaut = astronaut
        
        let missions: [Mission] = Bundle.main.decode("missions.json")
        let filteredMissions = missions.filter { (mission) -> Bool in
            for crewMember in mission.crew{
                if crewMember.name == astronaut.id{
                    return true
                }
            }
            
            return false
        }
        
        self.missions = filteredMissions
    }
}

struct AstronautView_Previews: PreviewProvider {
    
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
        
    static var previews: some View {
        AstronautView(astronaut: astronauts[0])
    }
}
