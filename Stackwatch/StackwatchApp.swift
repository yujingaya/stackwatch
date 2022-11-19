import SwiftUI

@main
struct StackwatchApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: StackwatchDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
