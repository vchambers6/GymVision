//
//  SkillTableRowView.swift
//  GymVision
//
//  Created by Vanessa Chambers on 4/7/24.
//

import SwiftUI

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
                Text(skill).padding(.leading, 5).font(AppFonts.PlainText.font).foregroundStyle(.primaryBodyText)
            }
            
            if let confidence = confidence {
                Spacer()
                Text("Confidence: \(confidence)").padding(.trailing, 5).minimumScaleFactor(0.5).lineLimit(1).font(AppFonts.PlainText.font)
            }
            
        }
    }
}

#Preview {
    SkillTableRowView(skill: "Back Handspring", apparatus: .BB)
}
