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
                        // TODO: NEED TO CHANGE THE UUID TO WHATEVER VAL IN DICT FOR THAT SKILL instead of the hard coded string
                        NavigationLink(destination: FetchedSkillDetailView(uuidString: skill.uuidString)) {
                            SkillTableRowView(skill: skill.label, confidence: skill.confidenceString!)
                        }
                        
                    }.background(Color.mnPrimaryThemeBG)
                    .scrollContentBackground(.hidden)

            }
                
        }.frame(alignment: .center)
        .onAppear(perform: {
            isCameraActive = false
        }).onDisappear(perform: {
            isCameraActive = true
        }).navigationBarTitleDisplayMode(.inline).toolbar {
            ToolbarItem(placement: .principal) {
                Text("Skills Observed").font(AppFonts.PlainTextSemiBold.font)
            }
            ToolbarItem(placement: .topBarLeading) {
                BackButton {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }.navigationBarBackButtonHidden()
        
    }
}

struct SkillTableRowView: View {
    var skill: String
    var apparatus: Apparatus?
    var confidence: String?
    
    var body: some View {
        HStack {
            HStack {
                if let apparatus = apparatus {
                    ApparatusIconView(apparatus: apparatus)
                }
                Text(skill).padding(.leading, 5).font(AppFonts.PlainText.font)
            }
            
            if let confidence = confidence {
                Spacer()
                Text("Confidence: \(confidence)").padding(.trailing, 5).minimumScaleFactor(0.5).lineLimit(1).font(AppFonts.PlainText.font)
            }
            
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



