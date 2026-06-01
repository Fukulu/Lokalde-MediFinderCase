//
//  ProviderGridCard.swift
//  MediFinder
//
//  Created by Furkan Tümay on 6/1/26.
//

import SwiftUI

struct ProviderGridCard: View {
    let providerName: String
    let category: String
    let city: String
    let rating: Double
    let providerType: ProviderType
    let index: Int
    let providerImage: String?  // Rastgele PNG için
    
    enum ProviderType {
        case doctor
        case hospital
        case vet
        
        // Rastgele PNG resimleri için asset isimleri
        var possibleImages: [String] {
            switch self {
            case .doctor:
                return ["doc1", "doc2", "doc3", "doc4", "doc5"]
            case .hospital:
                return ["hosp1", "hosp2", "hosp3", "hosp4", "hosp5"]
            case .vet:
                return ["vet1", "vet2", "vet3", "vet4", "vet5"]
            }
        }
        
        func randomImage() -> String {
            possibleImages.randomElement() ?? possibleImages[0]
        }
    }
    
    // Pattern: Primary, Secondary, Secondary, Primary (repeats)
    // Index 0 -> Primary, 1 -> Secondary, 2 -> Secondary, 3 -> Primary
    var backgroundColor: Color {
        let pattern = [true, false, false, true] // true = Primary, false = Secondary
        let patternIndex = index % 4
        let usePrimary = pattern[patternIndex]
        return usePrimary ? Color("customGridOne") : Color("customGridTwo")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image Container with rounded background
            ZStack(alignment: .bottomLeading) {
                // Rounded background rectangle
                RoundedRectangle(cornerRadius: 20)
                    .fill(backgroundColor.opacity(0.25))
                    .frame(height: 120)
                    .cornerRadius(70, corners: [.bottomLeft])
                
                // Provider image
                Image(providerImage ?? providerType.randomImage())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .offset(x: 20, y: 10)
            }
            .frame(height: 150)
            
            // Information Section
            VStack(alignment: .leading, spacing: 6) {
                // Provider Name
                Text(providerName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                // Category
                Text(category)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .lineLimit(1)
                
                // City and Rating
                HStack(spacing: 8) {
                    // City
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                        
                        Text(city)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    // Rating
                    HStack(spacing: 3) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 11))
                            .foregroundColor(.orange)
                        
                        Text(String(format: "%.1f", rating))
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.primary)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 12)
        }
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

// Custom corner radius extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    ScrollView {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 15),
            GridItem(.flexible(), spacing: 15)
        ], spacing: 15) {
            // Index 0 - Primary - Doctor PNG 1
            ProviderGridCard(
                providerName: "Dr. Sarah Johnson",
                category: "Kardiyoloji",
                city: "İstanbul",
                rating: 4.9,
                providerType: .doctor,
                index: 0,
                providerImage: "doc1"
            )
            
            // Index 1 - Secondary - Doctor PNG 2
            ProviderGridCard(
                providerName: "Dr. Michael Chen",
                category: "Nöroloji",
                city: "Ankara",
                rating: 4.7,
                providerType: .doctor,
                index: 1,
                providerImage: "doc2"
            )
            
            // Index 2 - Secondary - Doctor PNG 3
            ProviderGridCard(
                providerName: "Dr. Emma Wilson",
                category: "Pediatri",
                city: "İzmir",
                rating: 4.8,
                providerType: .doctor,
                index: 2,
                providerImage: "hosp3"
            )
            
            // Index 3 - Primary - Doctor PNG 4
            ProviderGridCard(
                providerName: "Dr. Ali Yılmaz",
                category: "Ortopedi",
                city: "Bursa",
                rating: 4.6,
                providerType: .doctor,
                index: 3,
                providerImage: "doc4"
            )
            
            // Index 4 - Primary - Doctor PNG 5
            ProviderGridCard(
                providerName: "Dr. Jane Smith",
                category: "Dermatoloji",
                city: "Antalya",
                rating: 4.9,
                providerType: .doctor,
                index: 4,
                providerImage: "vet5"
            )
            
            // Index 5 - Secondary - Doctor PNG 1 (tekrar)
            ProviderGridCard(
                providerName: "Dr. Mehmet Kaya",
                category: "Göz Hastalıkları",
                city: "İzmir",
                rating: 4.5,
                providerType: .doctor,
                index: 5,
                providerImage: "doc1"
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical)
    }
}
