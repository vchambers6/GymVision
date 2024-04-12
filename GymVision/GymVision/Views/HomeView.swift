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
    
    // MARK: Need to put this and other text in a viewmodel
    let currentUpdateFeatures = ["The GymVision Smart Camera, which can identify 100 of the most common balance beam elements", "A searchable databse of all Women's Artistic Gymnastics skills"]
    var body: some View {
    
        ZStack {
            /// BG Color
            Color.primaryBG.ignoresSafeArea(.all)
            
            VStack {
                Divider().background(Color.primaryIcon)
                Spacer()
                
                TabView {
//                    HomeCardView()
                    
                    HomeCardView(title: "What's new on GymVision", subtitle: "v1.0 – April 20, 2024", iconSystemName: "party.popper") {
                        // Card Title / Subtitle
//                        Label {
//                            Text("What's new on GymVision").font(AppFonts.TextTitleBolder.font).foregroundStyle(Color.primaryTitleText).multilineTextAlignment(.center)
//                        } icon: {
//                            Image(systemName: "figure.gymnastics").resizable()
//                                .aspectRatio(contentMode: .fit).foregroundColor(Color.secondaryAccent).frame(width: 25, height: 25)
//                        }.minimumScaleFactor(0.5)
//                        Text("v1.0").font(AppFonts.PlainText.font).foregroundStyle(Color.primaryBodyText).multilineTextAlignment(.center).minimumScaleFactor(0.5)
//                       
//                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("GymVision is officially live! The first version features:").font(AppFonts.PlainText.font)
                            Spacer()
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(currentUpdateFeatures, id: \.self) { item in
                                    HStack(spacing: 10) {
                                        Image(systemName: "circle.hexagongrid")
                                            .foregroundColor(Color.primaryBodyText)
                                        Text(item).font(AppFonts.PlainText.font).foregroundStyle(Color.primaryBodyText)
                                    }
                                }
                            }
                            Spacer()
                            Text("Updates to the Smart Camera are coming soon, so stay tuned!").font(AppFonts.PlainText.font)
                        }
                    }
                        
                }.tabViewStyle(.page(indexDisplayMode: .always))
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                
//                VStack {
//                    Text("GymVision uses computer vision technology to tell you what gymnastis skill you are looking at. \n \n \nTap the button below, and aim your device camera at a gymnastics routine to begin!").multilineTextAlignment(.leading).font(AppFonts.PlainText.font).padding(30).foregroundStyle(Color.primaryBodyText)
//                }
                
                Spacer()
                Divider().background(Color.primaryIcon)
                NavigationLink {
                    FrameView()
                } label: {
                    ZStack {
                        Circle().stroke(Color.primaryBorder, lineWidth: 1.5) // Border color
                            .fill(Color.primaryIcon)
                            .frame(width: 100, height: 100)

                        Image(systemName: "camera.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.secondaryIcon)
                            .frame(width: 50, height: 50)
                    }.shadow(radius: 5)
                }.padding(20)
            }.navigationBarTitleDisplayMode(.inline).toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("GymVision").font(AppFonts.PlainTextSemiBold.font).foregroundStyle(Color.invertedAccent)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: SearchView()) {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Color.invertedAccent)
                    }
                }
            }.navigationBarBackButtonHidden()
        }
         
    }
}

#Preview {
    HomeView()
}
