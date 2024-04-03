//
//  ApparatusIconView.swift
//  GymVision
//
//  Created by Vanessa Chambers on 4/2/24.
//

import SwiftUI

struct ApparatusIconView: View {
    var apparatus: Apparatus
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.mnBtnBG) // Adjust the color as needed
                    .frame(width: calculateSize(), height: calculateSize())  // Adjust the size as needed
                
                Text(apparatus.rawValue)
                    .font(AppFonts.SmallButtonText.font) // Adjust the font as needed
                    .foregroundColor(.white) // White color for the text
            }.aspectRatio(1.0, contentMode: .fit)
        }
    
    // Function to calculate the width of the background square
        private func calculateSize() -> CGFloat {
            let size = apparatus.rawValue.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)]) // Adjust the font size as needed
            return size.width + 8
            // Add some padding
        }
}

#Preview {
    ApparatusIconView(apparatus: Apparatus.VT)
}
