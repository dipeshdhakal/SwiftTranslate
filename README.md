# SwiftTranslate

A Swift package that provides text translation capabilities using Apple's FoundationModels framework on supported devices, with graceful fallback for older iOS/macOS versions.

## Features

- 🎯 **Cross-platform compatibility**: Works on iOS 16+ and macOS 12+
- 🔄 **Automatic fallback**: Uses FoundationModels when available, allows custom implementations otherwise
- 🏗️ **Dependency injection**: Clean architecture with protocol-based translation providers
- 🧪 **Comprehensive testing**: Unit tests with mocking support
- 🌍 **190+ languages**: Extensive language support
- **On-device translation**: Uses Apple's FoundationModels for privacy-focused, offline translation when available
- **Async/await support**: Modern Swift concurrency for seamless integration
- **Batch translation**: Translate multiple texts efficiently
- **Customizable instructions**: Inject custom prompts for specialized translation needs

## Requirements

- **Minimum**: iOS 16.0+ or macOS 12.0+
- Swift 5.5+ (for async/await support)
- **For FoundationModels features**: iOS 26.0+ or macOS 26.0+ with Apple Intelligence enabled

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

### Basic Translation with Availability Check

```swift
import SwiftTranslate

// Create a translator instance
let translator = Translator()

// Check if translation is available
let isAvailable = await translator.isTranslationAvailable()

if isAvailable {
    // Translate text
    let result = try await translator.translate(
        text: "Hello, world!",
        from: Language.english,
        to: Language.spanish
    )
    print("Translated: \(result.translatedText)")
    print("Source Language: \(result.sourceLanguage)")
    print("Target Language: \(result.targetLanguage)")
} else {
    print("Translation not available on this device")
}
```

### Translation with Automatic Language Detection

```swift
let result = try await translator.translate(
    text: "Bonjour le monde!",
    from: nil, // Let the model detect the source language
    to: Language.english
)
print("Detected source: \(result.sourceLanguage)")
print("Translated: \(result.translatedText)")
```

### Batch Translation

```swift
let texts = ["Hello", "How are you?", "Thank you"]
let results = try await translator.translateBatch(
    texts: texts,
    from: Language.english,
    to: Language.spanish
)
for result in results {
    print("Translated: \(result.translatedText)")
}
```

### Custom Translation Provider

For devices without FoundationModels support, or to use your own translation service:

```swift
class CustomTranslationProvider: TranslationProvider {
    func isAvailable() async -> Bool {
        return true // Your availability logic
    }
    
    func translate(prompt: String) async throws -> TranslationResult {
        // Your custom translation implementation
        // e.g., call to external API like Google Translate, Azure Translator, etc.
        return TranslationResult(
            translatedText: "Your translation here",
            sourceLanguage: "en",
            targetLanguage: "es"
        )
    }
}

let translator = Translator(translationProvider: CustomTranslationProvider())
```

### Fallback Mode

Use the fallback initializer when you want to handle unavailability in your app:

```swift
let translator = Translator.withFallback()

do {
    let result = try await translator.translate(text: "Hello", to: Language.spanish)
    print(result.translatedText)
} catch TranslationError.custom(let message) {
    // Handle the case where FoundationModels is not available
    print("Please implement custom translation: \(message)")
}
```
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

The package includes:
- **Unit tests**: Test core functionality with mocked providers
- **Integration tests**: Test actual FoundationModels integration (requires supported device)

Integration tests gracefully skip when FoundationModels is unavailable.

For testing with custom responders (useful for mocking):

```swift
let mockResponder: @Sendable (String) async throws -> TranslationResult = { prompt in
    // Return mock translation result
    return TranslationResult(
        translatedText: "Mock translation",
        sourceLanguage: "English",
        targetLanguage: "Spanish"
    )
}

let translator = Translator(translationProvider: MockTranslationProvider(mockClosure: mockResponder))
```

## Technical Notes

### FoundationModels Integration

The package uses conditional compilation and runtime availability checks to support FoundationModels:

```swift
#if canImport(FoundationModels)
if #available(macOS 26.0, iOS 26.0, *) {
    // Use FoundationModels
}
#endif
```

This ensures the package compiles and runs on older platforms while taking advantage of newer capabilities when available.

### Sendable Conformance

All translation providers conform to `Sendable` for safe concurrency across actor boundaries.

## Error Handling

SwiftTranslate throws `TranslationError` for various failure cases:

- `.emptyText`: When the input text is empty
- `.emptyBatch`: When the batch of texts is empty
- `.modelUnavailable`: When no translation model is available
- `.custom(String)`: Custom error with a descriptive message

```swift
do {
    let result = try await translator.translate(text: "Hello", to: Language.spanish)
    print(result.translatedText)
} catch TranslationError.emptyText {
    print("Text cannot be empty")
} catch TranslationError.modelUnavailable {
    print("Translation model not available")
} catch TranslationError.custom(let message) {
    print("Custom error: \(message)")
} catch {
    print("Other error: \(error)")
}
```

## Architecture

### Clean Separation of Concerns

The package is designed with a clean architecture that separates:

1. **Public API Layer** (`Translator` class) - Device-agnostic translation interface
2. **Protocol Layer** (`TranslationProvider` protocol) - Abstraction for different translation implementations
3. **Implementation Layer** - Concrete implementations for different scenarios:
   - `FoundationModelsTranslationProvider` - Uses Apple's on-device LLM when available
   - `FallbackTranslationProvider` - Placeholder for custom implementations

### Availability Handling

The package automatically detects device capabilities:
- On iOS 26+/macOS 26+ with FoundationModels: Uses on-device AI translation
- On older versions or unsupported devices: Gracefully falls back to custom implementations

### Core Components

- **`Translator`**: Main class for performing translations
- **`TranslationProvider`**: Protocol for translation implementations
- **`Language`**: Enum representing supported languages with display names
- **`TranslationResult`**: Struct containing the translated text and detected/provided languages
- **`TranslationError`**: Error types for translation failures

The package uses dependency injection for the translation provider, making it easy to test and customize.

## Contributing

Contributions are welcome! Please ensure all tests pass and add tests for new features.

## License

This project is licensed under the MIT License.
