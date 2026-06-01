//
//  FilterChipsBar.swift
//  MediFinder
//
//  Created by Furkan Tümay on 6/1/26.
//

import SwiftUI

// Provider türleri (Doctor, Hospital, Vet için)
enum ProviderCategory: String, CaseIterable {
    case doctor = "Doctor"
    case hospital = "Hospital"
    case vet = "Vet"
    
    var icon: String {
        switch self {
        case .doctor:
            return "stethoscope"
        case .hospital:
            return "cross.case.fill"
        case .vet:
            return "pawprint.fill"
        }
    }
}

// Filter türleri
enum FilterType: CaseIterable {
    case country
    case city
    case service
    case specialty
    case hospitalType
    case institution
    
    var displayName: String {
        switch self {
        case .country:
            return String(localized: "Country")
        case .city:
            return String(localized: "City")
        case .service:
            return String(localized: "Service")
        case .specialty:
            return String(localized: "Specialty")
        case .hospitalType:
            return String(localized: "Hospital Type")
        case .institution:
            return String(localized: "Institution")
        }
    }
    
    var icon: String {
        switch self {
        case .country:
            return "globe"
        case .city:
            return "building.2.fill"
        case .service:
            return "list.bullet.clipboard"
        case .specialty:
            return "heart.text.square"
        case .hospitalType:
            return "building.2"
        case .institution:
            return "building.columns"
        }
    }
}

struct FilterChipsBar: View {
    let selectedCategory: ProviderCategory
    @Binding var selectedFilters: [FilterType: String]
    let onFilterTap: (FilterType) -> Void
    
    // Her kategori için uygun filtreleri döndür
    private var availableFilters: [FilterType] {
        switch selectedCategory {
        case .doctor:
            return [.country, .service, .specialty]
        case .hospital:
            return [.country, .service, .hospitalType, .institution]
        case .vet:
            return [.country]
        }
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(availableFilters, id: \.self) { filter in
                    FilterChip(
                        filterType: filter,
                        selectedValue: selectedFilters[filter],
                        onTap: {
                            onFilterTap(filter)
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
        }
        .frame(height: 50)
    }
}

// Filter chip komponenti
private struct FilterChip: View {
    let filterType: FilterType
    let selectedValue: String?
    let onTap: () -> Void
    
    var displayText: String {
        selectedValue ?? filterType.displayName
    }
    
    var isSelected: Bool {
        selectedValue != nil
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                Image(systemName: filterType.icon)
                    .font(.system(size: 13))
                
                Text(displayText)
                    .font(.system(size: 14, weight: .medium))
                    .lineLimit(1)
                
                Image(systemName: "chevron.down")
                    .font(.system(size: 10))
            }
            .foregroundColor(isSelected ? Color("customPrimaryColor") : .gray)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(isSelected ? Color.customPrimary : Color.clear)
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.systemGray6))
                        .padding(1)
                }
                
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 20) {
        Text("Doctor Filters")
            .font(.headline)
        FilterChipsBar(
            selectedCategory: .doctor,
            selectedFilters: .constant([.country: "Turkey"]),
            onFilterTap: { filter in
                print("Tapped: \(filter.displayName)")
            }
        )
        
        Text("Hospital Filters")
            .font(.headline)
        FilterChipsBar(
            selectedCategory: .hospital,
            selectedFilters: .constant([.country: "USA", .service: "Cardiology"]),
            onFilterTap: { filter in
                print("Tapped: \(filter.displayName)")
            }
        )
        
        Text("Vet Filters")
            .font(.headline)
        FilterChipsBar(
            selectedCategory: .vet,
            selectedFilters: .constant([:]),
            onFilterTap: { filter in
                print("Tapped: \(filter.displayName)")
            }
        )
    }
    .padding()
}
