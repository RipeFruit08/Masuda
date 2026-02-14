//
//  DataManager.swift
//  Masuda
//
//  Created by Stephen Kim on 9/25/25.
//

import Foundation

enum DataManagerError: Error, LocalizedError {
    case fileAlreadyExists(String)
    case failedToWrite(Error)

    var errorDescription: String? {
        switch self {
        case .fileAlreadyExists(let name):
            return "A file named '\(name)' already exists."
        case .failedToWrite(let error):
            return "Failed to create file: \(error.localizedDescription)"
        }
    }
}

class DataManager {
    static let shared = DataManager()
    
    private func fileURL(for filename: String) -> URL {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return directory.appendingPathComponent(filename)
    }
    
    func listJSONFiles() -> [String] {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let files = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
            return files
                .filter { $0.pathExtension == "json"}
                .map { $0.lastPathComponent }
        } catch {
            print("Error listing files: \(error)")
            return []
        }
    }
    
    func domything() {
        print("helllllllllllllloooooooooooooo")
        let saveURL = fileURL(for: "counters.json")
        print("Saving to:", saveURL.path)

        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        print("Listing from:", docs.path)
        
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: docs.path)
            print("Files in directory:", files)
        } catch {
            print("generic error")
        }
        
    }
    
    func createNewFile(named filename: String) throws {
        let url = fileURL(for: filename)
        let finalURL = url.pathExtension == "json" ? url : url.appendingPathExtension("json")

        if FileManager.default.fileExists(atPath: finalURL.path) {
            throw DataManagerError.fileAlreadyExists(finalURL.lastPathComponent)
        }

        let emptyCounters: [Counter] = []
        do {
            let data = try JSONEncoder().encode(emptyCounters)
            try data.write(to: finalURL)
        } catch {
            throw DataManagerError.failedToWrite(error)
        }
    }

    func save(_ counters: [Counter], to filename: String) {
        let url = fileURL(for: filename)
        do {
            let data = try JSONEncoder().encode(counters)
            try data.write(to: url)
        } catch {
            print("Failed to save data: \(error)")
        }
    }

    func load(from filename: String) -> [Counter] {
        let url = fileURL(for: filename)
        guard FileManager.default.fileExists(atPath: url.path) else { return [] }
        do {
            let data = try Data(contentsOf: url)
            let counters = try JSONDecoder().decode([Counter].self, from: data)
            return counters
        } catch {
            print("Failed to load data: \(error)")
            return []
        }
    }
}
