//
//  ContentView.swift
//  Masuda
//
//  Created by Stephen Kim on 9/22/25.
//

import SwiftUI

struct ContentView: View {
    let filename: String
    @StateObject var viewModel: CounterViewModel
    @State private var isSharing = false
    @State private var isImporting = false
    @State private var isPresentingAddSheet = false
    @State private var newCounterName = ""
    @State private var availableJSONFiles: [String] = []

    init(_ filename: String) {
        self.filename = filename
        _viewModel = StateObject(
            wrappedValue: CounterViewModel(filename: filename)
        )
    }

    func getCountersFileURL(for filename: String) -> URL? {
        let directory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
        let fileURL = directory.appendingPathComponent(filename)
        return FileManager.default.fileExists(atPath: fileURL.path)
            ? fileURL : nil
    }

    func importCounters(from url: URL) {
        do {
            let data = try Data(contentsOf: url)
            let decodedCounters = try JSONDecoder().decode(
                [Counter].self,
                from: data
            )
            viewModel.counters = decodedCounters
            viewModel.saveData()  // make sure your VM exposes this method or make it public
        } catch {
            print("Failed to import counters: \(error.localizedDescription)")
            // Optionally show an alert to user here
        }
    }

    private func refreshFileList() {
        // call the DataManager helper
        print("anything")
        availableJSONFiles = DataManager.shared.listJSONFiles()
    }

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.counters) { counter in
                    CounterRowView(
                        counter: counter,
                        onIncrement: {
                            viewModel.incrementCounter(counter)
                        },
                        percentage: viewModel.percentage(for: counter)
                    )
                }
                .onDelete(perform: deleteCounters)
            }

            Text("Total: \(viewModel.totalCount)")
                .font(.headline)
                .padding(.top)

            Button(action: {
                isPresentingAddSheet = true
            }) {
                Text("Add Counter")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .onAppear {
            refreshFileList()
            print(
                "ContentView appeared. ViewModel filename = \(viewModel.filename)"
            )
            print("Available JSON files: \(availableJSONFiles)")
        }
        .navigationTitle("Masuda")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                #if os(macOS)
                    Button {
                        if let fileURL = getCountersFileURL(
                            for: "counters.json"
                        ) {
                            FileExporter.exportCountersFile(from: fileURL)
                        }
                    } label: {
                        Image(systemName: "square.and.arrow.up.doc")
                    }
                #endif
                #if os(macOS)
                    Button {
                        FileImporter.importCounters { importedCounters in
                            viewModel.counters = importedCounters
                            viewModel.saveData()
                        }
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                    }
                #endif
                Button {
                    isSharing = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }

                Button {
                    isImporting = true
                } label: {
                    Image(systemName: "square.and.arrow.down")
                }
            }
        }
        .sheet(isPresented: $isPresentingAddSheet) {
            AddCounterSheet(
                isPresented: $isPresentingAddSheet,
                name: $newCounterName
            ) { name in viewModel.addCounter(named: name)
            }
        }
        #if canImport(UIKit)
            .sheet(isPresented: $isSharing) {
                if let fileURL = getCountersFileURL(for: "counters.json") {
                    ShareSheet(activityItems: [fileURL])
                } else {
                    Text("File not found")
                }
            }
        #endif
        #if canImport(UIKit)
            .sheet(isPresented: $isImporting) {
                DocumentPicker { url in
                    importCounters(from: url)
                    isImporting = false
                }
            }
        #endif
    }

    private func deleteCounters(at offsets: IndexSet) {
        viewModel.counters.remove(atOffsets: offsets)
        viewModel.saveData()
    }
}
