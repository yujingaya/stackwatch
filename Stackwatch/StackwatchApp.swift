import SwiftUI

@main
struct StackwatchApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: StackwatchDocument()) { file in
            ContentView(document: file.$document)
                .frame(minWidth: 300, maxWidth: 600)
        }
        #if os(macOS)
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unifiedCompact)
        #endif
    }
}
