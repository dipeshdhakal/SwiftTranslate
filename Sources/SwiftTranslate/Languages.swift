//
//  Languages.swift
//  SwiftTranslate
//
//  Created by Dipesh Dhakal on 10/9/2025.
//

import Foundation

/// Represents a supported language for translation.
public enum Language: String, CaseIterable {
    case english = "en"
    case french = "fr"
    case spanish = "es"
    case german = "de"
    case italian = "it"
    case portuguese = "pt"
    case russian = "ru"
    case chinese = "zh"
    case japanese = "ja"
    case korean = "ko"
    case arabic = "ar"
    case hindi = "hi"
    case dutch = "nl"
    case swedish = "sv"
    case danish = "da"
    case norwegian = "no"
    case finnish = "fi"
    case turkish = "tr"
    case polish = "pl"
    case czech = "cs"
    case hungarian = "hu"
    case greek = "el"
    case hebrew = "he"
    case thai = "th"
    case vietnamese = "vi"
    case indonesian = "id"
    case malay = "ms"
    case filipino = "tl"
    case bengali = "bn"
    case urdu = "ur"
    case marathi = "mr"
    case tamil = "ta"
    case telugu = "te"
    case kannada = "kn"
    case malayalam = "ml"
    case gujarati = "gu"
    case punjabi = "pa"
    case nepali = "ne"
    case sinhala = "si"
    case assamese = "as"
    case odia = "or"
    case bhojpuri = "bho"
    case maithili = "mai"
    case awadhi = "awa"
    case magahi = "mag"
    case abkhaz = "ab"
    case acehnese = "ace"
    case acholi = "ach"
    case afrikaans = "af"
    case albanian = "sq"
    case alur = "alz"
    case amharic = "am"
    case armenian = "hy"
    case aymara = "ay"
    case azerbaijani = "az"
    case balinese = "ban"
    case bambara = "bm"
    case bashkir = "ba"
    case basque = "eu"
    case batakKaro = "btx"
    case batakSimalungun = "bts"
    case batakToba = "bbc"
    case belarusian = "be"
    case bemba = "bem"
    case betawi = "bew"
    case bikol = "bik"
    case bosnian = "bs"
    case breton = "br"
    case bulgarian = "bg"
    case buryat = "bua"
    case cantonese = "yue"
    case catalan = "ca"
    case cebuano = "ceb"
    case chichewa = "ny"
    case chuvash = "cv"
    case corsican = "co"
    case crimeanTatar = "crh"
    case croatian = "hr"
    case dinka = "din"
    case divehi = "dv"
    case dogri = "doi"
    case dombe = "dov"
    case dzongkha = "dz"
    case esperanto = "eo"
    case estonian = "et"
    case ewe = "ee"
    case fijian = "fj"
    case frisian = "fy"
    case fulfulde = "ff"
    case ga = "gaa"
    case galician = "gl"
    case ganda = "lg"
    case georgian = "ka"
    case guarani = "gn"
    case hakhaChin = "cnh"
    case hausa = "ha"
    case hawaiian = "haw"
    case hiligaynon = "hil"
    case hmong = "hmn"
    case hunsrik = "hrx"
    case icelandic = "is"
    case igbo = "ig"
    case iloko = "ilo"
    case irish = "ga"
    case javanese = "jv"
    case kapampangan = "pam"
    case kazakh = "kk"
    case khmer = "km"
    case kiga = "cgg"
    case kinyarwanda = "rw"
    case kituba = "ktu"
    case konkani = "gom"
    case krio = "kri"
    case kurdishKurmanji = "ku"
    case kurdishSorani = "ckb"
    case kyrgyz = "ky"
    case lao = "lo"
    case latgalian = "ltg"
    case latin = "la"
    case latvian = "lv"
    case ligurian = "lij"
    case limburgan = "li"
    case lingala = "ln"
    case lithuanian = "lt"
    case lombard = "lmo"
    case luo = "luo"
    case luxembourgish = "lb"
    case macedonian = "mk"
    case makassar = "mak"
    case malagasy = "mg"
    case maltese = "mt"
    case maori = "mi"
    case meadowMari = "chm"
    case meiteilon = "mni"
    case minang = "min"
    case mizo = "lus"
    case mongolian = "mn"
    case myanmar = "my"
    case ndebeleSouth = "nr"
    case nepalbhasa = "new"
    case northernSotho = "nso"
    case nuer = "nus"
    case occitan = "oc"
    case oromo = "om"
    case pangasinan = "pag"
    case papiamento = "pap"
    case pashto = "ps"
    case persian = "fa"
    case rundi = "rn"
    case samoan = "sm"
    case sango = "sg"
    case sanskrit = "sa"
    case scotsGaelic = "gd"
    case sesotho = "st"
    case seychelloisCreole = "crs"
    case shan = "shn"
    case shona = "sn"
    case sicilian = "scn"
    case silesian = "szl"
    case sindhi = "sd"
    case slovak = "sk"
    case somali = "so"
    case sundanese = "su"
    case swati = "ss"
    case tajik = "tg"
    case tatar = "tt"
    case tetum = "tet"
    case tigrinya = "ti"
    case tsonga = "ts"
    case tswana = "tn"
    case turkmen = "tk"
    case twi = "ak"
    case uyghur = "ug"
    case uzbek = "uz"
    case welsh = "cy"
    case xhosa = "xh"
    case yiddish = "yi"
    case yoruba = "yo"
    case yucatecMaya = "yua"

    /// The display name of the language.
    public var displayName: String {
        switch self {
        case .english: return "English"
        case .french: return "French"
        case .spanish: return "Spanish"
        case .german: return "German"
        case .italian: return "Italian"
        case .portuguese: return "Portuguese"
        case .russian: return "Russian"
        case .chinese: return "Chinese"
        case .japanese: return "Japanese"
        case .korean: return "Korean"
        case .arabic: return "Arabic"
        case .hindi: return "Hindi"
        case .dutch: return "Dutch"
        case .swedish: return "Swedish"
        case .danish: return "Danish"
        case .norwegian: return "Norwegian"
        case .finnish: return "Finnish"
        case .turkish: return "Turkish"
        case .polish: return "Polish"
        case .czech: return "Czech"
        case .hungarian: return "Hungarian"
        case .greek: return "Greek"
        case .hebrew: return "Hebrew"
        case .thai: return "Thai"
        case .vietnamese: return "Vietnamese"
        case .indonesian: return "Indonesian"
        case .malay: return "Malay"
        case .filipino: return "Filipino"
        case .bengali: return "Bengali"
        case .urdu: return "Urdu"
        case .marathi: return "Marathi"
        case .tamil: return "Tamil"
        case .telugu: return "Telugu"
        case .kannada: return "Kannada"
        case .malayalam: return "Malayalam"
        case .gujarati: return "Gujarati"
        case .punjabi: return "Punjabi"
        case .nepali: return "Nepali"
        case .sinhala: return "Sinhala"
        case .assamese: return "Assamese"
        case .odia: return "Odia"
        case .bhojpuri: return "Bhojpuri"
        case .maithili: return "Maithili"
        case .awadhi: return "Awadhi"
        case .magahi: return "Magahi"
        case .abkhaz: return "Abkhaz"
        case .acehnese: return "Acehnese"
        case .acholi: return "Acholi"
        case .afrikaans: return "Afrikaans"
        case .albanian: return "Albanian"
        case .alur: return "Alur"
        case .amharic: return "Amharic"
        case .armenian: return "Armenian"
        case .aymara: return "Aymara"
        case .azerbaijani: return "Azerbaijani"
        case .balinese: return "Balinese"
        case .bambara: return "Bambara"
        case .bashkir: return "Bashkir"
        case .basque: return "Basque"
        case .batakKaro: return "Batak Karo"
        case .batakSimalungun: return "Batak Simalungun"
        case .batakToba: return "Batak Toba"
        case .belarusian: return "Belarusian"
        case .bemba: return "Bemba"
        case .betawi: return "Betawi"
        case .bikol: return "Bikol"
        case .bosnian: return "Bosnian"
        case .breton: return "Breton"
        case .bulgarian: return "Bulgarian"
        case .buryat: return "Buryat"
        case .cantonese: return "Cantonese"
        case .catalan: return "Catalan"
        case .cebuano: return "Cebuano"
        case .chichewa: return "Chichewa"
        case .chuvash: return "Chuvash"
        case .corsican: return "Corsican"
        case .crimeanTatar: return "Crimean Tatar"
        case .croatian: return "Croatian"
        case .dinka: return "Dinka"
        case .divehi: return "Divehi"
        case .dogri: return "Dogri"
        case .dombe: return "Dombe"
        case .dzongkha: return "Dzongkha"
        case .esperanto: return "Esperanto"
        case .estonian: return "Estonian"
        case .ewe: return "Ewe"
        case .fijian: return "Fijian"
        case .frisian: return "Frisian"
        case .fulfulde: return "Fulfulde"
        case .ga: return "Ga"
        case .galician: return "Galician"
        case .ganda: return "Ganda"
        case .georgian: return "Georgian"
        case .guarani: return "Guarani"
        case .hakhaChin: return "Hakha Chin"
        case .hausa: return "Hausa"
        case .hawaiian: return "Hawaiian"
        case .hiligaynon: return "Hiligaynon"
        case .hmong: return "Hmong"
        case .hunsrik: return "Hunsrik"
        case .icelandic: return "Icelandic"
        case .igbo: return "Igbo"
        case .iloko: return "Iloko"
        case .irish: return "Irish"
        case .javanese: return "Javanese"
        case .kapampangan: return "Kapampangan"
        case .kazakh: return "Kazakh"
        case .khmer: return "Khmer"
        case .kiga: return "Kiga"
        case .kinyarwanda: return "Kinyarwanda"
        case .kituba: return "Kituba"
        case .konkani: return "Konkani"
        case .krio: return "Krio"
        case .kurdishKurmanji: return "Kurdish (Kurmanji)"
        case .kurdishSorani: return "Kurdish (Sorani)"
        case .kyrgyz: return "Kyrgyz"
        case .lao: return "Lao"
        case .latgalian: return "Latgalian"
        case .latin: return "Latin"
        case .latvian: return "Latvian"
        case .ligurian: return "Ligurian"
        case .limburgan: return "Limburgan"
        case .lingala: return "Lingala"
        case .lithuanian: return "Lithuanian"
        case .lombard: return "Lombard"
        case .luo: return "Luo"
        case .luxembourgish: return "Luxembourgish"
        case .macedonian: return "Macedonian"
        case .makassar: return "Makassar"
        case .malagasy: return "Malagasy"
        case .maltese: return "Maltese"
        case .maori: return "Maori"
        case .meadowMari: return "Meadow Mari"
        case .meiteilon: return "Meiteilon"
        case .minang: return "Minang"
        case .mizo: return "Mizo"
        case .mongolian: return "Mongolian"
        case .myanmar: return "Myanmar"
        case .ndebeleSouth: return "Ndebele (South)"
        case .nepalbhasa: return "Nepalbhasa"
        case .northernSotho: return "Northern Sotho"
        case .nuer: return "Nuer"
        case .occitan: return "Occitan"
        case .oromo: return "Oromo"
        case .pangasinan: return "Pangasinan"
        case .papiamento: return "Papiamento"
        case .pashto: return "Pashto"
        case .persian: return "Persian"
        case .rundi: return "Rundi"
        case .samoan: return "Samoan"
        case .sango: return "Sango"
        case .sanskrit: return "Sanskrit"
        case .scotsGaelic: return "Scots Gaelic"
        case .sesotho: return "Sesotho"
        case .seychelloisCreole: return "Seychellois Creole"
        case .shan: return "Shan"
        case .shona: return "Shona"
        case .sicilian: return "Sicilian"
        case .silesian: return "Silesian"
        case .sindhi: return "Sindhi"
        case .slovak: return "Slovak"
        case .somali: return "Somali"
        case .sundanese: return "Sundanese"
        case .swati: return "Swati"
        case .tajik: return "Tajik"
        case .tatar: return "Tatar"
        case .tetum: return "Tetum"
        case .tigrinya: return "Tigrinya"
        case .tsonga: return "Tsonga"
        case .tswana: return "Tswana"
        case .turkmen: return "Turkmen"
        case .twi: return "Twi"
        case .uyghur: return "Uyghur"
        case .uzbek: return "Uzbek"
        case .welsh: return "Welsh"
        case .xhosa: return "Xhosa"
        case .yiddish: return "Yiddish"
        case .yoruba: return "Yoruba"
        case .yucatecMaya: return "Yucatec Maya"
        }
    }

    /// A locale-aware (translated) name for the language when possible.
    public var localisedName: String {
        switch self {
        case .english:
            return "English"
        case .french:
            return "Français"
        case .spanish:
            return "Español"
        case .german:
            return "Deutsch"
        case .italian:
            return "Italiano"
        case .portuguese:
            return "Português"
        case .russian:
            return "Русский"
        case .chinese:
            return "中文"
        case .japanese:
            return "日本語"
        case .korean:
            return "한국어"
        case .arabic:
            return "العربية"
        case .hindi:
            return "हिन्दी"
        case .dutch:
            return "Nederlands"
        case .swedish:
            return "Svenska"
        case .danish:
            return "Dansk"
        case .norwegian:
            return "Norsk"
        case .finnish:
            return "Suomi"
        case .turkish:
            return "Türkçe"
        case .polish:
            return "Polski"
        case .czech:
            return "Čeština"
        case .hungarian:
            return "Magyar"
        case .greek:
            return "Ελληνικά"
        case .hebrew:
            return "עברית"
        case .thai:
            return "ไทย"
        case .vietnamese:
            return "Tiếng Việt"
        case .indonesian:
            return "Bahasa Indonesia"
        case .malay:
            return "Bahasa Melayu"
        case .filipino:
            return "Filipino"
        case .bengali:
            return "বাংলা"
        case .urdu:
            return "اردو"
        case .marathi:
            return "मराठी"
        case .tamil:
            return "தமிழ்"
        case .telugu:
            return "తెలుగు"
        case .kannada:
            return "ಕನ್ನಡ"
        case .malayalam:
            return "മലയാളം"
        case .gujarati:
            return "ગુજરાતી"
        case .punjabi:
            return "ਪੰਜਾਬੀ"
        case .nepali:
            return "नेपाली"
        case .sinhala:
            return "සිංහල"
        case .assamese:
            return "অসমীয়া"
        case .odia:
            return "ଓଡ଼ିଆ"
        case .bhojpuri:
            return "भोजपुरी"
        case .maithili:
            return "मैथिली"
        case .awadhi:
            return "अवधी"
        case .magahi:
            return "मगही"
        case .abkhaz:
            return "Abkhaz"
        case .acehnese:
            return "Acehnese"
        case .acholi:
            return "Acholi"
        case .afrikaans:
            return "Afrikaans"
        case .albanian:
            return "Albanian"
        case .alur:
            return "Alur"
        case .amharic:
            return "Amharic"
        case .armenian:
            return "Armenian"
        case .aymara:
            return "Aymara"
        case .azerbaijani:
            return "Azerbaijani"
        case .balinese:
            return "Balinese"
        case .bambara:
            return "Bambara"
        case .bashkir:
            return "Bashkir"
        case .basque:
            return "Basque"
        case .batakKaro:
            return "Batak Karo"
        case .batakSimalungun:
            return "Batak Simalungun"
        case .batakToba:
            return "Batak Toba"
        case .belarusian:
            return "Belarusian"
        case .bemba:
            return "Bemba"
        case .betawi:
            return "Betawi"
        case .bikol:
            return "Bikol"
        case .bosnian:
            return "Bosnian"
        case .breton:
            return "Breton"
        case .bulgarian:
            return "Bulgarian"
        case .buryat:
            return "Buryat"
        case .cantonese:
            return "Cantonese"
        case .catalan:
            return "Catalan"
        case .cebuano:
            return "Cebuano"
        case .chichewa:
            return "Chichewa"
        case .chuvash:
            return "Chuvash"
        case .corsican:
            return "Corsican"
        case .crimeanTatar:
            return "Crimean Tatar"
        case .croatian:
            return "Croatian"
        case .dinka:
            return "Dinka"
        case .divehi:
            return "Divehi"
        case .dogri:
            return "Dogri"
        case .dombe:
            return "Dombe"
        case .dzongkha:
            return "Dzongkha"
        case .esperanto:
            return "Esperanto"
        case .estonian:
            return "Estonian"
        case .ewe:
            return "Ewe"
        case .fijian:
            return "Fijian"
        case .frisian:
            return "Frisian"
        case .fulfulde:
            return "Fulfulde"
        case .ga:
            return "Ga"
        case .galician:
            return "Galician"
        case .ganda:
            return "Ganda"
        case .georgian:
            return "Georgian"
        case .guarani:
            return "Guarani"
        case .hakhaChin:
            return "Hakha Chin"
        case .hausa:
            return "Hausa"
        case .hawaiian:
            return "Hawaiian"
        case .hiligaynon:
            return "Hiligaynon"
        case .hmong:
            return "Hmong"
        case .hunsrik:
            return "Hunsrik"
        case .icelandic:
            return "Icelandic"
        case .igbo:
            return "Igbo"
        case .iloko:
            return "Iloko"
        case .irish:
            return "Irish"
        case .javanese:
            return "Javanese"
        case .kapampangan:
            return "Kapampangan"
        case .kazakh:
            return "Kazakh"
        case .khmer:
            return "Khmer"
        case .kiga:
            return "Kiga"
        case .kinyarwanda:
            return "Kinyarwanda"
        case .kituba:
            return "Kituba"
        case .konkani:
            return "Konkani"
        case .krio:
            return "Krio"
        case .kurdishKurmanji:
            return "Kurdish (Kurmanji)"
        case .kurdishSorani:
            return "Kurdish (Sorani)"
        case .kyrgyz:
            return "Kyrgyz"
        case .lao:
            return "Lao"
        case .latgalian:
            return "Latgalian"
        case .latin:
            return "Latin"
        case .latvian:
            return "Latvian"
        case .ligurian:
            return "Ligurian"
        case .limburgan:
            return "Limburgan"
        case .lingala:
            return "Lingala"
        case .lithuanian:
            return "Lithuanian"
        case .lombard:
            return "Lombard"
        case .luo:
            return "Luo"
        case .luxembourgish:
            return "Luxembourgish"
        case .macedonian:
            return "Macedonian"
        case .makassar:
            return "Makassar"
        case .malagasy:
            return "Malagasy"
        case .maltese:
            return "Maltese"
        case .maori:
            return "Maori"
        case .meadowMari:
            return "Meadow Mari"
        case .meiteilon:
            return "Meiteilon"
        case .minang:
            return "Minang"
        case .mizo:
            return "Mizo"
        case .mongolian:
            return "Mongolian"
        case .myanmar:
            return "Myanmar"
        case .ndebeleSouth:
            return "Ndebele (South)"
        case .nepalbhasa:
            return "Nepalbhasa"
        case .northernSotho:
            return "Northern Sotho"
        case .nuer:
            return "Nuer"
        case .occitan:
            return "Occitan"
        case .oromo:
            return "Oromo"
        case .pangasinan:
            return "Pangasinan"
        case .papiamento:
            return "Papiamento"
        case .pashto:
            return "Pashto"
        case .persian:
            return "Persian"
        case .rundi:
            return "Rundi"
        case .samoan:
            return "Samoan"
        case .sango:
            return "Sango"
        case .sanskrit:
            return "Sanskrit"
        case .scotsGaelic:
            return "Scots Gaelic"
        case .sesotho:
            return "Sesotho"
        case .seychelloisCreole:
            return "Seychellois Creole"
        case .shan:
            return "Shan"
        case .shona:
            return "Shona"
        case .sicilian:
            return "Sicilian"
        case .silesian:
            return "Silesian"
        case .sindhi:
            return "Sindhi"
        case .slovak:
            return "Slovak"
        case .somali:
            return "Somali"
        case .sundanese:
            return "Sundanese"
        case .swati:
            return "Swati"
        case .tajik:
            return "Tajik"
        case .tatar:
            return "Tatar"
        case .tetum:
            return "Tetum"
        case .tigrinya:
            return "Tigrinya"
        case .tsonga:
            return "Tsonga"
        case .tswana:
            return "Tswana"
        case .turkmen:
            return "Turkmen"
        case .twi:
            return "Twi"
        case .uyghur:
            return "Uyghur"
        case .uzbek:
            return "Uzbek"
        case .welsh:
            return "Welsh"
        case .xhosa:
            return "Xhosa"
        case .yiddish:
            return "Yiddish"
        case .yoruba:
            return "Yoruba"
        case .yucatecMaya:
            return "Yucatec Maya"
        }
    }
}
