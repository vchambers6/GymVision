//
//  OverviewView.swift
//  LiveCameraSwiftUI
//
//  Created by Vanessa Chambers on 2/22/24.
//

import SwiftUI

// TODO: WHEN THIS VIEW IS PUSHED ON THE STACK, I NEED TO PAUSE VIDEO CAPTURE AND RESUME WHEN THIS VIEW COMES OFF THE STACK
struct OverviewView: View {
    @Binding var isCameraActive: Bool?
    var skillsObserved: [ActionPrediction]
    var body: some View {
            VStack {
                Text("Skills Observed").font(.headline)
                                .padding(.top, 20)
                Spacer()
                List{
                    ForEach(skillsObserved, id: \.self) { row in
                        // TODO: Enable when I implement skill detail view
    //                    NavigationLink(destination: SkillDetailView()) {
    //                        Text(row.label)
    //                    }
                        Text(row.label)
                    }
                }
            }.frame(maxHeight: .infinity, alignment: .center).ignoresSafeArea()
        .onAppear(perform: {
            isCameraActive = false
        }).onDisappear(perform: {
            // TODO: when I implement the detail view (for now I'm just going to disable the navigation links, I need to change this code to instead respond to a specific button click. Because I don't want to restart the camera when I go to the detail view. I'll need to disable the back button from appearing and manually create a back button
            isCameraActive = true
        })
        
    }
}

//#Preview {
//    @State var isCameraActive = false
//    OverviewView(isCameraActive: $isCameraActive, skillsObserved: [])
//}


