//
//  AddCounterSheet.swift
//  Masuda
//
//  Created by Stephen Kim on 9/25/25.
//

import SwiftUI

struct AddCounterSheet: View {
    @Binding var isPresented: Bool
    @Binding var name: String
    var onAdd: (String) -> Void

    var body: some View {
        NavigationView {
            VStack {
                TextField("Counter name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Spacer()
            }
            .navigationTitle("New Counter")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                        name = ""
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        onAdd(name)
                        name = ""
                        isPresented = false
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
