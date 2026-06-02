//
//  HomePage.swift
//  MediFinder
//
//  Created by Furkan Tümay on 6/1/26.
//

import SwiftUI

struct HomePage: View {
    // Environment Objects
    @Environment(LanguageManager.self) private var languageManager
    @Environment(ProviderViewModel.self) private var viewModel
    
    // Tab state
    @State private var selectedTab: AppTab = .doctor
    
    // Filter dropdown state
    @State private var showFilterDropdown = false
    @State private var activeFilter: FilterType?
    @State private var filterOptions: [String] = []
    
    // Settings state
    @State private var showSettings = false
    
    // Detail page navigation
    @State private var selectedProvider: Provider?
    @State private var selectedProviderImage: String?
    
    var body: some View {
        // @Bindable wrapper ile viewModel'i sarmala
        @Bindable var bindableViewModel = viewModel
        
        ZStack(alignment: .bottom) {
            // Main Content
            VStack(spacing: 6) {
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
                    searchText: $bindableViewModel.searchText,
                    animatePlaceholder: true
                )
                
                // Filter Chips Bar
                FilterChipsBar(
                    selectedCategory: viewModel.selectedCategory,
                    selectedFilters: $bindableViewModel.selectedFilters,
                    onFilterTap: { filter in
                        print("🎯 Filter tapped: \(filter.displayName)")
                        activeFilter = filter
                        
                        // Options'ı önceden hazırla
                        filterOptions = viewModel.getUniqueValues(for: filter)
                        print("📦 Prepared \(filterOptions.count) options")
                        
                        // Sheet'i aç
                        showFilterDropdown = true
                    }
                )
                
                // Provider Grid with Pagination
                ScrollView {
                    if viewModel.isLoading {
                        // Initial Loading State
                        VStack(spacing: 20) {
                            Spacer()
                            ProgressView()
                                .scaleEffect(1.5)
                            Text("Loading...")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, minHeight: 400)
                        
                    } else if let errorMessage = viewModel.errorMessage {
                        // Error State
                        VStack(spacing: 20) {
                            Spacer()
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 60))
                                .foregroundColor(.red.opacity(0.5))
                            
                            Text("Error")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            Text(errorMessage)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                            
                            Button(action: {
                                viewModel.loadProviders()
                            }) {
                                Text("Retry")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 12)
                                    .background(Color.blue)
                                    .cornerRadius(25)
                            }
                            .padding(.top, 10)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, minHeight: 400)
                        
                    } else if viewModel.filteredProviders.isEmpty {
                        // Empty State
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
                            
                            if !viewModel.selectedFilters.isEmpty || !viewModel.searchText.isEmpty {
                                Button(action: {
                                    viewModel.clearAllFilters()
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
                        .frame(maxWidth: .infinity, minHeight: 400)
                        
                    } else {
                        // Content State with Pagination
                        VStack(spacing: 0) {
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 15),
                                GridItem(.flexible(), spacing: 15)
                            ], spacing: 15) {
                                ForEach(Array(viewModel.filteredProviders.enumerated()), id: \.element.id) { index, provider in
                                    // Grid Card - providerImage'ı provider tipine göre hesapla
                                    let imageName = getRandomImage(for: index, providerType: provider.providerType)
                                    
                                    ProviderGridCard(
                                        providerName: provider.name,
                                        category: provider.category,
                                        city: provider.city,
                                        rating: provider.rating,
                                        providerType: provider.providerType,
                                        index: index,
                                        providerImage: imageName
                                    )
                                    .onTapGesture {
                                        print("🔘 Provider tapped: \(provider.name)")
                                        selectedProviderImage = imageName
                                        selectedProvider = provider
                                    }
                                    .onAppear {
                                        // Scroll ile son 2 item'e gelince bir sonraki sayfayı yükle
                                        if index == viewModel.filteredProviders.count - 2 {
                                            viewModel.loadNextPage()
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                            
                            // Loading More Indicator
                            if viewModel.isLoadingMore {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                        .scaleEffect(1.2)
                                        .padding(.vertical, 20)
                                    Spacer()
                                }
                                .transition(.opacity)
                                .animation(.easeInOut(duration: 0.2), value: viewModel.isLoadingMore)
                            }
                            
                            // Bottom padding for tab bar
                            Color.clear
                                .frame(height: 120)
                        }
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
        .onAppear {
            // İlk açılışta dili ViewModel'e aktar
            viewModel.currentLanguage = languageManager.currentLanguage
            viewModel.loadProviders()
        }
        .onChange(of: activeFilter) { oldValue, newValue in
            // activeFilter değiştiğinde options'ı güncelle
            if let filter = newValue {
                filterOptions = viewModel.getUniqueValues(for: filter)
                print("🔄 Options updated via onChange: \(filterOptions.count) items")
            }
        }
        .sheet(isPresented: $showFilterDropdown) {
            if let filter = activeFilter {
                FilterDropdown(
                    title: filter.displayText,
                    options: filterOptions,
                    selectedValue: $bindableViewModel.selectedFilters[filter],
                    onSelect: { value in
                        if let value = value {
                            viewModel.selectedFilters[filter] = value
                        } else {
                            viewModel.selectedFilters.removeValue(forKey: filter)
                        }
                    }
                )
                .presentationDetents([.height(600), .large])
                .presentationDragIndicator(.visible)
            }
        }
        .sheet(item: $selectedProvider) { provider in
            ProviderDetailView(
                provider: provider,
                providerImage: selectedProviderImage
            )
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
    
    // MARK: - Helper Functions
    
    // Tab seçimine göre kategoriyi güncelle
    private func updateCategoryFromTab(_ tab: AppTab) {
        switch tab {
        case .doctor:
            viewModel.selectedCategory = .doctor
        case .hospital:
            viewModel.selectedCategory = .hospital
        case .vet:
            viewModel.selectedCategory = .vet
        }
    }
    
    // Provider tipine göre rastgele resim ismi getir
    private func getRandomImage(for index: Int, providerType: ProviderGridCard.ProviderType) -> String? {
        let imageNames: [String]
        
        switch providerType {
        case .doctor:
            imageNames = ["doc1", "doc2", "doc3", "doc4", "doc5"]
        case .hospital:
            imageNames = ["hosp1", "hosp2", "hosp3", "hosp4", "hosp5"]
        case .vet:
            imageNames = ["vet1", "vet2", "vet3", "vet4", "vet5"]
        }
        
        return imageNames[index % imageNames.count]
    }
}

#Preview {
    HomePage()
        .environment(LanguageManager())
        .environment(ProviderViewModel())
}
