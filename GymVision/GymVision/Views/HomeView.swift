//
//  HomeView.swift
//  GymVision
//
//  Created by Vanessa Chambers on 2/22/24.
//

import SwiftUI

struct HomeView: View {
//    @StateObject private var viewModel = FrameViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
    
        ZStack {
            /// BG Color
            Color.mnPrimaryThemeBG.ignoresSafeArea(.all)
            
            
            /// Information button
           
            
            VStack {
                Spacer()
                VStack {
                    Text("GymVision uses computer vision technology to tell you what gymnastis skill you are looking at. \n \n \nTap the button below, and aim your device camera at a gymnastics routine to begin!").multilineTextAlignment(.leading).font(AppFonts.PlainText.font).padding(30)
                }
                
                Spacer()
                NavigationLink {
                    FrameView()
                } label: {
                    ZStack {
                        Circle().stroke(colorScheme == .dark ? Color.mnAccent : Color.clear)
                            .fill(.mnBtnBG)
                            .frame(width: 100, height: 100)

                        Image(systemName: "camera.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.mnIconText) // Adjust color as needed
                            .frame(width: 50, height: 50) // Adjust size as needed
                    }
                }.padding(30)
            }.navigationBarTitleDisplayMode(.inline).toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("GymVision").font(AppFonts.PlainTextSemiBold.font).foregroundStyle(Color.mnAccent)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: SearchView()) {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Color.mnAccent)
                    }
                }
            }.navigationBarBackButtonHidden()
        }
         
    }
}

#Preview {
    HomeView()
}
