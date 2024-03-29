//
//  SkillDetailView.swift
//  GymVision
//
//  Created by Vanessa Chambers on 2/23/24.
//

import SwiftUI

struct SkillDetailView: View {
    var skillCOPNumber: Double
    var body: some View {
        if let skill = skillsDictionary[skillCOPNumber] {
            ScrollView {
                VStack {
                    ZStack {
                        // TODO: I need to figure out how to make this fullscreen
                        GifImage(skill.gifName!).edgesIgnoringSafeArea(.all).aspectRatio(contentMode: .fill)
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .edgesIgnoringSafeArea(.all)
                        
                        // TODO: The spacing for all of this stuff is way off. need to change that. 
                        Text(skill.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.top, 50)
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 100, height: 50)
                            .foregroundColor(.blue)
                            .overlay(
                                Text(skill.apparatus.rawValue)
                                    .foregroundColor(.white)
                            )
                            .padding(.bottom, 50)
                            .padding(.leading, 20)
                        RoundedRectangle(cornerRadius: 15)
                                .frame(width: 100, height: 50)
                                .foregroundColor(.green)
                                .overlay(
                                    Text(skill.difficultyValue!)
                                        .font(.title)
                                        .foregroundColor(.white)
                                )
                                .padding(.bottom, 50) // Adjust bottom padding as needed
                                .padding(.trailing, 20)
                        
                    }
                    Image(systemName: "arrow.down.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.gray)
                        .padding(.bottom, 20)
                }
            }    
        }
        else {
            Text(String(skillCOPNumber))
        }
    }
        
}

#Preview {
    SkillDetailView(skillCOPNumber: 35.204)
}

let skillsDictionary: [Double: Skill] = [
    35.204 : Skill(copNumber: 35.204, name: "Back Handspring Stepout", description: #"""Flic-flac with step-out, also with support on one arm"""#, apparatus: .BB, difficultyValue: "B", gifName: "back_handspring_so_3")
]
