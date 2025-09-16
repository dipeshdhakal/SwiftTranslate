import Testing
import Foundation
@testable import SwiftTranslate

class MockTranslationProvider: TranslationProvider {
    let mockClosure: (String) async throws -> TranslationResult
    let available: Bool

    init(mockClosure: @escaping (String) async throws -> TranslationResult, available: Bool = true) {
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
        let mockResponder: (String) async throws -> TranslationResult = { prompt in
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
        let result = try await translator.translate(text: "Hola", from: .spanish, to: .english)

        // Assert
        #expect(result.translatedText == "Hello")
        #expect(result.sourceLanguage == "Spanish")
        #expect(result.targetLanguage == "English")
    }


    @Test func testSpanishBatchTranslationWithMockResponder() async throws {
        let mockResponder: (String) async throws -> TranslationResult = { prompt in
            if prompt.contains("Hola") { return TranslationResult(translatedText: "Hello", sourceLanguage: "Spanish", targetLanguage: "English") }
            if prompt.contains("Cómo estás") { return TranslationResult(translatedText: "How are you?", sourceLanguage: "Spanish", targetLanguage: "English") }
            return TranslationResult(translatedText: "", sourceLanguage: "", targetLanguage: "")
        }

        let translator = Translator(translationProvider: MockTranslationProvider(mockClosure: mockResponder))
        let originals = ["Hola", "Cómo estás"]
        let results = try await translator.translateBatch(texts: originals, from: .spanish, to: .english)

        #expect(results.count == 2)
        #expect(results[0].translatedText == "Hello")
        #expect(results[1].translatedText == "How are you?")
    }

    @Test func testPortugueseToEnglishTranslationWithMockResponder() async throws {
        // Arrange: create a translator that uses a mock responder which simulates model output
        let mockResponder: (String) async throws -> TranslationResult = { prompt in
            // Very small heuristic: if prompt contains Portuguese text, return an English translation.
            if prompt.contains("Olá") {
                return TranslationResult(translatedText: "Hello", sourceLanguage: "Portuguese", targetLanguage: "English")
            }
            if prompt.contains("Como você está") {
                return TranslationResult(translatedText: "How are you?", sourceLanguage: "Portuguese", targetLanguage: "English")
            }
            return TranslationResult(translatedText: "", sourceLanguage: "", targetLanguage: "")
        }

        let translator = Translator(translationProvider: MockTranslationProvider(mockClosure: mockResponder))

        // Act
        let result = try await translator.translate(text: "Olá", from: .portuguese, to: .english)

        // Assert
        #expect(result.translatedText == "Hello")
        #expect(result.sourceLanguage == "Portuguese")
        #expect(result.targetLanguage == "English")
    }


    @Test func testPortugueseBatchTranslationWithMockResponder() async throws {
        let mockResponder: (String) async throws -> TranslationResult = { prompt in
            if prompt.contains("Olá") { return TranslationResult(translatedText: "Hello", sourceLanguage: "Portuguese", targetLanguage: "English") }
            if prompt.contains("Como você está") { return TranslationResult(translatedText: "How are you?", sourceLanguage: "Portuguese", targetLanguage: "English") }
            return TranslationResult(translatedText: "", sourceLanguage: "", targetLanguage: "")
        }

        let translator = Translator(translationProvider: MockTranslationProvider(mockClosure: mockResponder))
        let originals = ["Olá", "Como você está"]
        let results = try await translator.translateBatch(texts: originals, from: .portuguese, to: .english)

        #expect(results.count == 2)
        #expect(results[0].translatedText == "Hello")
        #expect(results[1].translatedText == "How are you?")
    }


    @Test func testTranslatorInitWithDefaultValues() async throws {
        _ = Translator()
    }

    @Test func testTranslatorInitWithCustomInstructions() async throws {
        let customInstructions = "Custom translation instructions"
        _ = Translator(instructions: customInstructions)
    }

    @Test func testTranslatorInitWithCustomTranslationProvider() async throws {
        let mockResponder: (String) async throws -> TranslationResult = { _ in TranslationResult(translatedText: "Mock response", sourceLanguage: "English", targetLanguage: "Spanish") }
        _ = Translator(translationProvider: MockTranslationProvider(mockClosure: mockResponder))
    }

    @Test func testTranslatorInitWithBothCustomInstructionsAndTranslationProvider() async throws {
        let customInstructions = "Custom instructions"
        let mockResponder: (String) async throws -> TranslationResult = { _ in TranslationResult(translatedText: "Mock response", sourceLanguage: "English", targetLanguage: "Spanish") }
        _ = Translator(instructions: customInstructions, translationProvider: MockTranslationProvider(mockClosure: mockResponder))
    }

    @Test func testTranslateEmptyTextThrowsError() async throws {
        let mockResponder: (String) async throws -> TranslationResult = { _ in TranslationResult(translatedText: "Response", sourceLanguage: "English", targetLanguage: "Spanish") }
        let translator = Translator(translationProvider: MockTranslationProvider(mockClosure: mockResponder))
        
        do {
            _ = try await translator.translate(text: "", from: .english, to: .spanish)
            #expect(Bool(false), "Expected emptyText error")
        } catch TranslationError.emptyText {
            #expect(Bool(true))
        } catch {
            #expect(Bool(false), "Unexpected error: \(error)")
        }
    }

    @Test func testTranslateBatchEmptyArrayThrowsError() async throws {
        let mockResponder: (String) async throws -> TranslationResult = { _ in TranslationResult(translatedText: "Response", sourceLanguage: "English", targetLanguage: "Spanish") }
        let translator = Translator(translationProvider: MockTranslationProvider(mockClosure: mockResponder))
        
        do {
            _ = try await translator.translateBatch(texts: [], from: .english, to: .spanish)
            #expect(Bool(false), "Expected emptyBatch error")
        } catch TranslationError.emptyBatch {
            #expect(Bool(true))
        } catch {
            #expect(Bool(false), "Unexpected error: \(error)")
        }
    }

    @Test func testTranslateBatchWithEmptyTextThrowsError() async throws {
        let mockResponder: (String) async throws -> TranslationResult = { _ in TranslationResult(translatedText: "Response", sourceLanguage: "English", targetLanguage: "Spanish") }
        let translator = Translator(translationProvider: MockTranslationProvider(mockClosure: mockResponder))
        
        do {
            _ = try await translator.translateBatch(texts: ["Hello", ""], from: .english, to: .spanish)
            #expect(Bool(false), "Expected emptyText error")
        } catch TranslationError.emptyText {
            #expect(Bool(true))
        } catch {
            #expect(Bool(false), "Unexpected error: \(error)")
        }
    }

    @Test func testTranslateWithResponderThrowingError() async throws {
        let mockResponder: (String) async throws -> TranslationResult = { _ in throw NSError(domain: "Test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Test error"]) }
        let translator = Translator(translationProvider: MockTranslationProvider(mockClosure: mockResponder))
        
        do {
            _ = try await translator.translate(text: "Hello", from: .english, to: .spanish)
            #expect(Bool(false), "Expected error from responder")
        } catch {
            #expect(Bool(true)) // Any error is fine
        }
    }

    @Test func testTranslateBatchWithResponderThrowingError() async throws {
        let mockResponder: (String) async throws -> TranslationResult = { _ in throw NSError(domain: "Test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Test error"]) }
        let translator = Translator(translationProvider: MockTranslationProvider(mockClosure: mockResponder))
        
        do {
            _ = try await translator.translateBatch(texts: ["Hello"], from: .english, to: .spanish)
            #expect(Bool(false), "Expected error from responder")
        } catch {
            #expect(Bool(true))
        }
    }

    @Test func testTranslationErrorDescriptions() async throws {
        #expect(TranslationError.emptyText.errorDescription == "The input text cannot be empty.")
        #expect(TranslationError.emptyBatch.errorDescription == "The batch of texts cannot be empty.")
        #expect(TranslationError.modelUnavailable.errorDescription == "No translation model is available. Inject a translationProvider when creating Translator for tests or ensure FoundationModels is available at runtime.")
    }

    @Test func testFrenchToEnglishTranslationWithMockResponder() async throws {
        let mockResponder: (String) async throws -> TranslationResult = { prompt in
            if prompt.contains("Bonjour") {
                return TranslationResult(translatedText: "Hello", sourceLanguage: "French", targetLanguage: "English")
            }
            return TranslationResult(translatedText: "", sourceLanguage: "", targetLanguage: "")
        }
        
        let translator = Translator(translationProvider: MockTranslationProvider(mockClosure: mockResponder))
        let result = try await translator.translate(text: "Bonjour", from: .french, to: .english)
        #expect(result.translatedText == "Hello")
    }

    @Test func testGermanToEnglishTranslationWithMockResponder() async throws {
        let mockResponder: (String) async throws -> TranslationResult = { prompt in
            if prompt.contains("Hallo") {
                return TranslationResult(translatedText: "Hello", sourceLanguage: "German", targetLanguage: "English")
            }
            return TranslationResult(translatedText: "", sourceLanguage: "", targetLanguage: "")
        }
        
        let translator = Translator(translationProvider: MockTranslationProvider(mockClosure: mockResponder))
        let result = try await translator.translate(text: "Hallo", from: .german, to: .english)
        #expect(result.translatedText == "Hello")
    }

    @Test func testTranslateWithNilSourceLanguage() async throws {
        let mockResponder: (String) async throws -> TranslationResult = { prompt in
            if prompt.contains("Bonjour") {
                return TranslationResult(translatedText: "Hello", sourceLanguage: "French", targetLanguage: "English")
            }
            return TranslationResult(translatedText: "", sourceLanguage: "", targetLanguage: "")
        }
        
        let translator = Translator(translationProvider: MockTranslationProvider(mockClosure: mockResponder))
        let result = try await translator.translate(text: "Bonjour", from: nil, to: .english)
        #expect(result.translatedText == "Hello")
        #expect(result.sourceLanguage == "French")
        #expect(result.targetLanguage == "English")
    }

    @Test func testTranslateWithUnavailableModelThrowsError() async throws {
        // Create a mock provider that is unavailable
        let unavailableProvider = MockTranslationProvider(
            mockClosure: { _ in TranslationResult(translatedText: "Mock", sourceLanguage: "en", targetLanguage: "es") },
            available: false
        )
        
        let translator = Translator(translationProvider: unavailableProvider)
        
        do {
            _ = try await translator.translate(text: "Hello", from: .english, to: .spanish)
            #expect(Bool(false), "Expected modelUnavailable error")
        } catch TranslationError.modelUnavailable {
            #expect(Bool(true))
        } catch {
            #expect(Bool(false), "Unexpected error: \(error)")
        }
    }
}
