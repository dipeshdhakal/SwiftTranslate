import Testing
import Foundation
@testable import SwiftTranslate

@Test func testAllLanguages() async throws {
    let languages = Translator.allLanguages
    #expect(!languages.isEmpty)
    #expect(languages.contains(.english))
    #expect(languages.contains(.french))
    #expect(languages.contains(.spanish))
    #expect(languages.contains(.portuguese))
}

@Test func testLanguageDisplayNames() async throws {
    #expect(Language.english.displayName == "English")
    #expect(Language.french.displayName == "French")
    #expect(Language.spanish.displayName == "Spanish")
    #expect(Language.portuguese.displayName == "Portuguese")
}

@Test func testLanguageLocalisedNames() async throws {
    #expect(Language.english.localisedName == "English")
    #expect(Language.french.localisedName == "Français")
    #expect(Language.spanish.localisedName == "Español")
    #expect(Language.german.localisedName == "Deutsch")
    #expect(Language.japanese.localisedName == "日本語")
    #expect(Language.chinese.localisedName == "中文")
}

@Test func testLanguageRawValues() async throws {
    #expect(Language.english.rawValue == "en")
    #expect(Language.french.rawValue == "fr")
    #expect(Language.spanish.rawValue == "es")
    #expect(Language.portuguese.rawValue == "pt")
}

@Test func testAllLanguagesCount() async throws {
    let count = Language.allCases.count
    #expect(count == 179) // Total languages including all added from Google Translate
}
