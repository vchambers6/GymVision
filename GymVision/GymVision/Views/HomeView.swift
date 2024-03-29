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
    var body: some View {
    
        ZStack {
            /// BG Color
            Color.mnPrimaryThemeBG.ignoresSafeArea(.all)
            
            
            /// Information button
           
            
            VStack {
                Text("GymVision uses computer vision technology to tell you what gymnastis skill you are looking at. ").padding(30).multilineTextAlignment(.leading).font(AppFonts.PlainText.font)
            NavigationLink {
                // TODO: Need to navigate to OverviewView and build out that UI
                FrameView()
            } label: {
                ZStack {
                    Circle()
                        .foregroundColor(.mnBtnBG) // Adjust color as needed
                        .frame(width: 100, height: 100) // Adjust size as needed
                    Image(systemName: "camera.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.mnIcon) // Adjust color as needed
                        .frame(width: 50, height: 50) // Adjust size as needed
                }.shadow(color: Color.white.opacity(0.3), radius: 20, x: 0, y: 5)
                //                Text("GO")
                //                    .foregroundColor(.black)
                //                    .font(.title)
                //                    .padding()
                //                    .frame(width: 300, height: 140)
                //                    .background(Color.white)
                //                    .clipShape(Circle())
                //                    .shadow(color: Color.pink.opacity(0.3), radius: 10, x: 0, y: 5)
                
            }.padding(30)
            Text("Tap the above button, and aim your device camera at a gymnastics routine to begin!").padding(30).font(AppFonts.PlainText.font).multilineTextAlignment(.leading)
        }.navigationBarItems(leading: Text("GymVision"))
        }
         
    }
}

#Preview {
    HomeView()
}
