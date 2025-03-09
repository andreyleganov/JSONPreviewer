// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct JSONPreviewView: View {
    private let jsonData: Data?
    
    public init(jsonString: String) {
        self.jsonData = jsonString.data(using: .utf8)
        Self.printFormattedJSON(jsonString)
    }
    
    private var formattedJSON: String {
        Self.formatJSON(jsonData)
    }
    
    public static func formatJSON(_ data: Data?) -> String {
        guard let data = data,
              let object = try? JSONSerialization.jsonObject(with: data, options: []),
              let prettyData = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted),
              let prettyString = String(data: prettyData, encoding: .utf8) else {
            return "❌ Invalid JSON"
        }
        return prettyString
    }
    
    public static func printFormattedJSON(_ jsonString: String) {
        let formatted = formatJSON(jsonString.data(using: .utf8))
        print("📜 Formatted JSON:\n\(formatted)")
    }

    public var body: some View {
        ScrollView {
            Text(formattedJSON)
                .font(.system(.body, design: .monospaced))
                .padding()
        }
    }
}
