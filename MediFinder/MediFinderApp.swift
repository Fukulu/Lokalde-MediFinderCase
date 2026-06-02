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
    
    @State private var showSplash: Bool = true
    
    init() {
        // ViewModel'e LanguageManager'ı bağla
        _providerViewModel = State(initialValue: ProviderViewModel())
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if showSplash {
                    SplashScreenView()
                        .transition(.opacity)
                } else {
                    HomePage()
                        .transition(.opacity)
                }
            }
            .environment(languageManager)
            .environment(providerViewModel)
            .environment(\.locale, languageManager.currentLanguage.locale)
            .id(localeID)
            .onAppear {
                languageManager.onLanguageChanged = {
                    localeID = UUID()
                    providerViewModel.loadProviders()
                }
                // Hide splash after 2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showSplash = false
                    }
                }
            }
        }
    }
}
