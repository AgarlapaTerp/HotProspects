//
//  UsersView.swift
//  HotProspects
//
//  Created by user256510 on 5/6/24.
//

import SwiftUI

struct UsersView: View {
    
    let filter: FilterType
    
    @State private var sortDescrptors: [SortDescriptor<Prospect>] = []
    var body: some View {
        NavigationStack {
            ProspectsView(filter: filter,sortDescriptors: sortDescrptors)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu("Sort", systemImage: "arrow.up.arrow.down") {
                            Picker("Sorting", selection: $sortDescrptors) {
                                Text("Sort by name")
                                    .tag([SortDescriptor(\Prospect.name)])
                                
                                Text("Sort by recent")
                                    .tag([] as [SortDescriptor<Prospect>])
                                
                            }
                            
                        }
                    }
                }
        }
    }
}

#Preview {
    UsersView(filter: .none)
}
