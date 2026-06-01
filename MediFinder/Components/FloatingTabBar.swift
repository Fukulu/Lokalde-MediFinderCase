//
//  FloatingTabBar.swift
//  MediFinder
//
//  Created by Furkan Tümay on 6/1/26.
//

import SwiftUI

// Tab türleri
enum AppTab: Int, CaseIterable {
    case doctor = 0
    case hospital = 1
    case vet = 2
    
    var icon: String {
        switch self {
        case .doctor:
            return "stethoscope"
        case .hospital:
            return "building.2"
        case .vet:
            return "pawprint"
        }
    }
}

struct FloatingTabBar: View {
    @Binding var selectedTab: AppTab
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases, id: \.rawValue) { tab in
                TabBarButton(
                    icon: tab.icon,
                    isSelected: selectedTab == tab
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(
            Capsule()
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.08), radius: 15, x: 0, y: 5)
        )
        .padding(.horizontal, 60)
        .padding(.bottom, 20)
    }
}

// Tab bar butonu
private struct TabBarButton: View {
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(isSelected ? Color("customPrimaryColor") : .gray)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack {
        Spacer()
        FloatingTabBar(selectedTab: .constant(.doctor))
    }
}
