//
//  Counter.swift
//  Masuda
//
//  Created by Stephen Kim on 9/25/25.
//

import Foundation

struct Counter: Identifiable, Codable {
    let id: UUID
    var name: String
    var count: Int
    
    init(name: String, count: Int = 0) {
        self.id = UUID()
        self.name = name
        self.count = count
    }
}
