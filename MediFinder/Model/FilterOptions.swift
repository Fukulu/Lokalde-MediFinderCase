//
//  FilterOptions.swift
//  MediFinder
//
//  Created by Furkan Tümay on 6/1/26.
//

import Foundation

/// FilterOptions artık sadece fallback static listeler içeriyor.
/// Dinamik data için ProviderViewModel.getUniqueValues() kullanılıyor.
struct FilterOptions {
    
    // MARK: - Fallback Static Lists
    // Bu listeler sadece JSON yüklenemediğinde veya test için kullanılır
    
    static let countries = [
        "United States",
        "Turkey",
        "Germany",
        "United Kingdom",
        "France",
        "Canada",
        "Australia"
    ].sorted()
    
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
    
    static let doctorSpecialties = [
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
    
    static let hospitalServices = [
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
        "Research Hospital"
    ].sorted()
    
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
    
    // MARK: - Fallback Options Helper
    
    /// Sadece fallback için kullanılır. Normal durumda ProviderViewModel.getUniqueValues() kullanılmalı.
    static func getFallbackOptions(for filterType: FilterType, category: ProviderCategory) -> [String] {
        switch filterType {
        case .country:
            return countries
            
        case .city:
            return cities
            
        case .specialty:
            return doctorSpecialties
            
        case .service:
            return hospitalServices
            
        case .hospitalType:
            return hospitalTypes
        }
    }
}
