//
//  ActionClassifierCardView.swift
//  GymVision
//
//  Created by Vanessa Chambers on 2/22/24.
//

import SwiftUI

struct ActionClassifierCardView: View {
    var skillLabel: String = "No Skill Observed"
    var confidence: String? = "No Confidence Level"
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25).fill(Color.actionClassifierCardBG.opacity(0.85))
            VStack {
                Text(skillLabel).font(AppFonts.LargeTitleBold.font).foregroundStyle(.black).minimumScaleFactor(0.5).lineLimit(1)
                if let confidenceString = confidence {
                    Text("Confidence: \(confidenceString)").font(AppFonts.TextTitleSecondary.font).foregroundStyle(.secondary)
                }
                
            }.padding(4)
                .multilineTextAlignment(.center)
        }.frame(width: 300, height: 150)
    }
}

#Preview {
    ActionClassifierCardView()
}
