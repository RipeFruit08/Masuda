//
//  LaunchView.swift
//  Masuda
//
//  Created by Stephen Kim on 9/28/25.
//

import SwiftUI

struct LaunchView: View {
    enum Section: String, CaseIterable, Identifiable, Hashable {
        case today = "Today"
        case scheduled = "Scheduled"
        case all = "All"
        case flagged = "Flagged"
        case prototype = "Prototype"

        var id: String { rawValue }

        // Icon for each section
        var iconName: String {
            switch self {
            case .today: return "sun.max.fill"
            case .scheduled: return "calendar"
            case .all: return "tray.full.fill"
            case .flagged: return "flag.fill"
            case .prototype: return "wrench.and.screwdriver"
            }
        }
    }

    @State private var selectedSection: Section? = .today

    var body: some View {
        NavigationSplitView {
            // Sidebar
            List(Section.allCases, id: \.self, selection: $selectedSection) { section in
                NavigationLink(value: section) {
                    HStack(spacing: 12) {
                        Image(systemName: section.iconName)
                            .frame(width: 24, height: 24)
                            .foregroundColor(selectedSection == section ? .blue : .primary)
                        Text(section.rawValue)
                            .font(.headline)
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 8)
                    .background(
                        selectedSection == section
                        ? Color.blue.opacity(0.2)
                        : Color.clear
                    )
                    .cornerRadius(8)
                }
                .buttonStyle(.plain)
            }
            .listStyle(.sidebar) // Gives it the grouped sidebar look
            .navigationTitle("Sections")
        } detail: {
            // Detail view
            Group {
                switch selectedSection {
                case .today: Text("Today View")
                case .scheduled: Text("Scheduled View")
                case .all: Text("All View")
                case .flagged: Text("Flagged View")
                case .prototype: ContentView("counters.json")
                case .none: Text("Select a section")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
        .navigationDestination(for: Section.self) { section in
            // This ensures taps in the sidebar update the detail view
            switch section {
            case .today: Text("Today View")
            case .scheduled: Text("Scheduled View")
            case .all: Text("All View")
            case .flagged: Text("Flagged View")
            case .prototype: ContentView("counters.json")
            }
        }
    }
}

// idk, i can't figure out how this stuff works
struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LaunchView()
                .previewDevice("iPad Pro 12.9-inch")
                .previewInterfaceOrientation(.landscapeLeft)
                .previewDisplayName("iPad Pro 12.9-inch, Landscape Left")

            LaunchView()
                .previewDevice("iPhone 16 Pro")
        }
    }
}
