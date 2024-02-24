//
//  OverviewView.swift
//  LiveCameraSwiftUI
//
//  Created by Vanessa Chambers on 2/22/24.
//

import SwiftUI

// TODO: WHEN THIS VIEW IS PUSHED ON THE STACK, I NEED TO PAUSE VIDEO CAPTURE AND RESUME WHEN THIS VIEW COMES OFF THE STACK
struct OverviewView: View {
    var skillsObserved: [ActionPrediction]
    var body: some View {
        List{
            ForEach(skillsObserved, id: \.self) { row in
                NavigationLink(destination: SkillDetailView()) {
                    Text(row.label)
                }
            }
        }
    }
}

#Preview {
    OverviewView(skillsObserved: [])
}


