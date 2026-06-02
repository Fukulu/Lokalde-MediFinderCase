//
//  CustomNavigationBar.swift
//  MediFinder
//
//  Created by Furkan Tümay on 6/1/26.
//

import SwiftUI

struct CustomNavigationBar: View {
    let profileImage: String
    let userName: String
    let onSettingsTapped: () -> Void
    
    @Environment(LanguageManager.self) private var languageManager
    
    var body: some View {
        HStack(spacing: 12) {
            // Profile Image with fallback
            Group {
                if let uiImage = UIImage(named: profileImage) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    // Fallback: System person icon
                    ZStack {
                        Circle()
                            .fill(Color("customPrimaryColor").opacity(0.1))
                        
                        Image(systemName: "person.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Color("customPrimaryColor"))
                    }
                }
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
            // Greeting and User Name
            VStack(alignment: .leading, spacing: 2) {
                Text("Hello")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                Text(userName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            // Settings Button
            Button(action: onSettingsTapped) {
                Image(systemName: "gearshape")
                    .font(.system(size: 24))
                    .foregroundColor(Color.primary)
                    .shadow(color: Color.black.opacity(0.1), radius: 5)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}

#Preview {
    CustomNavigationBar(
        profileImage: "furkan",
        userName: "Furkan Tümay",
        onSettingsTapped: {
            print("Settings tapped")
        }
    )
    .environment(LanguageManager())
}
