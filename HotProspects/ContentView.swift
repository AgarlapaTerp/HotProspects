//
//  ContentView.swift
//  HotProspects
//
//  Created by user256510 on 5/2/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            UsersView(filter:.none)
                .tabItem {
                    Label("Everyone", systemImage: "person.3")
                }
            UsersView(filter:.contacted)
                .tabItem {
                    Label("Contacted", systemImage: "checkmark.circle")
                }
            UsersView(filter: .uncontacted)
                .tabItem {
                    Label("Uncontacted", systemImage: "questionmark.diamond")
                }
            
            MeView()
                .tabItem {
                    Label("Me", systemImage: "person.crop.square")
                }
        }
    }
    
}

#Preview {
    ContentView()
}
