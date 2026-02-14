//
//  CounterRowView.swift
//  Masuda
//
//  Created by Stephen Kim on 9/25/25.
//

import SwiftUI

struct CounterRowView: View {
    let counter: Counter
    let onIncrement: () -> Void
    let percentage: Double

    var body: some View {
        HStack {
            Text(counter.name)
                .frame(width: 120, alignment: .leading)
            Spacer()
            Text("\(counter.count)")
            Spacer()
            Text(String(format: "%.1f%%", percentage))
                .frame(width: 60, alignment: .trailing)
            Button(action: {
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                onIncrement()
                impactMed.impactOccurred()
            }) {
                Text("+1")
                    .padding(.horizontal)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }.buttonStyle(PlainButtonStyle())
        }
    }
}
