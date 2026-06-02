//
//  BlurInfoCard.swift
//  MediFinder
//
//  Created by Furkan Tümay on 6/2/26.
//

import SwiftUI

// MARK: - Blur Info Card Component (Equal Width)
struct BlurInfoCard: View {
    let value: String
    let label: String
    let sublabel: String?
    let icon: String
    let iconColor: Color
    
    var body: some View {
        
        VStack(spacing: 4) {
            Spacer()
            // Value and Icon
            HStack(spacing: 4) {
                Text(value)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(iconColor)
            }
            
            // Label
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.secondary)
            
            // Sublabel (if exists)
            if let sublabel = sublabel {
                Text(sublabel)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            } else {
                // Boş alan ekleyerek yükseklikleri eşitle
                Text(" ")
                    .font(.system(size: 10))
                    .foregroundColor(.clear)
            }
            Spacer()
        }
        .frame(width: 100, height: 50)  // ✅ Sabit minimum yükseklik
        .padding(.vertical, 10)
        .padding(.horizontal, 8)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 12)
        )
        
    }
    
}
