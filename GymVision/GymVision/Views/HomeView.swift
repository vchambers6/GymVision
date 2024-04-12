//
//  HomeView.swift
//  GymVision
//
//  Created by Vanessa Chambers on 2/22/24.
//

import SwiftUI

struct HomeView: View {
    @State private var showInfo = false
    
    @Environment(\.colorScheme) var colorScheme
    
    // TODO: Need to put this and other text in a viewmodel -- will do this once I have more cards to go through because it may involve http requests
    let currentUpdateFeatures = ["The GymVision Smart Camera, which can identify 100 of the most common balance beam elements", "A searchable databse of all Women's Artistic Gymnastics skills"]
    
    var body: some View {
        NavigationView {
            ZStack {
                /// BG Color
                Color.primaryBG.ignoresSafeArea(.all)
                
                VStack {
                    Divider().background(Color.primaryIcon)
                    Spacer()
                    
                    TabView {
                        HomeCardView(title: "What's new on GymVision", subtitle: "v1.0 – April 20, 2024", iconSystemName: "party.popper") {
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
                        
                        // MARK: when I come out with more home screen content, put the cards here. 
                        
                    }.tabViewStyle(.page(indexDisplayMode: .always))
                        .indexViewStyle(.page(backgroundDisplayMode: .always))
                    
                    /// Camera button to FrameView
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
                    
                /// Toolbar items
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
        /// Info button and info overlay
        .overlay(alignment: .bottomTrailing) {
            Button {
                withAnimation {
                    showInfo.toggle()
                }
            } label: {
                Image(systemName: "info.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color.primaryAccent)
            }.padding(30).ignoresSafeArea(.all)

        }
        .overlay(alignment: .center) {
            if showInfo {
                ZStack {
                    Color.secondaryBG.opacity(0.98).edgesIgnoringSafeArea(.all)
                    VStack{
                        Button {
                            withAnimation {
                                showInfo.toggle()
                            }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(Color.primaryBodyText).frame(maxWidth: .infinity, alignment: .topTrailing)
                        }.padding(15)
                        
                        VStack {
                            Text("The GymVision Smart Camera uses computer vision technology to tell you what gymnastis skill you are looking at. \n \nTap the camera button on the home screen, and aim your device camera at a gymnastics routine to begin!").font(AppFonts.PlainTextSemiBold.font).padding(.bottom, 40).frame(maxWidth: .infinity, alignment: .leading)
 
                            Text("Currently, the Smart Camera can identify 100 of the most common elements on the balance beam apparatus. Future updates to the camera will include recongition of more skills on more apparatuses.").font(AppFonts.PlainText.font).frame(maxWidth: .infinity, alignment: .leading)
                        }.foregroundStyle(Color.primaryBodyText)
                            .padding(30).multilineTextAlignment(.leading)
                        Spacer()
                    }
                }
            }
            
            
        }
         
    }
}

#Preview {
    HomeView()
}
