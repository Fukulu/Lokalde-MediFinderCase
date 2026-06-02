//
//  MediFinderApp.swift
//  MediFinder
//
//  Created by Furkan Tümay on 6/1/26.
//

import SwiftUI

@main
struct MediFinderApp: App {
    // State management
    @State private var languageManager = LanguageManager()
    @State private var providerViewModel = ProviderViewModel()
    
    // Dil değiştiğinde tüm view'ı yeniden oluşturmak için
    @State private var localeID = UUID()
    
    init() {
        // ViewModel'e LanguageManager'ı bağla
        _providerViewModel = State(initialValue: ProviderViewModel())
    }
    
    var body: some Scene {
        WindowGroup {
            HomePage()
                .environment(languageManager)
                .environment(providerViewModel)
                .environment(\.locale, languageManager.currentLanguage.locale)
                .id(localeID) // Force view refresh on language change
                .onAppear {
                    // Dil değiştiğinde callback
                    languageManager.onLanguageChanged = {
                        localeID = UUID()
                        // Provider'ları yeniden yükle
                        providerViewModel.loadProviders()
                    }
                }
        }
    }
}
