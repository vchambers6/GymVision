//
//  HomeView.swift
//  LiveCameraSwiftUI
//
//  Created by Vanessa Chambers on 2/22/24.
//

import SwiftUI

struct HomeView: View {
//    @StateObject private var viewModel = FrameViewModel()
    var body: some View {
        VStack {
            Text("GymVision uses computer vision AI to tell you what gymnastis skill you are looking at. ").padding(30).multilineTextAlignment(.center).font(.headline)
            NavigationLink {
                // TODO: Need to navigate to OverviewView and build out that UI
                FrameView()
            } label: {
                Text("GO")
                    .foregroundColor(.black)
                    .font(.title)
                    .padding()
                    .frame(width: 300, height: 140)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: Color.pink.opacity(0.3), radius: 10, x: 0, y: 5)
            
            }.padding(30)
            Text("Tap the above button, and aim your device camera at a gymnastics routine to begin!").padding(30).font(.headline).multilineTextAlignment(.center)
        }.navigationBarItems(leading: Text("GymVision"))
        
    }
}

#Preview {
    HomeView()
}
