//
//  EditView.swift
//  HotProspects
//
//  Created by user256510 on 5/6/24.
//

import SwiftUI

struct EditView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Bindable var prospectToChange: Prospect
    var body: some View {
        Form {
            TextField(prospectToChange.name, text: $prospectToChange.name)
            
            TextField(prospectToChange.emailAddress, text: $prospectToChange.emailAddress)
        }
        .navigationTitle("Edit Contact")
        .toolbar {
            Button("Done"){
                dismiss()
            }
        }
    }
}

#Preview {
    EditView(prospectToChange: .example)
}
