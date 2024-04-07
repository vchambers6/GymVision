//
//  IconView.swift
//  GymVision
//
//  Created by Vanessa Chambers on 4/3/24.
//

import SwiftUI

struct IconView: View {
    var iconText: String
    var popOverText: String
    @State private var showingPopover = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button {
            self.showingPopover = true
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.primaryIcon) // Adjust the color as needed
                    .frame(width: 68, height: 45)  // Adjust the size as needed
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.primaryBorder, lineWidth: 1.5)
                    )
                
                Text(iconText)
                    .font(AppFonts.MediumButtonText.font)
                    .foregroundColor(Color.secondaryIcon)
            }.aspectRatio(1.0, contentMode: .fit)
        }.popover(isPresented: $showingPopover, content: {
            ZStack {
                Color.primaryIcon.ignoresSafeArea(.all)
                Text(popOverText).font(AppFonts.PlainTextSemiBold.font).foregroundStyle(Color.secondaryIcon)
                    .padding()
            }
            
        })
    }
}

#Preview {
    IconView(iconText: "WAG", popOverText: "This skill is under the code of points for WAG")
}
