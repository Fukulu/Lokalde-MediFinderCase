//
//  ProviderViewModel.swift
//  MediFinder
//
//  Created by Furkan Tümay on 6/1/26.
//

import Foundation
import Observation

@Observable
class ProviderViewModel {
    
    // MARK: - Published Properties
    
    /// Tüm provider'lar (JSON'dan yüklenen orijinal data)
    private var allProviders: [Provider] = []
    
    /// Tüm filtrelenmiş provider'lar (pagination öncesi)
    private var allFilteredProviders: [Provider] = []
    
    /// Ekranda gösterilen provider'lar (pagination ile)
    private(set) var filteredProviders: [Provider] = []
    
    /// Aktif filtreler
    var selectedFilters: [FilterType: String] = [:] {
        didSet {
            print("🔄 Filters changed: \(selectedFilters)")
            applyFilters()
        }
    }
    
    /// Arama metni
    var searchText: String = "" {
        didSet {
            print("🔍 Search text changed: '\(searchText)'")
            applyFilters()
        }
    }
    
    /// Seçili kategori (Doctor/Hospital/Vet)
    var selectedCategory: ProviderCategory = .doctor {
        didSet {
            print("📋 Category changed: \(selectedCategory.rawValue)")
            // Kategori değişince filtreleri temizle ve yeni data yükle
            selectedFilters.removeAll()
            searchText = ""
            resetPagination()
            loadProviders()
        }
    }
    
    /// Yükleme durumu
    var isLoading: Bool = false
    
    /// Pagination yükleme durumu
    var isLoadingMore: Bool = false
    
    /// Hata mesajı
    var errorMessage: String?
    
    /// Dil referansı (environment'dan inject edilecek)
    var currentLanguage: AppLanguage = .english
    
    // MARK: - Pagination Properties
    
    /// Sayfa başına kaç item gösterilecek
    private let itemsPerPage: Int = 6
    
    /// Şu an kaç item gösteriliyor
    private var currentlyLoadedCount: Int = 0
    
    /// Daha fazla item var mı?
    var hasMoreItems: Bool {
        currentlyLoadedCount < allFilteredProviders.count
    }
    
    // MARK: - Initialization
    
    init() {
        // İlk yükleme onAppear'da yapılacak
    }
    
    // MARK: - Public Methods
    
    /// Provider'ları JSON'dan yükle
    func loadProviders() {
        isLoading = true
        errorMessage = nil
        
        let fileName: String
        
        switch selectedCategory {
        case .doctor:
            fileName = "doctor_list_\(currentLanguage.jsonSuffix)"
        case .hospital:
            fileName = "hospital_list_\(currentLanguage.jsonSuffix)"
        case .vet:
            fileName = "vet_list_\(currentLanguage.jsonSuffix)"
        }
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("❌ JSON file not found: \(fileName).json")
            errorMessage = "Data file not found"
            isLoading = false
            allProviders = []
            allFilteredProviders = []
            filteredProviders = []
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let providers = try JSONDecoder().decode([Provider].self, from: data)
            print("✅ Loaded \(providers.count) providers from \(fileName).json")
            
            allProviders = providers
            applyFilters()
            isLoading = false
        } catch {
            print("❌ Error decoding JSON: \(error)")
            print("   File: \(fileName).json")
            errorMessage = "Failed to load data: \(error.localizedDescription)"
            isLoading = false
            allProviders = []
            allFilteredProviders = []
            filteredProviders = []
        }
    }
    
    /// Filtreleri uygula
    func applyFilters() {
        var filtered = allProviders
        
        print("🔍 Starting filter with \(allProviders.count) providers")
        print("   Category: \(selectedCategory.rawValue)")
        print("   Filters: \(selectedFilters)")
        print("   Search: '\(searchText)'")
        
        // Search text filtresi
        if !searchText.isEmpty {
            filtered = filtered.filter { provider in
                provider.name.localizedCaseInsensitiveContains(searchText) ||
                provider.category.localizedCaseInsensitiveContains(searchText) ||
                provider.city.localizedCaseInsensitiveContains(searchText)
            }
            print("   After search: \(filtered.count) providers")
        }
        
        // Country filtresi
        if let country = selectedFilters[.country] {
            let normalizedCountry = country.trimmingCharacters(in: .whitespaces)
            filtered = filtered.filter { provider in
                provider.country.trimmingCharacters(in: .whitespaces)
                    .localizedCaseInsensitiveCompare(normalizedCountry) == .orderedSame
            }
            print("   After country filter '\(country)': \(filtered.count) providers")
        }
        
        // City filtresi
        if let city = selectedFilters[.city] {
            let normalizedCity = city.trimmingCharacters(in: .whitespaces)
            filtered = filtered.filter { provider in
                provider.city.trimmingCharacters(in: .whitespaces)
                    .localizedCaseInsensitiveCompare(normalizedCity) == .orderedSame
            }
            print("   After city filter '\(city)': \(filtered.count) providers")
        }
        
        // Specialty filtresi (Doktor için)
        if let specialty = selectedFilters[.specialty] {
            let normalizedSpecialty = specialty.trimmingCharacters(in: .whitespaces)
            filtered = filtered.filter { provider in
                provider.category.trimmingCharacters(in: .whitespaces)
                    .localizedCaseInsensitiveCompare(normalizedSpecialty) == .orderedSame
            }
            print("   After specialty filter '\(specialty)': \(filtered.count) providers")
        }
        
        // Service filtresi (Hastane için)
        if let service = selectedFilters[.service] {
            let normalizedService = service.trimmingCharacters(in: .whitespaces)
            filtered = filtered.filter { provider in
                provider.category.trimmingCharacters(in: .whitespaces)
                    .localizedCaseInsensitiveCompare(normalizedService) == .orderedSame
            }
            print("   After service filter '\(service)': \(filtered.count) providers")
        }
        
        // Hospital Type filtresi (Hastane için)
        if let hospitalType = selectedFilters[.hospitalType] {
            let normalizedType = hospitalType.trimmingCharacters(in: .whitespaces)
            filtered = filtered.filter { provider in
                guard let institutionCategory = provider.institutionCategory else { return false }
                return institutionCategory.trimmingCharacters(in: .whitespaces)
                    .localizedCaseInsensitiveCompare(normalizedType) == .orderedSame
            }
            print("   After hospital type filter '\(hospitalType)': \(filtered.count) providers")
        }
        
        allFilteredProviders = filtered
        print("✅ Total filtered count: \(allFilteredProviders.count)")
        
        // Pagination'ı sıfırla ve ilk sayfayı yükle
        resetPagination()
        loadInitialPage()
    }
    
    /// Pagination'ı sıfırla
    private func resetPagination() {
        currentlyLoadedCount = 0
        filteredProviders = []
        isLoadingMore = false
    }
    
    /// İlk sayfayı yükle (delay yok)
    private func loadInitialPage() {
        let nextBatchEnd = min(itemsPerPage, allFilteredProviders.count)
        
        if nextBatchEnd > 0 {
            let initialItems = Array(allFilteredProviders[0..<nextBatchEnd])
            filteredProviders = initialItems
            currentlyLoadedCount = nextBatchEnd
            
            print("📄 Initial page loaded: \(initialItems.count) items (Total: \(filteredProviders.count)/\(allFilteredProviders.count))")
        }
    }
    
    /// Sonraki sayfayı yükle
    func loadNextPage() {
        guard !isLoadingMore && hasMoreItems else {
            print("⏸️ Cannot load more: isLoadingMore=\(isLoadingMore), hasMore=\(hasMoreItems)")
            return
        }
        
        isLoadingMore = true
        print("📥 Loading next page...")
        
        // Simulate network delay (gerçek uygulamada API çağrısı olur)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            
            let nextBatchStart = self.currentlyLoadedCount
            let nextBatchEnd = min(nextBatchStart + self.itemsPerPage, self.allFilteredProviders.count)
            
            if nextBatchStart < nextBatchEnd {
                let newItems = Array(self.allFilteredProviders[nextBatchStart..<nextBatchEnd])
                self.filteredProviders.append(contentsOf: newItems)
                self.currentlyLoadedCount = nextBatchEnd
                
                print("📄 Loaded page: \(newItems.count) items (Total: \(self.filteredProviders.count)/\(self.allFilteredProviders.count))")
            }
            
            self.isLoadingMore = false
        }
    }
    
    /// Filtre için unique değerleri getir
    func getUniqueValues(for filterType: FilterType) -> [String] {
        let values: [String]
        
        switch filterType {
        case .country:
            values = allProviders.map { $0.country }
        case .city:
            values = allProviders.map { $0.city }
        case .specialty, .service:
            values = allProviders.map { $0.category }
        case .hospitalType:
            values = allProviders.compactMap { $0.institutionCategory }
        }
        
        let uniqueValues = Array(Set(values)).sorted()
        print("🔢 Unique values for \(filterType): \(uniqueValues.count) items")
        return uniqueValues
    }
    
    /// Tüm filtreleri temizle
    func clearAllFilters() {
        print("🧹 Clearing all filters")
        selectedFilters.removeAll()
        searchText = ""
    }
    
    /// Belirli bir filtreyi kaldır
    func removeFilter(_ filterType: FilterType) {
        selectedFilters.removeValue(forKey: filterType)
    }
}
