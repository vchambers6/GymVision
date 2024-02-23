//
//  ContentView.swift
//  LiveCameraSwiftUI
//
//  Created by Vanessa Chambers on 2/14/24.
//

import SwiftUI

struct ContentView: View {
    
//    @StateObject private var model = FrameHandler()
//    @StateObject private var viewModel = FrameViewModel()
    var body: some View {
        NavigationStack {
            VStack {
    //            FrameView(image: viewModel.frame, label: viewModel.actionLabel ?? "No Skill").ignoresSafeArea()
                HomeView()
            }
        }
       
    }
}

#Preview {
    ContentView()
}
