//
//  JsonListView.swift
//  Masuda
//
//  Created by Stephen Kim on 10/2/25.
//

import SwiftUI

struct JsonListView: View {
    @State private var files: [String] = []
    @State private var selectedFile: String? = nil
    @State private var isPresentingNewFileSheet = false
    @State private var newFilename = ""
    @State private var alertMessage: String?
    private let dataManager = DataManager()
    
    private func createFile(named name: String) {
        guard !name.isEmpty else {
            alertMessage = "Filename cannot be empty."
            return
        }
        
        do {
            try dataManager.createNewFile(named: name)
            files = dataManager.listJSONFiles()
            selectedFile = name.hasSuffix(".json") ? name : "\(name).json"
        } catch {
            alertMessage = error.localizedDescription
        }
    }

    var body: some View {
        NavigationSplitView {
            // Sidebar / master list
            List(files, id: \.self, selection: $selectedFile) { file in
                NavigationLink(value: file) {
                    Text(file)
                }
            }
            .navigationTitle("Files")
            .refreshable {
                files = dataManager.listJSONFiles()
            }
            .onAppear {
                files = dataManager.listJSONFiles()
            }
            .toolbar {
                ToolbarItemGroup(placement: .automatic) {
                    Button {
                        newFilename = ""
                        isPresentingNewFileSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            // Prompt for filename
            .alert("New File", isPresented: $isPresentingNewFileSheet) {
                TextField("Enter filename", text: $newFilename)
                Button("Create") {
                    createFile(named: newFilename)
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Enter a name for your new JSON file.")
            }
            // Error alert
            .alert("Error", isPresented: .constant(alertMessage != nil), actions: {
                Button("OK") { alertMessage = nil }
            }, message: {
                if let message = alertMessage {
                    Text(message)
                }
            })
        } detail: {
            if let file = selectedFile {
                ContentView(file)
            } else {
                Text("Select a file")
                    .foregroundColor(.secondary)
            }
        }
    }
}

// Example preview
struct FileListView_Previews: PreviewProvider {
    static var previews: some View {
        JsonListView()
    }
}
