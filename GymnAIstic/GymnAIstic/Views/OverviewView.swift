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
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
            VStack {
                List(skillsObserved) { skill in
                    NavigationLink(destination: SkillDetailView(skillCOPNumber: skill.copNumber)) {
                        SkillTableRowView(skill: skill.label, confidence: skill.confidenceString!)
                    }
                }
                .navigationTitle("Overview")
            }.frame(alignment: .center)
        .onAppear(perform: {
            isCameraActive = false
        }).onDisappear(perform: {
            isCameraActive = true
        }).navigationBarTitle("Skills Observed", displayMode: .inline)
        
    }
}

struct SkillTableRowView: View {
    var skill: String
    var confidence: String
    
    var body: some View {
        HStack {
            Text(skill).padding(.leading, 5)
            Spacer()
            Text("Confidence: \(confidence)").padding(.trailing, 5).minimumScaleFactor(0.5).lineLimit(1)
        }
    }
}

//#Preview {
//    var skills = [
//        ActionPrediction(label: "Back Tuck", confidence: 100),
//        ActionPrediction(label: "Split Jump", confidence: 100)
//    ]
//    @State var isCameraActive = false
//    OverviewView(skillsObserved: skills)
//}



