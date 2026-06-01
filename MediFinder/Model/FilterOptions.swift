//
//  FilterOptions.swift
//  MediFinder
//
//  Created by Furkan Tümay on 6/1/26.
//

import Foundation

struct FilterOptions {
    
    // Countries
    static let countries = [
        "United States",
        "Turkey",
        "Germany",
        "United Kingdom",
        "France",
        "Canada",
        "Australia"
    ].sorted()
    
    // Cities
    static let cities = [
        "Istanbul",
        "Ankara",
        "Izmir",
        "Antalya",
        "Bursa",
        "New York",
        "Los Angeles",
        "Chicago",
        "San Francisco",
        "Boston",
        "Washington",
        "Berlin",
        "Munich",
        "Frankfurt",
        "Hamburg",
        "London",
        "Paris",
        "Toronto",
        "Sydney"
    ].sorted()
    
    // Doctor Categories
    static let doctorCategories = [
        "Cardiology",
        "Neurology",
        "Pediatrics",
        "Orthopedics",
        "Dermatology",
        "Ophthalmology",
        "Psychiatry",
        "General Practice",
        "Internal Medicine",
        "Surgery",
        "Obstetrics & Gynecology",
        "Urology",
        "Otolaryngology (ENT)",
        "Endocrinology",
        "Gastroenterology",
        "Pulmonology",
        "Nephrology",
        "Hematology",
        "Oncology",
        "Rheumatology",
        "Plastic Surgery",
        "Emergency Medicine",
        "Radiology",
        "Pathology",
        "Anesthesiology"
    ].sorted()
    
    // Hospital Categories
    static let hospitalCategories = [
        "General Hospital",
        "Children's Hospital",
        "Cardiac Hospital",
        "Cancer Center",
        "Orthopedic Hospital",
        "Eye Hospital",
        "Dental Hospital",
        "Maternity Hospital",
        "Mental Health Hospital",
        "Rehabilitation Center",
        "Emergency Hospital",
        "Trauma Center",
        "Teaching Hospital",
        "Research Hospital",
        "Private Hospital",
        "Public Hospital",
        "University Hospital",
        "Military Hospital"
    ].sorted()
    
    // Hospital Types
    static let hospitalTypes = [
        "Private Hospital",
        "Public Hospital",
        "University Hospital",
        "Teaching Hospital",
        "Research Hospital",
        "Government Hospital",
        "Military Hospital",
        "Specialty Hospital"
    ].sorted()
    
    // Institution Categories
    static let institutionCategories = [
        "Private Hospital",
        "Public Hospital",
        "University Hospital",
        "Government Hospital",
        "Education Hospital",
        "Research Hospital",
        "Eye Hospital",
        "Eye Clinic",
        "Dental Hospital",
        "Dental Clinic",
        "Aesthetic Hospital",
        "Rehabilitation Center",
        "Health Center"
    ].sorted()
    
    // Vet Specialties
    static let vetSpecialties = [
        "General Veterinary",
        "Small Animals",
        "Large Animals",
        "Exotic Animals",
        "Emergency Vet",
        "Surgery",
        "Internal Medicine",
        "Dermatology",
        "Ophthalmology",
        "Dentistry",
        "Orthopedics",
        "Oncology",
        "Cardiology"
    ].sorted()
    
    // Get options based on category and filter type
    static func getOptions(for filterType: FilterType, category: ProviderCategory) -> [String] {
        // Önce gerçek provider'lardan unique değerleri al
        let allProviders = ProviderService.shared.loadProviders(category: category)
        let dynamicOptions = ProviderService.shared.getUniqueValues(from: allProviders, for: filterType)
        
        // Eğer JSON'dan data geldiyse onu kullan, yoksa fallback olarak statik listeyi kullan
        let result: [String]
        
        if !dynamicOptions.isEmpty {
            result = dynamicOptions
        } else {
            // Fallback: Statik listeler
            switch filterType {
            case .country:
                result = countries
                
            case .city:
                result = cities
                
            case .service:
                switch category {
                case .doctor:
                    result = doctorCategories
                case .hospital:
                    result = hospitalCategories
                case .vet:
                    result = vetSpecialties
                }
                
            case .specialty:
                result = doctorCategories
                
            case .hospitalType:
                result = hospitalTypes
                
            case .institution:
                result = institutionCategories
            }
        }
        
        print("🔍 FilterOptions.getOptions(\(filterType), \(category)): \(result.count) items")
        if result.isEmpty {
            print("❌ WARNING: Empty options returned!")
        } else {
            print("   Sample values: \(result.prefix(3).joined(separator: ", "))")
        }
        
        return result
    }
}
