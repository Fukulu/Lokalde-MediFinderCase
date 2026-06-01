//
//  LanguageManager.swift
//  MediFinder
//
//  Created by Furkan Tümay on 6/1/26.
//

import Foundation
import SwiftUI

enum AppLanguage: String, CaseIterable {
    case english = "en"
    case turkish = "tr"
    
    var displayName: String {
        switch self {
        case .english:
            return "English"
        case .turkish:
            return "Türkçe"
        }
    }
    
    var flag: String {
        switch self {
        case .english:
            return "🇬🇧"
        case .turkish:
            return "🇹🇷"
        }
    }
    
    var locale: Locale {
        Locale(identifier: rawValue)
    }
}

@Observable
class LanguageManager {
    static let shared = LanguageManager()
    
    var currentLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set([currentLanguage.rawValue], forKey: "AppleLanguages")
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "AppLanguage")
            UserDefaults.standard.synchronize()
        }
    }
    
    private init() {
        // Load saved language or default to English
        if let savedLanguage = UserDefaults.standard.string(forKey: "AppLanguage"),
           let language = AppLanguage(rawValue: savedLanguage) {
            self.currentLanguage = language
        } else {
            self.currentLanguage = .english
        }
    }
    
    func setLanguage(_ language: AppLanguage) {
        currentLanguage = language
    }
    
    // JSON file suffix based on language (uppercase for backward compatibility)
    var jsonSuffix: String {
        currentLanguage.rawValue.uppercased()
    }
}

