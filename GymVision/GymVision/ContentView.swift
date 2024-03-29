//
//  ContentView.swift
//  GymVision
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
    
    init() {
        for familyName in UIFont.familyNames {
            print(familyName)
            
            for fontName in UIFont.fontNames(forFamilyName: familyName) {
                print("---- \(fontName)")
            }
        }
    }
}

#Preview {
    ContentView()
}
