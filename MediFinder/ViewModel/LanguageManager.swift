//
//  LanguageManager.swift
//  MediFinder
//
//  Created by Furkan Tümay on 6/1/26.
//

import Foundation
import SwiftUI

enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case turkish = "tr"
    
    var id: String { rawValue }
    
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
    
    var jsonSuffix: String {
        rawValue.uppercased()
    }
}

@Observable
class LanguageManager {
    
    var currentLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "AppLanguage")
            UserDefaults.standard.synchronize()
            onLanguageChanged?()
        }
    }
    
    var onLanguageChanged: (() -> Void)?
    
    init() {
        // UserDefaults'tan direkt oku (AppStorage yerine)
        let savedLanguageCode = UserDefaults.standard.string(forKey: "AppLanguage")
        
        // Daha önce kaydedilmiş dil var mı?
        if let savedLanguageCode = savedLanguageCode,
           let savedLanguage = AppLanguage(rawValue: savedLanguageCode) {
            self.currentLanguage = savedLanguage
        } else {
            // Cihaz dilini kontrol et
            let deviceLanguage = Locale.current.language.languageCode?.identifier ?? "en"
            
            // Desteklenen diller arasında var mı?
            if let matchedLanguage = AppLanguage(rawValue: deviceLanguage) {
                self.currentLanguage = matchedLanguage
            } else {
                // Varsayılan olarak İngilizce
                self.currentLanguage = .english
            }
            
            // İlk açılışta kaydedelim
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "AppLanguage")
            UserDefaults.standard.synchronize()
        }
    }
    
    func setLanguage(_ language: AppLanguage) {
        currentLanguage = language
    }
}
