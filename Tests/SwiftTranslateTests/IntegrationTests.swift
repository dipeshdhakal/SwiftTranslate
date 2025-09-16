import Testing
import Foundation
@testable import SwiftTranslate
import XCTest

/// Integration tests that perform actual translations using FoundationModels.
/// These tests require a working FoundationModels setup and may be slower than unit tests.
///
/// Note: These tests are integration tests and may be skipped in CI environments
/// where FoundationModels is not available or configured.
@Suite("Integration Tests")
struct IntegrationTests {

    /// Helper function to perform translation with graceful handling of FoundationModels availability
    private func performTranslation(text: String, from sourceLanguage: Language? = nil, to targetLanguage: Language) async throws -> TranslationResult {
        let translator = Translator()
        do {
            return try await translator.translate(text: text, from: sourceLanguage, to: targetLanguage)
        } catch TranslationError.modelUnavailable {
            print("Skipping integration test: FoundationModels not available")
            throw XCTSkip("FoundationModels framework not available for integration testing")
        }
    }

    /// Helper function to perform batch translation with graceful handling of FoundationModels availability
    private func performBatchTranslation(texts: [String], from sourceLanguage: Language? = nil, to targetLanguage: Language) async throws -> [TranslationResult] {
        let translator = Translator()
        do {
            return try await translator.translateBatch(texts: texts, from: sourceLanguage, to: targetLanguage)
        } catch TranslationError.modelUnavailable {
            print("Skipping integration test: FoundationModels not available")
            throw XCTSkip("FoundationModels framework not available for integration testing")
        }
    }

    /// Test basic English to Spanish translation using the default translation provider.
    @Test("English to Spanish translation")
    func testEnglishToSpanishTranslation() async throws {
        let result = try await performTranslation(text: "Hello, how are you?", from: .english, to: .spanish)

        // Verify basic structure
        #expect(!result.translatedText.isEmpty)
        #expect(result.sourceLanguage == "en")
        #expect(result.targetLanguage == "es")
        #expect(result.id != "")

        // The translation should contain Spanish text (basic sanity check)
        // Note: We don't check exact translation as AI models may vary
        #expect(result.translatedText.lowercased().contains("hola") ||
                result.translatedText.lowercased().contains("cómo") ||
                result.translatedText.lowercased().contains("estás"))
    }

    /// Test Spanish to English translation.
    @Test("Spanish to English translation")
    func testSpanishToEnglishTranslation() async throws {
        let result = try await performTranslation(text: "Hola, ¿cómo estás?", from: .spanish, to: .english)

        #expect(!result.translatedText.isEmpty)
        #expect(result.sourceLanguage == "es")
        #expect(result.targetLanguage == "en")

        // Should contain English equivalents
        #expect(result.translatedText.lowercased().contains("hello") ||
                result.translatedText.lowercased().contains("how") ||
                result.translatedText.lowercased().contains("are"))
    }

    /// Test French to English translation.
    @Test("French to English translation")
    func testFrenchToEnglishTranslation() async throws {
        let result = try await performTranslation(text: "Bonjour, comment allez-vous?", from: .french, to: .english)

        #expect(!result.translatedText.isEmpty)
        #expect(result.sourceLanguage == "fr")
        #expect(result.targetLanguage == "en")

        // Should contain English equivalents
        #expect(result.translatedText.lowercased().contains("hello") ||
                result.translatedText.lowercased().contains("how") ||
                result.translatedText.lowercased().contains("are"))
    }

    /// Test German to English translation.
    @Test("German to English translation")
    func testGermanToEnglishTranslation() async throws {
        let result = try await performTranslation(text: "Hallo, wie geht es dir?", from: .german, to: .english)

        #expect(!result.translatedText.isEmpty)
        #expect(result.sourceLanguage == "de")
        #expect(result.targetLanguage == "en")

        // Should contain English equivalents
        #expect(result.translatedText.lowercased().contains("hello") ||
                result.translatedText.lowercased().contains("how") ||
                result.translatedText.lowercased().contains("are"))
    }

    /// Test auto-detection of source language.
    @Test("Auto-detect source language")
    func testAutoDetectSourceLanguage() async throws {
        let result = try await performTranslation(text: "Hola, ¿cómo estás hoy?", from: nil, to: .english)

        #expect(!result.translatedText.isEmpty)
        #expect(result.sourceLanguage.lowercased().contains("es") ||
                result.sourceLanguage == "es")
        #expect(result.targetLanguage == "en")
    }

    /// Test batch translation functionality.
    @Test("Batch translation")
    func testBatchTranslation() async throws {
        let texts = [
            "Hello world",
            "How are you?",
            "Thank you very much"
        ]

        let results = try await performBatchTranslation(texts: texts, from: .english, to: .spanish)

        #expect(results.count == 3)

        for result in results {
            #expect(!result.translatedText.isEmpty)
            #expect(result.sourceLanguage == "en")
            #expect(result.targetLanguage == "es")
        }

        // Basic sanity check - translations should be different
        #expect(results[0].translatedText != results[1].translatedText)
        #expect(results[1].translatedText != results[2].translatedText)
    }

    /// Test translation with longer text.
    @Test("Long text translation")
    func testLongTextTranslation() async throws {
        let longText = """
        Swift is a powerful and intuitive programming language for iOS, macOS, watchOS, and tvOS.
        Writing Swift code is interactive and fun, the syntax is concise yet expressive, and Swift
        includes modern features developers love. Swift code is safe by design, yet also produces
        software that runs lightning-fast.
        """

        let result = try await performTranslation(text: longText, from: .english, to: .spanish)

        #expect(!result.translatedText.isEmpty)
        #expect(result.translatedText.count > 50) // Should be substantial translation
        #expect(result.sourceLanguage == "en")
        #expect(result.targetLanguage == "es")
    }

    /// Test translation with special characters and formatting.
    @Test("Special characters translation")
    func testSpecialCharactersTranslation() async throws {
        let textWithSpecialChars = "Hello! How are you? I'm fine, thank you. What's your name?"

        let result = try await performTranslation(text: textWithSpecialChars, from: .english, to: .spanish)

        #expect(!result.translatedText.isEmpty)
        #expect(result.sourceLanguage == "en")
        #expect(result.targetLanguage == "es")

        // Should preserve punctuation
        #expect(result.translatedText.contains("!") ||
                result.translatedText.contains("?") ||
                result.translatedText.contains(","))
    }

    /// Test round-trip translation (English -> Spanish -> English).
    @Test("Round-trip translation")
    func testRoundTripTranslation() async throws {
        let originalText = "The quick brown fox jumps over the lazy dog."

        // First translation: English to Spanish
        let spanishResult = try await performTranslation(text: originalText, from: .english, to: .spanish)
        #expect(!spanishResult.translatedText.isEmpty)

        // Second translation: Spanish back to English
        let englishResult = try await performTranslation(text: spanishResult.translatedText, from: .spanish, to: .english)
        #expect(!englishResult.translatedText.isEmpty)

        // The round-trip should produce some form of the original meaning
        // (exact match is unlikely due to translation variations)
        #expect(englishResult.translatedText.lowercased().contains("fox") ||
                englishResult.translatedText.lowercased().contains("dog") ||
                englishResult.translatedText.lowercased().contains("jump"))
    }

    /// Test translation with custom instructions.
    @Test("Custom instructions translation")
    func testCustomInstructionsTranslation() async throws {
        let customInstructions = """
        You are a professional translator specializing in formal business language.
        Translate the text maintaining a formal, professional tone suitable for business correspondence.
        Use appropriate formal language and avoid colloquial expressions.
        """

        let translator = Translator(instructions: customInstructions)

        do {
            let result = try await translator.translate(text: "Hey, what's up? Let's meet tomorrow.", from: .english, to: .spanish)

            #expect(!result.translatedText.isEmpty)
            #expect(result.sourceLanguage == "en")
            #expect(result.targetLanguage == "es")

            // The result should be more formal than casual translation
            // (This is a subjective check, but we verify the translation exists)
            #expect(result.translatedText.count > 10)
        } catch TranslationError.modelUnavailable {
            // Skip test if FoundationModels is not available
            print("Skipping integration test: FoundationModels not available")
            throw XCTSkip("FoundationModels framework not available for integration testing")
        }
    }
}
