import Testing
import Foundation
@testable import SwiftTranslate

final class MockTranslationProvider: TranslationProvider {
    let mockClosure: @Sendable (String) async throws -> TranslationResult
    let available: Bool

    init(mockClosure: @escaping @Sendable (String) async throws -> TranslationResult, available: Bool = true) {
        self.mockClosure = mockClosure
        self.available = available
    }

    func translate(prompt: String) async throws -> TranslationResult {
        guard await isAvailable() else {
            throw TranslationError.modelUnavailable
        }
        return try await mockClosure(prompt)
    }

    func isAvailable() async -> Bool {
        return available
    }
}

@Suite("Unit Tests")
struct UnitTestSuite {
    @Test func testSpanishToEnglishTranslationWithMockResponder() async throws {
        // Arrange: create a translator that uses a mock responder which simulates model output
        let mockResponder: @Sendable (String) async throws -> TranslationResult = { prompt in
            // Very small heuristic: if prompt contains Spanish text, return an English translation.
            if prompt.contains("Hola") {
                return TranslationResult(translatedText: "Hello", sourceLanguage: "Spanish", targetLanguage: "English")
            }
            if prompt.contains("Cómo estás") {
                return TranslationResult(translatedText: "How are you?", sourceLanguage: "Spanish", targetLanguage: "English")
            }
            return TranslationResult(translatedText: "", sourceLanguage: "", targetLanguage: "")
        }

        let translator = Translator(translationProvider: MockTranslationProvider(mockClosure: mockResponder))

        // Act
        let result = try await translator.translate(text: "Hola", from: Language.spanish, to: Language.english)

        // Assert
        #expect(result.translatedText == "Hello")
        #expect(result.sourceLanguage == "Spanish")
        #expect(result.targetLanguage == "English")
    }

    @Test func testSpanishToEnglishBatchTranslationWithMockResponder() async throws {
        // Arrange
        let originals = ["Hola", "Cómo estás"]
        let mockResponder: @Sendable (String) async throws -> TranslationResult = { prompt in
            if prompt.contains("Hola") {
                return TranslationResult(translatedText: "Hello", sourceLanguage: "Spanish", targetLanguage: "English")
            }
            if prompt.contains("Cómo estás") {
                return TranslationResult(translatedText: "How are you?", sourceLanguage: "Spanish", targetLanguage: "English")
            }
            return TranslationResult(translatedText: "", sourceLanguage: "", targetLanguage: "")
        }
        let translator = Translator(translationProvider: MockTranslationProvider(mockClosure: mockResponder))

        let results = try await translator.translateBatch(texts: originals, from: Language.spanish, to: Language.english)

        // Assert
        #expect(results.count == 2)
        #expect(results[0].translatedText == "Hello")
        #expect(results[1].translatedText == "How are you?")
    }

    @Test func testTranslateEmptyTextThrowsError() async throws {
        let mockResponder: @Sendable (String) async throws -> TranslationResult = { _ in
            return TranslationResult(translatedText: "", sourceLanguage: "", targetLanguage: "")
        }
        let translator = Translator(translationProvider: MockTranslationProvider(mockClosure: mockResponder))

        do {
            _ = try await translator.translate(text: "", from: Language.english, to: Language.spanish)
            #expect(Bool(false), "Expected TranslationError.emptyText to be thrown")
        } catch {
            #expect(error as? TranslationError == TranslationError.emptyText)
        }
    }

    @Test func testTranslateBatchEmptyArrayThrowsError() async throws {
        let mockResponder: @Sendable (String) async throws -> TranslationResult = { _ in
            return TranslationResult(translatedText: "", sourceLanguage: "", targetLanguage: "")
        }
        let translator = Translator(translationProvider: MockTranslationProvider(mockClosure: mockResponder))

        do {
            _ = try await translator.translateBatch(texts: [], from: Language.english, to: Language.spanish)
            #expect(Bool(false), "Expected TranslationError.emptyBatch to be thrown")
        } catch {
            #expect(error as? TranslationError == TranslationError.emptyBatch)
        }
    }

    @Test func testTranslateWithUnavailableModelThrowsError() async throws {
        let mockResponder: @Sendable (String) async throws -> TranslationResult = { _ in
            return TranslationResult(translatedText: "Test", sourceLanguage: "en", targetLanguage: "es")
        }
        let translator = Translator(translationProvider: MockTranslationProvider(mockClosure: mockResponder, available: false))

        do {
            _ = try await translator.translate(text: "Hello", from: Language.english, to: Language.spanish)
            #expect(Bool(false), "Expected TranslationError.modelUnavailable to be thrown")
        } catch {
            #expect(error as? TranslationError == TranslationError.modelUnavailable)
        }
    }

    @Test func testTranslationAvailability() async throws {
        let mockResponder: @Sendable (String) async throws -> TranslationResult = { _ in
            return TranslationResult(translatedText: "Test", sourceLanguage: "en", targetLanguage: "es")
        }
        
        let availableTranslator = Translator(translationProvider: MockTranslationProvider(mockClosure: mockResponder, available: true))
        let unavailableTranslator = Translator(translationProvider: MockTranslationProvider(mockClosure: mockResponder, available: false))

        #expect(await availableTranslator.isTranslationAvailable() == true)
        #expect(await unavailableTranslator.isTranslationAvailable() == false)
    }

    @Test func testAllLanguagesAccessible() async throws {
        let languages = Translator.allLanguages
        #expect(languages.count > 0)
        #expect(languages.contains(Language.english))
        #expect(languages.contains(Language.spanish))
    }

    @Test func testWithFallbackInitializer() async throws {
        let translator = Translator.withFallback()
        #expect(await translator.isTranslationAvailable() == false)
        
        do {
            _ = try await translator.translate(text: "Hello", to: Language.spanish)
            #expect(Bool(false), "Expected TranslationError.custom to be thrown")
        } catch let error as TranslationError {
            if case .custom(let message) = error {
                #expect(message == "FoundationModels is not available on this device. Please provide a custom TranslationProvider implementation.")
            } else {
                #expect(Bool(false), "Expected TranslationError.custom but got \(error)")
            }
        }
    }
}