//
//  ProviderService.swift
//  MediFinder
//
//  Created by Furkan Tümay on 6/1/26.
//

import Foundation

class ProviderService {
    static let shared = ProviderService()
    
    private init() {}
    
    // JSON'dan provider listesini yükle
    func loadProviders(category: ProviderCategory) -> [Provider] {
        let language = LanguageManager.shared.jsonSuffix
        let fileName: String
        
        switch category {
        case .doctor:
            fileName = "doctor_list_\(language)"
        case .hospital:
            fileName = "hospital_list_\(language)"
        case .vet:
            fileName = "vet_list_\(language)"
        }
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("❌ JSON file not found: \(fileName).json")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let providers = try JSONDecoder().decode([Provider].self, from: data)
            print("✅ Loaded \(providers.count) providers from \(fileName).json")
            return providers
        } catch {
            print("❌ Error decoding JSON: \(error)")
            print("   File: \(fileName).json")
            return []
        }
    }
    
    // Filtreleme fonksiyonu
    func filterProviders(
        _ providers: [Provider],
        by filters: [FilterType: String],
        searchText: String = ""
    ) -> [Provider] {
        var filtered = providers
        
        print("🔍 Starting filter with \(providers.count) providers")
        print("   Filters: \(filters)")
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
        
        // Country filtresi - Case insensitive ve trim yaparak karşılaştır
        if let country = filters[.country] {
            let normalizedCountry = country.trimmingCharacters(in: .whitespaces)
            filtered = filtered.filter { provider in
                provider.country.trimmingCharacters(in: .whitespaces)
                    .localizedCaseInsensitiveCompare(normalizedCountry) == .orderedSame
            }
            print("   After country filter '\(country)': \(filtered.count) providers")
        }
        
        // City filtresi - Case insensitive ve trim yaparak karşılaştır
        if let city = filters[.city] {
            let normalizedCity = city.trimmingCharacters(in: .whitespaces)
            filtered = filtered.filter { provider in
                provider.city.trimmingCharacters(in: .whitespaces)
                    .localizedCaseInsensitiveCompare(normalizedCity) == .orderedSame
            }
            print("   After city filter '\(city)': \(filtered.count) providers")
        }
        
        // Service filtresi
        if let service = filters[.service] {
            let normalizedService = service.trimmingCharacters(in: .whitespaces)
            filtered = filtered.filter { provider in
                provider.category.trimmingCharacters(in: .whitespaces)
                    .localizedCaseInsensitiveCompare(normalizedService) == .orderedSame
            }
            print("   After service filter '\(service)': \(filtered.count) providers")
        }
        
        // Specialty filtresi
        if let specialty = filters[.specialty] {
            let normalizedSpecialty = specialty.trimmingCharacters(in: .whitespaces)
            filtered = filtered.filter { provider in
                provider.category.trimmingCharacters(in: .whitespaces)
                    .localizedCaseInsensitiveCompare(normalizedSpecialty) == .orderedSame
            }
            print("   After specialty filter '\(specialty)': \(filtered.count) providers")
        }
        
        // Hospital Type filtresi
        if let hospitalType = filters[.hospitalType] {
            let normalizedType = hospitalType.trimmingCharacters(in: .whitespaces)
            filtered = filtered.filter { provider in
                guard let institutionCategory = provider.institutionCategory else { return false }
                return institutionCategory.trimmingCharacters(in: .whitespaces)
                    .localizedCaseInsensitiveCompare(normalizedType) == .orderedSame
            }
            print("   After hospital type filter '\(hospitalType)': \(filtered.count) providers")
        }
        
        // Institution filtresi
        if let institution = filters[.institution] {
            let normalizedInstitution = institution.trimmingCharacters(in: .whitespaces)
            filtered = filtered.filter { provider in
                guard let institutionCategory = provider.institutionCategory else { return false }
                return institutionCategory.trimmingCharacters(in: .whitespaces)
                    .localizedCaseInsensitiveCompare(normalizedInstitution) == .orderedSame
            }
            print("   After institution filter '\(institution)': \(filtered.count) providers")
        }
        
        print("✅ Final filtered count: \(filtered.count)")
        return filtered
    }
    
    // Unique değerleri çıkar (dropdown için)
    func getUniqueValues(from providers: [Provider], for filterType: FilterType) -> [String] {
        let values: [String]
        
        switch filterType {
        case .country:
            values = providers.map { $0.country }
        case .city:
            values = providers.map { $0.city }
        case .service, .specialty:
            values = providers.map { $0.category }
        case .hospitalType, .institution:
            values = providers.compactMap { $0.institutionCategory }
        }
        
        return Array(Set(values)).sorted()
    }
}
