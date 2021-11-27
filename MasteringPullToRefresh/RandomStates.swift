//
//  RandomStates.swift
//  MasteringPullToRefresh
//
//  Created by Work on 27.11.21.
//

import SwiftUI

struct StateItem: Decodable, Identifiable {
    let id: Int
    let name: String
}

struct RandomStates: View {
    
    @State var states = ["Pull 2 get random states"]
    
    var body: some View {
        NavigationView {
            List(states, id: \.self) { state in
                Text(state)
            }
                .refreshable {
                    await fetchRandomStates()
                }
                .navigationTitle("Random US States ")
        }
    }
    
    func fetchRandomStates() async {
        let url = URL(string: "http://names.drycodes.com/10?nameOptions=states&combine=1&separator=space")!
        let request = URLRequest(url: url)
        let (data, _) = try! await URLSession.shared.data(for: request)
        let fetchedStates = try! JSONDecoder().decode([String].self, from: data)
        states = fetchedStates
    }
}

struct RandomStates_Previews: PreviewProvider {
    static var previews: some View {
        RandomStates()
    }
}
