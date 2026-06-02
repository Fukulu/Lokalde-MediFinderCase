//
//  SplashScreenView.swift
//  MediFinder
//
//  Created by Furkan Tümay on 6/2/26.
//


import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            Image("SplashScreen")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(0)
                .ignoresSafeArea()
        }
    }
}
