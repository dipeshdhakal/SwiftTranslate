# SwiftTranslate

A Swift package for translating text using Apple's FoundationModels framework. This package provides an easy-to-use API for on-device text translation leveraging large language models.

## Features

- **On-device translation**: Uses Apple's FoundationModels for privacy-focused, offline translation
- **Async/await support**: Modern Swift concurrency for seamless integration
- **Batch translation**: Translate multiple texts efficiently
- **Customizable instructions**: Inject custom prompts for specialized translation needs
- **Test-friendly**: Supports dependency injection for easy testing with mock responders

## Requirements

- Swift 6.2+
- macOS 26.0+ or iOS 26.0+
- Xcode 26.0+

## Installation

### Swift Package Manager

Add SwiftTranslate as a dependency to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/dipeshdhakal/SwiftTranslate.git", from: "1.0.0")
]
```

Then add it to your target:

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["SwiftTranslate"]
    )
]
```

### Xcode

1. Open your project in Xcode
2. Go to File > Add Packages...
3. Enter the repository URL: `https://github.com/dipeshdhakal/SwiftTranslate.git`
4. Choose the version you want to use

## Usage

### Basic Translation

```swift
import SwiftTranslate

let translator = Translator()

// Async/await
do {
    let result = try await translator.translate(
        text: "Hello, world!",
        from: .english,
        to: .french
    )
    print("Translated: \(result.translatedText)")
    print("Source Language: \(result.sourceLanguage)")
    print("Target Language: \(result.targetLanguage)")
} catch {
    print("Translation failed: \(error)")
}
```

### Translation with Automatic Language Detection

```swift
let result = try await translator.translate(
    text: "Bonjour le monde!",
    from: nil, // Let the model detect the source language
    to: .english
)
print("Detected source: \(result.sourceLanguage)")
print("Translated: \(result.translatedText)")
```

### Batch Translation

```swift
let texts = ["Hello", "How are you?", "Thank you"]
let results = try await translator.translateBatch(
    texts: texts,
    from: .english,
    to: .spanish
)
for result in results {
    print("Translated: \(result.translatedText)")
}
```

### Custom Instructions

```swift
let customTranslator = Translator(instructions: """
    You are a professional translator specializing in technical documentation.
    Translate the following text with precision, maintaining technical terminology.
    Provide the translation in the required structured format.
""")

let result = try await customTranslator.translate(
    text: "This is a technical document.",
    from: .english,
    to: .german
)
print("Translated: \(result.translatedText)")
```

### Supported Languages

SwiftTranslate supports 50+ languages. You can get all supported languages:

```swift
let languages = Translator.supportedLanguages
print(languages.count) // 50+
```

Some examples of supported languages:
- English (`Language.english`)
- French (`Language.french`)
- Spanish (`Language.spanish`)
- German (`Language.german`)
- Chinese (`Language.chinese`)
- Japanese (`Language.japanese`)
- Hindi (`Language.hindi`)
- Arabic (`Language.arabic`)
- And many more...

Each language has both a `displayName` (e.g., "English") and a `localisedName` (e.g., "English" or native script where applicable).

## Testing

The package includes comprehensive unit tests. To run tests:

```bash
swift test
```

For testing with custom responders (useful for mocking):

```swift
let mockResponder: (String) async throws -> TranslationResult = { prompt in
    // Return mock translation result
    return TranslationResult(
        translatedText: "Mock translation",
        sourceLanguage: "English",
        targetLanguage: "Spanish"
    )
}

let translator = Translator(translationProvider: MockTranslationProvider(mockClosure: mockResponder))
```

## Error Handling

SwiftTranslate throws `TranslationError` for various failure cases:

- `.emptyText`: When the input text is empty
- `.emptyBatch`: When the batch of texts is empty
- `.modelUnavailable`: When no translation model is available (checked proactively before attempting translation)

```swift
do {
    let result = try await translator.translate(text: "Hello", from: .english, to: .french)
} catch TranslationError.modelUnavailable {
    print("Translation model is not available. Please ensure Apple Intelligence is enabled and the device supports it.")
} catch TranslationError.emptyText {
    print("Please provide non-empty text")
} catch {
    print("Other error: \(error)")
}
```

## Architecture

- **`Translator`**: Main class for performing translations
- **`Language`**: Enum representing supported languages with display names
- **`TranslationResult`**: Struct containing the translated text and detected/provided languages
- **`TranslationError`**: Error types for translation failures

The package uses dependency injection for the translation responder, making it easy to test and customize.

## Contributing

Contributions are welcome! Please ensure all tests pass and add tests for new features.

## License

This project is licensed under the MIT License.
