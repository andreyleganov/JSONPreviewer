// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import os

public struct JSONPreviewView<T: Codable>: View {
    
    private let jsonData: Data?
    private let decodingError: String?  // Ошибка, если есть
    
    public init(jsonString: String, modelType: T.Type) {
        self.jsonData = jsonString.data(using: .utf8)
        
        let (parsed, error) = Self.parseJSON(jsonString, modelType: modelType)
        self.decodingError = error
        
        if let error = error {
            Self.logError(error)  // Логируем ошибку в консоль
        } else {
            Self.printFormattedJSON(jsonString)  // Логируем JSON, если ошибок нет
        }
    }

    private var formattedJSON: String {
        if let error = decodingError {
            return "❌ JSON Decoding Error:\n\(error)"  // Показываем ошибку
        }
        return Self.formatJSON(jsonData)
    }

    public var body: some View {
        ScrollView {
            Text(formattedJSON)
                .font(.system(.body, design: .monospaced))
                .padding()
        }
    }

    // ✅ Форматирование JSON
    public static func formatJSON(_ data: Data?) -> String {
        guard let data = data,
              let object = try? JSONSerialization.jsonObject(with: data, options: []),
              let prettyData = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted),
              let prettyString = String(data: prettyData, encoding: .utf8) else {
            return "❌ Invalid JSON"
        }
        return prettyString
    }

    // ✅ Декодирование JSON и возврат ошибки по конкретному полю
    public static func parseJSON<T: Codable>(_ jsonString: String, modelType: T.Type) -> (T?, String?) {
        guard let data = jsonString.data(using: .utf8) else {
            return (nil, "Cannot convert string to Data")
        }
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return (decodedObject, nil)
        } catch let DecodingError.keyNotFound(key, context) {
            return (nil, "❌ Missing key '\(key.stringValue)' in JSON. Context: \(context.debugDescription)")
        } catch let DecodingError.typeMismatch(_, context) {
            return (nil, "❌ Type mismatch for key '\(context.codingPath.map { $0.stringValue }.joined(separator: "."))'. Expected \(context.debugDescription)")
        } catch let DecodingError.valueNotFound(_, context) {
            return (nil, "❌ Missing value for key '\(context.codingPath.map { $0.stringValue }.joined(separator: "."))'.")
        } catch let DecodingError.dataCorrupted(context) {
            return (nil, "❌ Data corrupted: \(context.debugDescription)")
        } catch {
            return (nil, "❌ Unknown decoding error: \(error.localizedDescription)")
        }
    }

    // ✅ Логирование ошибок JSON
    public static func logError(_ error: String) {
        #if DEBUG
        if #available(iOS 14.0, *) {
            let logger = Logger(subsystem: "com.yourapp.JSONPreviewer", category: "JSON Debug")
            logger.error("❌ JSON Error: \(error, privacy: .public)")
        } else {
            print("❌ JSON Error: \(error)")
        }
        #endif
    }

    // ✅ Логирование корректного JSON
    public static func printFormattedJSON(_ jsonString: String) {
        let formatted = formatJSON(jsonString.data(using: .utf8))
        
        #if DEBUG
        if #available(iOS 14.0, *) {
            let logger = Logger(subsystem: "com.yourapp.JSONPreviewer", category: "JSON Debug")
            logger.info("\(formatted, privacy: .public)")
        } else {
            print("📜 Formatted JSON:\n\(formatted)")
        }
        #endif
    }
}

