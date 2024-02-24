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
        NavigationLink {
            // TODO: Need to navigate to OverviewView and build out that UI
//            FrameView(image: viewModel.frame, label: viewModel.actionLabel ?? "No Skill", skillsObserved: viewModel.skillsObserved)
            FrameView()
        } label: {
                Label(
                    title: { Text("GO").font(.largeTitle) },
                    icon: { Image(systemName: "42.circle") }
                )
        }.navigationTitle("Home")
    }
}

#Preview {
    HomeView()
}
