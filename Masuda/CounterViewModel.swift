//
//  CounterViewModel.swift
//  Masuda
//
//  Created by Stephen Kim on 9/25/25.
//

import Foundation
import SwiftUI
import Combine

class CounterViewModel: ObservableObject {
    let filename: String
    @Published var counters: [Counter] = []
    
    init(filename: String) {
        self.filename = filename
        loadData()
    }
    
    func addCounter(named name: String) {
        let newCounter = Counter(name: name)
        counters.append(newCounter)
        saveData()
    }
    
    func incrementCounter(_ counter: Counter) {
        if let index = counters.firstIndex(where: { $0.id == counter.id }) {
            counters[index].count += 1
            saveData()
        }
    }
    
    var totalCount: Int {
        counters.reduce(0) { $0 + $1.count }
    }
    
    func percentage(for counter: Counter) -> Double {
        let total = totalCount
        guard total > 0 else { return 0 }
        return (Double(counter.count) / Double(total)) * 100
    }

    private func loadData() {
        counters = DataManager.shared.load(from: filename)
    }

    func saveData() {
        DataManager.shared.save(counters, to: filename)
    }
}
