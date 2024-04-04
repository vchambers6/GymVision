//
//  FetchedSkillDetailView.swift
//  GymVision
//
//  Created by Vanessa Chambers on 2/23/24.
//

import SwiftUI

struct FetchedSkillDetailView: View {
    @StateObject var viewModel = SkillDetailViewModel()
    let uuidString: String
    @State private var loadingFailed = false
    
//    var skillCOPNumber: Double
    var body: some View {
        VStack {
            if let skill = viewModel.skill {
                SkillDetailView(skill: skill)
            } else if loadingFailed {
                Text("🥲 GymVision failed to load skill details")
            } else {
                ProgressView {
                    Text("🤸🏾‍♂️Loading Skill Details...").onAppear {
                        /// If video feature doesn't load after 10 seconds, show the timeout view.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                            if self.viewModel.skill == nil {
                                self.loadingFailed = true
                            }
                        }
                    }
                }
            }
        }.onAppear {
            Task {
                do {
                    try await viewModel.fetchSkill(at: uuidString)
                } catch {
                    print("❌ Error: \(error)")
                }
                
            }
        }
    }
        
}

#Preview {
    FetchedSkillDetailView(uuidString: "212F18A9-127F-43D4-984E-8FA174C0C240")
}


//
//let skillsDictionary: [Double: Skill] = [
//    35.204 : Skill(copNumber: 35.204, name: "Back Handspring Stepout", description: #"""Flic-flac with step-out, also with support on one arm"""#, apparatus: .BB, difficultyValue: "B", gifName: "back_handspring_so_3")
//]
