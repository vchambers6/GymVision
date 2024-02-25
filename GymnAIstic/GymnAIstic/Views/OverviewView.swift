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
                Table(skillsObserved) { 
                    TableColumn("Skill") { skill in
                         if (horizontalSizeClass == .compact) {
                             // Return compact version of the view
                             SkillTableRowView(skill: skill.label, confidence: skill.confidenceString!)
                         } else {
                             // Return normal version of the view
                             Text(skill.label)
                         }
                     }
                    
                    TableColumn("Confidence", value: \.confidenceString!)
                    // MARK: This may result in an error bc of force unwrapping. uncomment the other table column to protect against this.
//                    TableColumn("Confidence", value: \.confidenceString!)
//                    TableColumn("Confidence") { row in
//                        Text(" \(row.confidenceString ?? "")")
//                    }
                }.tableColumnHeaders(.visible).padding(.top)
                // Header row
//                HStack {
//                    Text("Skill")
//                        .fontWeight(.bold)
//                        .padding()
//                    Spacer()
//                    Text("Confidence")
//                        .fontWeight(.bold)
//                        .padding()
//                }
//                
//                List {
//                    ForEach(skillsObserved, id: \.self) { row in
//                        SkillTableRow(skill: row.label, confidence: "Confidence: \(row.confidenceString ?? "") ")
//                    }
//                }
                
//                List{
//                    ForEach(skillsObserved, id: \.self) { row in
//                        // TODO: Enable when I implement skill detail view
//    //                    NavigationLink(destination: SkillDetailView()) {
//    //                        Text(row.label)
//    //                    }
//                        HStack {
//                            Text(row.label)
//                            Spacer()
//                            Text("Confidence: \(row.confidenceString ?? "")%")
//                        }
//                        
//                    }
//                }
            }.frame(alignment: .center)
        .onAppear(perform: {
            isCameraActive = false
        }).onDisappear(perform: {
            // TODO: when I implement the detail view (for now I'm just going to disable the navigation links, I need to change this code to instead respond to a specific button click. Because I don't want to restart the camera when I go to the detail view. I'll need to disable the back button from appearing and manually create a back button
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
            Text("Confidence: \(confidence)").padding(.trailing, 5)
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



