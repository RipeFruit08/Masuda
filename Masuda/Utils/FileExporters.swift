//
//  ShareSheet.swift
//  Masuda
//
//  Created by Stephen Kim on 9/25/25.
//

// FileExporters.swift

import Foundation

#if canImport(UIKit)
import SwiftUI
import UIKit

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
#endif

#if os(macOS)
import AppKit

struct FileExporter {
    static func exportCountersFile(from url: URL) {
        let panel = NSSavePanel()
        panel.allowedFileTypes = ["json"]
        panel.nameFieldStringValue = "counters.json"
        panel.canCreateDirectories = true

        panel.begin { response in
            if response == .OK, let destinationURL = panel.url {
                do {
                    try FileManager.default.copyItem(at: url, to: destinationURL)
                    print("Export successful to \(destinationURL)")
                } catch {
                    print("Export failed: \(error)")
                }
            }
        }
    }
}
#endif
