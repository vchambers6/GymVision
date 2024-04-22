//
//  TestModelView.swift
//  GymVision
//
//  Created by Vanessa Chambers on 4/21/24.
//

import SwiftUI

struct TestModelView: View {
    var skillsFrames: [TestFrame]
    var body: some View {
        ScrollView {
            ForEach(skillsFrames) { frame in
                VStack {
                    Image(uiImage: frame.image)
                    Text(String(frame.frameCount))
                }
                
            }
        }
    }
}

//#Preview {
//    TestModelView()
//}
