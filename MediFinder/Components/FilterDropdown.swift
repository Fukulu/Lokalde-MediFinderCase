//
//  FilterDropdown.swift
//  MediFinder
//
//  Created by Furkan Tümay on 6/1/26.
//

import SwiftUI

struct FilterDropdown: View {
    let title: Text
    let options: [String]
    @Binding var selectedValue: String?
    let onSelect: (String?) -> Void
    
    @Environment(\.dismiss) var dismiss
    @State private var searchText: String = ""
    @State private var selectedOptions: Set<String> = []
    
    init(title: Text, options: [String], selectedValue: Binding<String?>, onSelect: @escaping (String?) -> Void) {
        self.title = title
        self.options = options
        self._selectedValue = selectedValue
        self.onSelect = onSelect
        print("🎬 FilterDropdown init with \(options.count) options")
    }
    
    // Filtrelenmiş seçenekler
    private var filteredOptions: [String] {
        if searchText.isEmpty {
            return options
        }
        return options.filter { option in
            option.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                title
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.gray)
                        .rotationEffect(.degrees(0))
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            .background(Color(.systemBackground))
            
            // Search Bar
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                
                TextField(text: $searchText, prompt: Text("Search...")) {
                    // Empty label for accessibility
                }
                    .font(.system(size: 15))
                    .foregroundColor(.primary)
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .cornerRadius(16)
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
            
            Divider()
                .padding(.horizontal, 24)
            
            // Options List with Checkboxes
            ScrollView {
                VStack(spacing: 0) {
                    if filteredOptions.isEmpty {
                        // Empty State
                        VStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                            
                            Text("No results found")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 60)
                    } else {
                        ForEach(filteredOptions, id: \.self) { option in
                            FilterOptionRow(
                                option: option,
                                isSelected: selectedValue == option
                            ) {
                                // Toggle selection
                                if selectedValue == option {
                                    selectedValue = nil
                                    onSelect(nil)
                                } else {
                                    selectedValue = option
                                    onSelect(option)
                                }
                            }
                        }
                    }
                }
                .padding(.top, 8)
            }
            
            // Apply Button
            Button(action: {
                dismiss()
            }) {
                Text("Apply")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color("customPrimaryColor"))
                    .cornerRadius(16)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(Color(.systemBackground))
        }
        .background(Color(.systemBackground))
    }
}

// Filter option satırı (Checkbox style)
private struct FilterOptionRow: View {
    let option: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Text(option)
                    .font(.system(size: 16))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Checkbox
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(isSelected ? Color("customPrimaryColor") : Color.gray.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color("customPrimaryColor"))
                            .frame(width: 24, height: 24)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(isSelected ? Color("customPrimaryColor").opacity(0.05) : Color.clear)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FilterDropdown(
        title: Text("Kuruluş Kategorisi"),
        options: [
            "Devlet Hastanesi",
            "Diş Hastanesi",
            "Eğitim Hastanesi",
            "Estetik Hastanesi",
            "Göz Hastanesi",
            "Göz Kliniği",
            "Özel Hastane"
        ],
        selectedValue: .constant("Devlet Hastanesi"),
        onSelect: { value in
            print("Selected: \(value ?? "None")")
        }
    )
}
