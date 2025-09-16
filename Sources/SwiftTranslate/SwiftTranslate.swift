import Foundation
import FoundationModels

/// Protocol for translation providers.
public protocol TranslationProvider {
    func translate(prompt: String) async throws -> TranslationResult
    func isAvailable() async -> Bool
}

/// Struct for structured translation output.
@Generable
public struct TranslationResult {
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
}

/// Default implementation using FoundationModels.
public class DefaultTranslationProvider: TranslationProvider {
    private let instructions: String

    /// Initializes the provider with given instructions.
    public init(instructions: String) {
        self.instructions = instructions
    }

    /// Checks if the language model is available.
    public func isAvailable() async -> Bool {
        let model = SystemLanguageModel.default
        switch model.availability {
        case .available:
            return true
        case .unavailable:
            return false
        }
    }

    // Translates the given prompt using a language model.
    public func translate(prompt: String) async throws -> TranslationResult {
        guard await isAvailable() else {
            throw TranslationError.modelUnavailable
        }

        do {
            let session = LanguageModelSession(instructions: instructions)
            let response = try await session.respond(to: prompt, generating: TranslationResult.self)
            return response.content
        } catch let error as NSError where error.domain == "com.apple.UnifiedAssetFramework" {
            // Handle FoundationModels asset/framework errors
            throw TranslationError.modelUnavailable
        } catch {
            // Re-throw other errors as-is
            throw error
        }
    }
}

/// A translator that uses a language model to translate text between supported languages.
public class Translator {

    /// Instructions provided to the language model to guide translation behavior.
    private let instructions: String
    /// The translation provider used to generate translations.
    private let translationProvider: TranslationProvider

    /// Initializes a new Translator instance.
    /// - Parameter instructions: Custom instructions for the language model. Defaults to a standard translation prompt.
    public init(instructions: String? = nil, translationProvider: TranslationProvider? = nil) {
        self.instructions = instructions ?? """
        You are a professional translator. Your task is to translate text accurately from the source language to the target language.
        Provide the translation in the required structured format, including the detected or provided source and target languages.
        Maintain the original meaning, tone, and style as much as possible.
        """

        self.translationProvider = translationProvider ?? DefaultTranslationProvider(instructions: self.instructions)
    }

    /// Returns all languages for translation.
    /// - Returns: An array of all `Language` cases.
    public static var allLanguages: [Language] {
        return Language.allCases
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

/// Errors that can occur during translation.
public enum TranslationError: Error, LocalizedError {
    /// The input text is empty.
    case emptyText
    /// The batch of texts is empty.
    case emptyBatch
    /// No model backend is available to perform the translation.
    case modelUnavailable

    public var errorDescription: String? {
        switch self {
        case .emptyText:
            return "The input text cannot be empty."
        case .emptyBatch:
            return "The batch of texts cannot be empty."
        case .modelUnavailable:
            return "No translation model is available. Inject a translationProvider when creating Translator for tests or ensure FoundationModels is available at runtime."
        }
    }
}
