//
//  Provider.swift
//  MediFinder
//
//  Created by Furkan Tümay on 6/1/26.
//

import Foundation

// Genel Provider modeli (Doctor, Hospital, Vet için)
struct Provider: Identifiable, Codable {
    let id: String
    let name: String
    let type: String?
    let institutionCategory: String?
    let category: String
    let country: String
    let city: String
    let rating: Double
    let phone: String?
    let email: String?
    let aboutMe: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case institutionCategory = "institution_category"
        case category
        case country
        case city
        case rating
        case phone
        case email
        case aboutMe = "about_me"
    }
    
    // Default değerler ile init
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        type = try? container.decode(String.self, forKey: .type)
        institutionCategory = try? container.decode(String.self, forKey: .institutionCategory)
        category = try container.decode(String.self, forKey: .category)
        country = try container.decode(String.self, forKey: .country)
        city = try container.decode(String.self, forKey: .city)
        rating = (try? container.decode(Double.self, forKey: .rating)) ?? 0.0
        phone = try? container.decode(String.self, forKey: .phone)
        email = try? container.decode(String.self, forKey: .email)
        aboutMe = try? container.decode(String.self, forKey: .aboutMe)
    }
}

// Provider tipi belirleme
extension Provider {
    var providerType: ProviderGridCard.ProviderType {
        guard let type = type?.lowercased() else {
            return .doctor // Default
        }
        
        if type.contains("doctor") || type.contains("doktor") || type.contains("dr") {
            return .doctor
        } else if type.contains("hospital") || type.contains("hastane") {
            return .hospital
        } else if type.contains("vet") || type.contains("veteriner") {
            return .vet
        }
        
        return .doctor // Default
    }
    
    // Display helpers
    var displayPhone: String {
        phone ?? "N/A"
    }
    
    var displayEmail: String {
        email ?? "N/A"
    }
    
    var displayAbout: String {
        aboutMe ?? "No description available"
    }
    
    var displayInstitution: String {
        institutionCategory ?? "General"
    }
}
