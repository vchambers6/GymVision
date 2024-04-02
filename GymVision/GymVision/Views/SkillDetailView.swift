//
//  SkillDetailView.swift
//  GymVision
//
//  Created by Vanessa Chambers on 2/23/24.
//

import SwiftUI

struct SkillDetailView: View {
    @StateObject var viewModel = SkillDetailViewModel()
    let uuidString: String
    
//    var skillCOPNumber: Double
    var body: some View {
        // MARK: This uses the old skill struct. I want to use new one
        //        if let skill = skillsDictionary[skillCOPNumber] {
        //                // ScrollView {
        //                VStack {
        //                    ZStack {
        //                        // TODO: I need to figure out how to make this fullscreen
        //                        GifImage(skill.gifName!).edgesIgnoringSafeArea(.all)//.frame(width: geometry.size.width, height: geometry.size.height)
        //                        //                            .resizable()
        //                        //                            .aspectRatio(contentMode: .fill)
        //                        //                            .edgesIgnoringSafeArea(.all)
        //
        //                        // TODO: The spacing for all of this stuff is way off. need to change that.
        //                        VStack() {
        //                            Text(skill.name)
        //                                .font(.largeTitle)
        //                                .fontWeight(.bold)
        //                                .foregroundColor(.white)
        //                                .multilineTextAlignment(.center).frame(alignment: .top)
        //                                .padding(.top, 10)
        //                            Spacer()
        //                            HStack {
        //                                RoundedRectangle(cornerRadius: 15)
        //                                    .frame(width: 100, height: 50)
        //                                    .foregroundColor(.blue)
        //                                    .overlay(
        //                                        Text(skill.apparatus.rawValue)
        //                                            .foregroundColor(.white)
        //                                    )
        //                                    .padding(.bottom, 50)
        //                                    .padding(.leading, 20)
        //                                Spacer()
        //                                RoundedRectangle(cornerRadius: 15)
        //                                    .frame(width: 100, height: 50)
        //                                    .foregroundColor(.green)
        //                                    .overlay(
        //                                        Text(skill.difficultyValue!)
        //                                            .font(.title)
        //                                            .foregroundColor(.white)
        //                                    )
        //                                    .padding(.bottom, 50) // Adjust bottom padding as needed
        //                                    .padding(.trailing, 20)
        //
        //                            }
        //                        }
        //
        //
        //                    }
        //                    //                    Image(systemName: "arrow.down.circle.fill")
        //                    //                        .resizable()
        //                    //                        .frame(width: 30, height: 30)
        //                    //                        .foregroundColor(.gray)
        //                    //                        .padding(.bottom, 20)
        //                }
        //                //}
        //        }
        //        else {
        //            Text(String(skillCOPNumber))
        //        }
        VStack {
            Text(viewModel.skill?.name ?? "❌ FAILED")
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
    SkillDetailView(viewModel: SkillDetailViewModel(), uuidString: "212F18A9-127F-43D4-984E-8FA174C0C240")
}
//
//let skillsDictionary: [Double: Skill] = [
//    35.204 : Skill(copNumber: 35.204, name: "Back Handspring Stepout", description: #"""Flic-flac with step-out, also with support on one arm"""#, apparatus: .BB, difficultyValue: "B", gifName: "back_handspring_so_3")
//]
