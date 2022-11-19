import Foundation
import SwiftUI
import UniformTypeIdentifiers

extension StackwatchDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.stackDocument] }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }

        self = try JSONDecoder().decode(Self.self, from: data)
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(self)
        return .init(regularFileWithContents: data)
    }
}

extension UTType {
    fileprivate static let stackDocument = UTType(exportedAs: "com.yujingaya.stackwatch.stack")
}
