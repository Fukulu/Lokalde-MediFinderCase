//
//  ProviderDetailView.swift
//  MediFinder
//
//  Created by Furkan Tümay on 6/2/26.
//

import SwiftUI

struct ProviderDetailView: View {
    let provider: Provider
    let providerImage: String?  // ✅ Grid'den gelen resim
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header with Image and Blur Info Bar
                ZStack(alignment: .top) {
                    // Provider Image (Grid'den gelen veya default)
                    if let imageName = providerImage, let uiImage = UIImage(named: imageName) {
                        // Grid'den gelen rastgele resim
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 300)
                            .clipped()
                    } else if let imageURL = provider.imageURL, let url = URL(string: imageURL) {
                        // URL'den resim (varsa)
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            case .failure(_):
                                defaultProviderImage
                            case .empty:
                                ZStack {
                                    defaultProviderImage
                                    ProgressView()
                                        .scaleEffect(1.5)
                                }
                            @unknown default:
                                defaultProviderImage
                            }
                        }
                    } else {
                        // Default gradient resim
                        defaultProviderImage
                    }
                    
                    // Navigation Buttons (Back & Share)
                    VStack {
                        HStack {
                            // Back Button
                            Button(action: {
                                dismiss()
                            }) {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 44, height: 44)
                                    .overlay {
                                        Image(systemName: "chevron.left")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(.black)
                                    }
                                    .shadow(color: .black.opacity(0.1), radius: 4)
                            }
                            
                            Spacer()
                            
                            // Share Button
                            Button(action: {
                                // Share action
                            }) {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 44, height: 44)
                                    .overlay {
                                        Image(systemName: "square.and.arrow.up")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(.black)
                                    }
                                    .shadow(color: .black.opacity(0.1), radius: 4)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 60)
                        
                        Spacer()
                        
                        // Blur Info Bar at Bottom of Image (Equal Width Cards)
                        HStack(spacing: 8) {
                            // Experience Card
                            if let experience = provider.experience {
                                BlurInfoCard(
                                    value: "\(experience)",
                                    label: "Experience",
                                    sublabel: nil,
                                    icon: "checkmark.circle.fill",
                                    iconColor: .green
                                )
                            }
                            
                            // Review Count Card
                            if let reviewCount = provider.reviewCount {
                                BlurInfoCard(
                                    value: "\(reviewCount)",
                                    label: "Reviews",
                                    sublabel: nil,
                                    icon: "message.fill",
                                    iconColor: .blue
                                )
                            }
                            
                            // Rating Card (Her zaman göster)
                            BlurInfoCard(
                                value: String(format: "%.1f", provider.rating),
                                label: "Rating",
                                sublabel: nil,
                                icon: "star.fill",
                                iconColor: .yellow
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                }
                .frame(height: 300)
                .background(Gradient(colors: [Color.customGridOne, Color.customGridTwo]))
                
                // Content Card
                VStack(alignment: .leading, spacing: 20) {
                    // Category Badge
                    Text(provider.category)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color("customPrimaryColor"))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color("customPrimaryColor").opacity(0.1))
                        .cornerRadius(20)
                    
                    // Provider Name
                    Text(provider.name)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                    
                    // Location Info (City & Country)
                    HStack(spacing: 8) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Color("customPrimaryColor"))
                        
                        Text("\(provider.city), \(provider.country)")
                            .font(.system(size: 15))
                            .foregroundColor(.secondary)
                    }
                    
                    // About Me Section
                    if let aboutMe = provider.aboutMe, !aboutMe.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("About Me")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.primary)
                            
                            Text(aboutMe)
                                .font(.system(size: 15))
                                .foregroundColor(.secondary)
                                .lineSpacing(6)
                        }
                        .padding(.top, 10)
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)
            }
        }
        .ignoresSafeArea(edges: .top)
        .overlay(alignment: .bottom) {
            // Appointment Button
            Button(action: {
                // Appointment action
            }) {
                Text("Appointment Now")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.blue)
                    .cornerRadius(30)
                    .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
            .background(
                LinearGradient(
                    colors: [Color.clear, Color(.systemBackground)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 120)
            )
        }
    }
    
    // Default Provider Image (Type'a göre)
    private var defaultProviderImage: some View {
        ZStack {
            // Gradient Background
            LinearGradient(
                colors: providerGradientColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Icon
            Image(systemName: providerIcon)
                .font(.system(size: 100))
                .foregroundColor(.white.opacity(0.3))
        }
    }
    
    // Provider Type'a göre gradient renkleri
    private var providerGradientColors: [Color] {
        switch provider.providerType {
        case .doctor:
            return [Color.blue.opacity(0.7), Color.blue.opacity(0.4)]
        case .hospital:
            return [Color.red.opacity(0.7), Color.red.opacity(0.4)]
        case .vet:
            return [Color.green.opacity(0.7), Color.green.opacity(0.4)]
        }
    }
    
    // Provider Type'a göre ikon
    private var providerIcon: String {
        switch provider.providerType {
        case .doctor:
            return "stethoscope"
        case .hospital:
            return "cross.case.fill"
        case .vet:
            return "pawprint.fill"
        }
    }
}

#Preview {
    ProviderDetailView(
        provider: Provider(
            id: "1",
            name: "Dr. Elizabeth Davis",
            type: "doctor",
            institutionCategory: nil,
            category: "Orthopedics",
            country: "Turkey",
            city: "Istanbul",
            rating: 4.5,
            aboutMe: "Dr. Elizabeth Davis is a highly skilled orthopedic specialist dedicated to diagnosing and treating musculoskeletal conditions. With years of experience, she specializes in bone, joint, and muscle care, helping patients regain mobility and lead pain-free lives.",
            experience: 14,
            reviewCount: 99,
            imageURL: nil
        ),
        providerImage: nil
    )
}
