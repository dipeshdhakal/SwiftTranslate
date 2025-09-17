import Foundation

// FoundationModels import will be conditionally available
#if canImport(FoundationModels)
import FoundationModels
#endif

// MARK: - Core Translation Types

/// Protocol for translation providers.
public protocol TranslationProvider: Sendable {
    /// Translates text based on the given prompt.
    /// - Parameter prompt: The translation prompt including source text and target language.
    /// - Returns: The translation result.
    /// - Throws: TranslationError if translation fails.
    func translate(prompt: String) async throws -> TranslationResult
    
    /// Checks if the translation provider is available.
    /// - Returns: true if the provider can perform translations, false otherwise.
    func isAvailable() async -> Bool
}

/// Struct for structured translation output that works across all iOS versions.
public struct TranslationResult {
    /// Unique identifier for this translation.
    public let id: String
    /// The translated text.
    public let translatedText: String
    /// The detected or provided source language in ISO 639-1 code (e.g., 'en' for English).
    public let sourceLanguage: String
    /// The target language in ISO 639-1 code (e.g., 'es' for Spanish).
    public let targetLanguage: String
    
    /// Initializes a new translation result.
    /// - Parameters:
    ///   - translatedText: The translated text.
    ///   - sourceLanguage: The source language code.
    ///   - targetLanguage: The target language code.
    ///   - id: Unique identifier. Defaults to a new UUID string.
    public init(translatedText: String, sourceLanguage: String, targetLanguage: String, id: String = UUID().uuidString) {
        self.translatedText = translatedText
        self.sourceLanguage = sourceLanguage
        self.targetLanguage = targetLanguage
        self.id = id
    }
}

/// Errors that can occur during translation.
public enum TranslationError: Error, LocalizedError, Equatable {
    /// The input text is empty.
    case emptyText
    /// The batch of texts is empty.
    case emptyBatch
    /// No model backend is available to perform the translation.
    case modelUnavailable
    /// Custom error with message.
    case custom(String)

    public var errorDescription: String? {
        switch self {
        case .emptyText:
            return "The input text cannot be empty."
        case .emptyBatch:
            return "The batch of texts cannot be empty."
        case .modelUnavailable:
            return "No translation model is available. Please provide a custom translation provider or ensure FoundationModels is available on supported devices."
        case .custom(let message):
            return message
        }
    }
}

// MARK: - FoundationModels Implementation

/// FoundationModels-specific TranslationResult for devices that support it.
/// This struct includes the @Generable and @Guide attributes required by FoundationModels.
#if canImport(FoundationModels)
@available(macOS 26.0, iOS 26.0, *)
@Generable
private struct FoundationModelsTranslationResult {
    public let id: String
    @Guide(description: "The translated text.")
    public let translatedText: String
    @Guide(description: "The detected or provided source language in ISO 639-1 code (e.g., 'en' for English).")
    public let sourceLanguage: String
    @Guide(description: "The target language in ISO 639-1 code (e.g., 'es' for Spanish).")
    public let targetLanguage: String
    
    public init(translatedText: String, sourceLanguage: String, targetLanguage: String, id: String = UUID().uuidString) {
        self.translatedText = translatedText
        self.sourceLanguage = sourceLanguage
        self.targetLanguage = targetLanguage
        self.id = id
    }
    
    /// Convert to the public TranslationResult.
    public func toTranslationResult() -> TranslationResult {
        return TranslationResult(
            translatedText: translatedText,
            sourceLanguage: sourceLanguage,
            targetLanguage: targetLanguage,
            id: id
        )
    }
}
#endif

/// Translation provider that uses FoundationModels when available.
public final class FoundationModelsTranslationProvider: TranslationProvider {
    private let instructions: String

    /// Initializes the provider with given instructions.
    public init(instructions: String) {
        self.instructions = instructions
    }

    /// Checks if the language model is available.
    public func isAvailable() async -> Bool {
        #if canImport(FoundationModels)
        if #available(macOS 26.0, iOS 26.0, *) {
            let model = SystemLanguageModel.default
            switch model.availability {
            case .available:
                return true
            case .unavailable:
                return false
            }
        } else {
            return false
        }
        #else
        return false
        #endif
    }

    /// Translates the given prompt using a language model.
    public func translate(prompt: String) async throws -> TranslationResult {
        #if canImport(FoundationModels)
        if #available(macOS 26.0, iOS 26.0, *) {
            guard await isAvailable() else {
                throw TranslationError.modelUnavailable
            }

            do {
                let session = LanguageModelSession(instructions: instructions)
                let response = try await session.respond(to: prompt, generating: FoundationModelsTranslationResult.self)
                return response.content.toTranslationResult()
            } catch let error as NSError where error.domain == "com.apple.UnifiedAssetFramework" {
                // Handle FoundationModels asset/framework errors
                throw TranslationError.modelUnavailable
            } catch {
                // Re-throw other errors as-is
                throw error
            }
        } else {
            throw TranslationError.modelUnavailable
        }
        #else
        throw TranslationError.modelUnavailable
        #endif
    }
}

// MARK: - Fallback Implementation

/// A fallback translation provider for when FoundationModels is not available.
/// This implementation throws an error and requires users to provide their own implementation.
public final class FallbackTranslationProvider: TranslationProvider {
    
    public init() {}
    
    public func isAvailable() async -> Bool {
        return false
    }
    
    public func translate(prompt: String) async throws -> TranslationResult {
        throw TranslationError.custom("FoundationModels is not available on this device. Please provide a custom TranslationProvider implementation.")
    }
}

/// A translator that uses a language model to translate text between supported languages.
public class Translator {

    /// Instructions provided to the language model to guide translation behavior.
    private let instructions: String
    /// The translation provider used to generate translations.
    private let translationProvider: TranslationProvider

    /// Initializes a new Translator instance.
    /// - Parameters:
    ///   - instructions: Custom instructions for the language model. Defaults to a standard translation prompt.
    ///   - translationProvider: Custom translation provider. If nil, uses FoundationModels when available.
    public init(instructions: String? = nil, translationProvider: TranslationProvider? = nil) {
        self.instructions = instructions ?? """
        You are a professional translator. Your task is to translate text accurately from the source language to the target language.
        Provide the translation in the required structured format, including the detected or provided source and target languages.
        Maintain the original meaning, tone, and style as much as possible.
        """

        self.translationProvider = translationProvider ?? Self.createDefaultProvider(instructions: self.instructions)
    }
    
    /// Convenience initializer that creates a Translator with a fallback provider.
    /// Use this when you want to handle translation unavailability in your own code.
    /// - Parameter instructions: Custom instructions for the language model.
    /// - Returns: A Translator instance that will throw errors when FoundationModels is unavailable.
    public static func withFallback(instructions: String? = nil) -> Translator {
        let defaultInstructions = instructions ?? """
        You are a professional translator. Your task is to translate text accurately from the source language to the target language.
        Provide the translation in the required structured format, including the detected or provided source and target languages.
        Maintain the original meaning, tone, and style as much as possible.
        """
        return Translator(instructions: defaultInstructions, translationProvider: FallbackTranslationProvider())
    }
    
    /// Creates the default translation provider based on device capabilities.
    /// - Parameter instructions: Instructions for the translation provider.
    /// - Returns: A translation provider (FoundationModels if available, fallback otherwise).
    private static func createDefaultProvider(instructions: String) -> TranslationProvider {
        // Return FoundationModels provider which will handle availability checks internally
        return FoundationModelsTranslationProvider(instructions: instructions)
    }

    /// Returns all languages for translation.
    /// - Returns: An array of all `Language` cases.
    public static var allLanguages: [Language] {
        return Language.allCases
    }
    
    /// Checks if translation is currently available.
    /// - Returns: true if the translation provider is available, false otherwise.
    public func isTranslationAvailable() async -> Bool {
        return await translationProvider.isAvailable()
    }

    /// Translates the given text from the source language to the target language using async/await.
    /// - Parameters:
    ///   - text: The text to translate. Must not be empty.
    ///   - sourceLanguage: The source language. If nil, the model will detect it.
    ///   - targetLanguage: The target language.
    /// - Returns: The translation result including translated text and languages.
    /// - Throws: An error if the translation fails or if input validation fails.
    ///
    /// - Note: This method is available on Swift 5.5+ and uses async/await for modern concurrency.
    public func translate(text: String, from sourceLanguage: Language? = nil, to targetLanguage: Language) async throws -> TranslationResult {
        guard !text.isEmpty else {
            throw TranslationError.emptyText
        }

        let prompt: String
        if let source = sourceLanguage {
            prompt = "Translate the following text from \(source.displayName) to \(targetLanguage.displayName): \(text)"
        } else {
            prompt = "Detect the source language and translate the following text to \(targetLanguage.displayName): \(text)"
        }
        return try await translationProvider.translate(prompt: prompt)
    }

    /// Translates multiple texts from the source language to the target language using async/await.
    /// - Parameters:
    ///   - texts: An array of texts to translate.
    ///   - sourceLanguage: The source language. If nil, the model will detect it for each text.
    ///   - targetLanguage: The target language.
    /// - Returns: An array of translation results.
    /// - Throws: An error if the translation fails or if input validation fails.
    public func translateBatch(texts: [String], from sourceLanguage: Language? = nil, to targetLanguage: Language) async throws -> [TranslationResult] {
        guard !texts.isEmpty else {
            throw TranslationError.emptyBatch
        }

        guard texts.allSatisfy({ !$0.isEmpty }) else {
            throw TranslationError.emptyText
        }

        var translations: [TranslationResult] = []
        for text in texts {
            let prompt: String
            if let source = sourceLanguage {
                prompt = "Translate the following text from \(source.displayName) to \(targetLanguage.displayName): \(text)"
            } else {
                prompt = "Detect the source language and translate the following text to \(targetLanguage.displayName): \(text)"
            }
            let translatedResult = try await translationProvider.translate(prompt: prompt)
            translations.append(translatedResult)
        }
        return translations
    }

    // MARK: - Private Methods

}