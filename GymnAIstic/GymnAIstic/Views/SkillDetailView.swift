//
//  SkillDetailView.swift
//  GymnAIstic
//
//  Created by Vanessa Chambers on 2/23/24.
//

import SwiftUI

struct SkillDetailView: View {
    var skillCOPNumber: Double
    var body: some View {
        Text(String(skillCOPNumber))
    }
}

#Preview {
    SkillDetailView(skillCOPNumber: 35.204)
}
