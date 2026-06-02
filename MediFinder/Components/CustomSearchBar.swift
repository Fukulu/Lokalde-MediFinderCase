//
//  CustomSearchBar.swift
//  MediFinder
//
//  Created by Furkan Tümay on 6/1/26.
//

import SwiftUI

struct CustomSearchBar: View {
    @Binding var searchText: String
    let placeholder: String?
    let onSearchTapped: (() -> Void)?
    let animatePlaceholder: Bool
    
    @Environment(LanguageManager.self) private var languageManager
    
    // Animasyonlu placeholder için state
    @State private var currentPlaceholderIndex = 0
    @State private var isAnimating = false
    
    // Placeholder seçenekleri
    private var placeholderOptions: [(icon: String, text: String)] {
        if languageManager.currentLanguage == .english {
            return [
                ("stethoscope", "Find the right doctor for you"),
                ("cross.case.fill", "Find the right hospital for you"),
                ("pawprint.fill", "Find the nearest vet for you")
            ]
        } else {
            return [
                ("stethoscope", "Sizin için doğru doktoru bulun"),
                ("cross.case.fill", "Sizin için doğru hastaneyi bulun"),
                ("pawprint.fill", "Size en yakın veterineri bulun")
            ]
        }
    }
    
    private var currentPlaceholder: (icon: String, text: String) {
        placeholderOptions[currentPlaceholderIndex]
    }
    
    init(
        searchText: Binding<String>,
        placeholder: String? = nil,
        animatePlaceholder: Bool = true,
        onSearchTapped: (() -> Void)? = nil
    ) {
        self._searchText = searchText
        self.placeholder = placeholder
        self.animatePlaceholder = animatePlaceholder
        self.onSearchTapped = onSearchTapped
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Animated Search Icon - fixed size
            Image(systemName: animatePlaceholder && searchText.isEmpty ? currentPlaceholder.icon : "stethoscope")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.gray)
                .frame(width: 24, height: 24)  // ✅ Sabit frame
                .opacity(isAnimating && searchText.isEmpty ? 0 : 1)
                .scaleEffect(isAnimating && searchText.isEmpty ? 0.8 : 1.0)
                .animation(.easeInOut(duration: 0.3), value: isAnimating)
            
            // Text Field with Animated Placeholder
            TextField(
                animatePlaceholder && searchText.isEmpty ? currentPlaceholder.text : (placeholder ?? "Search..."),
                text: $searchText
            )
            .font(.system(size: 15))
            .foregroundColor(.primary)
            .opacity(isAnimating && searchText.isEmpty ? 0 : 1)
            .animation(.easeInOut(duration: 0.3), value: isAnimating)
            
            Spacer()
            
            // Search Button or Clear Button - fixed size
            Group {
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                    }
                } else {
                    Button(action: {
                        onSearchTapped?()
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                    }
                }
            }
            .frame(width: 24, height: 24)  // ✅ Sabit frame
        }
        .frame(height: 52)  // ✅ SearchBar sabit yükseklik
        .padding(.horizontal, 16)
        .background(Color(.systemGray6))
        .cornerRadius(22)
        .padding(.horizontal, 20)
        .onAppear {
            if animatePlaceholder {
                startPlaceholderAnimation()
            }
        }
    }
    
    // Placeholder animasyonu - sadece searchText boşken çalışır
    private func startPlaceholderAnimation() {
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            // Text doluysa animasyon yapma
            guard searchText.isEmpty else { return }
            
            withAnimation(.easeInOut(duration: 0.3)) {
                isAnimating = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                currentPlaceholderIndex = (currentPlaceholderIndex + 1) % placeholderOptions.count
                
                withAnimation(.easeInOut(duration: 0.3)) {
                    isAnimating = false
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        // Animasyonlu SearchBar (default)
        CustomSearchBar(
            searchText: .constant(""),
            animatePlaceholder: true
        )
        
        // Statik placeholder
        CustomSearchBar(
            searchText: .constant(""),
            placeholder: "Custom static placeholder",
            animatePlaceholder: false
        )
        
        // Text girili hali
        CustomSearchBar(
            searchText: .constant("Cardiology"),
            animatePlaceholder: true
        )
    }
    .padding(.vertical, 50)
    .environment(LanguageManager())
}

