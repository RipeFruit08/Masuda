//
//  DocumentPicker.swift
//  Masuda
//
//  Created by Stephen Kim on 9/25/25.
//

// FileImporters.swift

import Foundation

#if canImport(UIKit)
import SwiftUI
import UniformTypeIdentifiers
import UIKit

struct DocumentPicker: UIViewControllerRepresentable {
    var onPick: (URL) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onPick: onPick)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.json])
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let onPick: (URL) -> Void

        init(onPick: @escaping (URL) -> Void) {
            self.onPick = onPick
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let selectedURL = urls.first else { return }
            onPick(selectedURL)
        }
    }
}
#endif

#if os(macOS)
import AppKit

struct FileImporter {
    static func importCounters(completion: @escaping ([Counter]) -> Void) {
        let panel = NSOpenPanel()
        panel.allowedFileTypes = ["json"]
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.title = "Import counters.json"

        panel.begin { response in
            if response == .OK, let url = panel.url {
                do {
                    let data = try Data(contentsOf: url)
                    let counters = try JSONDecoder().decode([Counter].self, from: data)
                    completion(counters)
                } catch {
                    print("Import failed: \(error)")
                }
            }
        }
    }
}
#endif

