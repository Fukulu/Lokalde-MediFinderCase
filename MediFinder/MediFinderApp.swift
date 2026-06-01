//
//  MediFinderApp.swift
//  MediFinder
//
//  Created by Furkan Tümay on 6/1/26.
//

import SwiftUI

@main
struct MediFinderApp: App {
    @State private var languageManager = LanguageManager.shared
    
    var body: some Scene {
        WindowGroup {
            HomePage()
                .environment(\.locale, languageManager.currentLanguage.locale)
                .id(languageManager.currentLanguage) // Force view refresh on language change
        }
    }
}
