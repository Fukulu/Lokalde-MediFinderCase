//
//  HomePage.swift
//  MediFinder
//
//  Created by Furkan Tümay on 6/1/26.
//

import SwiftUI

struct HomePage: View {
    // Language Manager
    var languageManager = LanguageManager.shared
    
    // Tab state
    @State private var selectedTab: AppTab = .doctor
    
    // Category state (Doctor/Hospital/Vet)
    @State private var selectedCategory: ProviderCategory = .doctor
    
    // Search & Filter states
    @State private var searchText: String = ""
    @State private var selectedFilters: [FilterType: String] = [:]
    
    // Filter dropdown state
    @State private var showFilterDropdown = false
    @State private var activeFilter: FilterType?
    @State private var filterOptions: [String] = []
    
    // Settings state
    @State private var showSettings = false
    
    // Data
    @State private var allProviders: [Provider] = []
    @State private var filteredProviders: [Provider] = []
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main Content
            VStack(spacing: 16) {
                // Navigation Bar
                CustomNavigationBar(
                    profileImage: "furkan",
                    userName: "Furkan Tümay",
                    onSettingsTapped: {
                        showSettings = true
                    }
                )
                
                // Search Bar
                CustomSearchBar(
                    searchText: $searchText,
                    animatePlaceholder: true
                )
                .onChange(of: searchText) { oldValue, newValue in
                    applyFilters()
                }
                
                // Filter Chips Bar
                FilterChipsBar(
                    selectedCategory: selectedCategory,
                    selectedFilters: $selectedFilters,
                    onFilterTap: { filter in
                        print("🎯 Filter tapped: \(filter.displayName)")
                        activeFilter = filter
                        
                        // Options'ı önceden hazırla
                        filterOptions = FilterOptions.getOptions(for: filter, category: selectedCategory)
                        print("📦 Prepared \(filterOptions.count) options")
                        
                        // Sheet'i aç
                        showFilterDropdown = true
                    }
                )
                
                // Provider Grid
                ScrollView {
                    if filteredProviders.isEmpty {
                        // Boş Sonuç Placeholder
                        VStack(spacing: 20) {
                            Spacer()
                            
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 60))
                                .foregroundColor(.gray.opacity(0.5))
                            
                            Text("No Results Found")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            Text("Try adjusting your filters or search term")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                            
                            if !selectedFilters.isEmpty {
                                Button(action: {
                                    selectedFilters.removeAll()
                                }) {
                                    Text("Clear All Filters")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 30)
                                        .padding(.vertical, 12)
                                        .background(Color.blue)
                                        .cornerRadius(25)
                                }
                                .padding(.top, 10)
                            }
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 100)
                    } else {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 15),
                            GridItem(.flexible(), spacing: 15)
                        ], spacing: 15) {
                            ForEach(Array(filteredProviders.enumerated()), id: \.element.id) { index, provider in
                                ProviderGridCard(
                                    providerName: provider.name,
                                    category: provider.category,
                                    city: provider.city,
                                    rating: provider.rating,
                                    providerType: provider.providerType,
                                    index: index,
                                    providerImage: nil // Random image kullanılacak
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100) // Tab bar için space
                    }
                }
            }
            
            // Floating Tab Bar
            FloatingTabBar(selectedTab: $selectedTab)
                .onChange(of: selectedTab) { oldValue, newValue in
                    updateCategoryFromTab(newValue)
                }
        }
        .ignoresSafeArea(.keyboard)
        .onChange(of: activeFilter) { oldValue, newValue in
            // activeFilter değiştiğinde options'ı güncelle
            if let filter = newValue {
                filterOptions = FilterOptions.getOptions(for: filter, category: selectedCategory)
                print("🔄 Options updated via onChange: \(filterOptions.count) items")
            }
        }
        .sheet(isPresented: $showFilterDropdown) {
            if let filter = activeFilter {
                FilterDropdown(
                    title: String(localized: "Select") + " " + filter.displayName,
                    options: filterOptions,
                    selectedValue: $selectedFilters[filter],
                    onSelect: { value in
                        if let value = value {
                            selectedFilters[filter] = value
                        } else {
                            selectedFilters.removeValue(forKey: filter)
                        }
                        applyFilters()
                    }
                )
                .presentationDetents([.height(600), .large])
                .presentationDragIndicator(.visible)
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .onAppear {
            loadProviders()
        }
        .onChange(of: selectedCategory) { oldValue, newValue in
            // Kategori değişince filtreleri temizle ve yeni data yükle
            selectedFilters.removeAll()
            searchText = ""
            loadProviders()
        }
        .onChange(of: selectedFilters) { oldValue, newValue in
            applyFilters()
        }
        .onChange(of: languageManager.currentLanguage) { oldValue, newValue in
            // Dil değişince data'yı yeniden yükle
            loadProviders()
        }
    }
    
    // MARK: - Helper Functions
    
    // Tab seçimine göre kategoriyi güncelle
    private func updateCategoryFromTab(_ tab: AppTab) {
        switch tab {
        case .doctor:
            selectedCategory = .doctor
        case .hospital:
            selectedCategory = .hospital
        case .vet:
            selectedCategory = .vet
        }
    }
    
    // Provider'ları yükle
    private func loadProviders() {
        allProviders = ProviderService.shared.loadProviders(category: selectedCategory)
        applyFilters()
    }
    
    // Filtreleri uygula
    private func applyFilters() {
        filteredProviders = ProviderService.shared.filterProviders(
            allProviders,
            by: selectedFilters,
            searchText: searchText
        )
    }
}

#Preview {
    HomePage()
}
