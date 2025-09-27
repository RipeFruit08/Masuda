//
//  DataManager.swift
//  Masuda
//
//  Created by Stephen Kim on 9/25/25.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    
    let filename = "counters.json"
    
    private var fileURL: URL {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return directory.appendingPathComponent(filename)
    }

    func save(_ counters: [Counter]) {
        do {
            let data = try JSONEncoder().encode(counters)
            try data.write(to: fileURL)
        } catch {
            print("Failed to save data: \(error)")
        }
    }

    func load() -> [Counter] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return [] }
        do {
            let data = try Data(contentsOf: fileURL)
            let counters = try JSONDecoder().decode([Counter].self, from: data)
            return counters
        } catch {
            print("Failed to load data: \(error)")
            return []
        }
    }
}
