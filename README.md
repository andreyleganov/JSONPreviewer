# JSONPreviewer

A simple SwiftUI view for displaying formatted JSON strings.

## Installation
Add the package via Swift Package Manager: https://github.com/andreyleganov/JSONPreviewer.git

## Usage
```swift
import JSONPreviewer

struct ContentView: View {
    var body: some View {
        JSONPreviewView(jsonString: "{\"name\":\"Alice\",\"city\":\"Barcelona\"}")
    }
}
