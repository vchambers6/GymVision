//
//  OverviewView.swift
//  GymVision
//
//  Created by Vanessa Chambers on 2/22/24.
//

import SwiftUI

// TODO: WHEN THIS VIEW IS PUSHED ON THE STACK, I NEED TO PAUSE VIDEO CAPTURE AND RESUME WHEN THIS VIEW COMES OFF THE STACK
struct OverviewView: View {
    @Binding var isCameraActive: Bool?
    
    var skillsObserved: [ActionPrediction]
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.presentationMode) var presentationMode
    

    var body: some View {
        NavigationView {
            VStack {
                    List(skillsObserved) { skill in
                        // TODO: NEED TO CHANGE THE UUID TO WHATEVER VAL IN DICT FOR THAT SKILL instead of the hard coded string -- i think i did this
                        NavigationLink(destination: FetchedSkillDetailView(uuidString: skill.uuidString)) {
                            SkillTableRowView(skill: skill.label, confidence: skill.confidenceString!)
                        }     
                    }.background(Color.primaryBG)
                    .scrollContentBackground(.hidden)
            }
        }.frame(alignment: .center)
        .onAppear(perform: {
            isCameraActive = false
        }).onDisappear(perform: {
            isCameraActive = true
        }).navigationBarTitleDisplayMode(.inline).toolbar {
            ToolbarItem(placement: .principal) {
                Text("Skills Observed").font(AppFonts.PlainTextSemiBold.font).foregroundStyle(.primaryBodyText)
            }
            ToolbarItem(placement: .topBarLeading) {
                BackButton {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }.navigationBarBackButtonHidden()
        
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



