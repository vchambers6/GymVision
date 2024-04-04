//
//  SkillDetailView.swift
//  GymVision
//
//  Created by Vanessa Chambers on 2/23/24.
//

import SwiftUI

struct SkillDetailView: View {
    var skill: Skill
    var gifName: String = "back_handspring_so_3"
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    //    var skillCOPNumber: Double
    var body: some View {
        NavigationView {
            ZStack {
                Color.mnPrimaryThemeBG.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                ScrollView(.vertical) {
                    
                    ZStack {
                        Color.white.blur(radius: 10)
                        VStack {
                            Text(skill.name)
                                .font(AppFonts.LargeTitleBold.font)
                                .foregroundColor(AppFonts.LargeTitleBold.color)
                                .multilineTextAlignment(.center)
                            GifImage(gifName, cornerRadius: 20)
                            Text("Scroll to see more")
                                .font(AppFonts.PlainText.font)
                                .foregroundColor(.gray)
                                .padding(.top, 20)
                            Image(systemName: "arrow.down")
                                .font(.system(size: 18))
                                .foregroundColor(.gray)
                        }.padding(30)
                    }.frame(idealHeight: UIScreen.main.bounds.height - 100)
                    
                    HStack {
                        
                        let disciplineText = "This skill is under the code of points for \(skill.discipline.fullNameString)."
                        let apparatusText = "This skill is performed on the \(skill.apparatus.apparatusString.lowercased()) apparatus. \(skill.discipline.fullNameString) contains four apparatus: vault, uneven bars, balance beam, and floor exercise."
                        
                        IconView(iconText: skill.discipline.disciplineAbbreviationString, popOverText: disciplineText)
                        Spacer()
                        IconView(iconText: skill.apparatus.apparatusAbbreviationString, popOverText: apparatusText)
                        if let dValue = skill.difficultyValue {
                            let dValueText = "This skill has a difficulty value of '\(dValue.rawValue).' Skills on the uneven bars, balance beam, and floor exercise can have difficulty values ranging from A (least difficult) to J (most difficult)."
                            Spacer()
                            IconView(iconText: dValue.rawValue, popOverText: dValueText)
                        } else if let dValue = skill.vaultDifficultyValue {
                            let dValueText = "This skill has a difficulty value of \(String(dValue)). Skills on vault can have difficulty values ranging from 2.0 (least difficult) to 6.4 (most difficult)."
                            Spacer()
                            IconView(iconText: String(dValue), popOverText: dValueText)
                        }
                        
                    }.padding(.top, 15).padding(30)
                        .scrollTransition(.animated.threshold(.visible(0.9))) { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1 : 0)
                                    .scaleEffect(phase.isIdentity ? 1 : 0.75)
                                    .blur(radius: phase.isIdentity ? 0 : 10)
                            }
                    VStack {
//                        GeometryReader { geometry in
                            Text("**Official Description:** \(skill.description)")
                                .font(AppFonts.PlainText.font)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 30)
                                .padding(.bottom, 20)
                                .scrollTransition(.animated.threshold(.visible(0.9))) { content, phase in
                                    content
                                        .opacity(phase.isIdentity ? 1 : 0)
                                        .scaleEffect(phase.isIdentity ? 1 : 0.75)
                                        .blur(radius: phase.isIdentity ? 0 : 10)
                                }
                            
                            if let namedAfter = skill.namedAfter {
                                Text("This skill is named after **\(namedAfter)** in the 2022-2024 Code of Points.")
                                    .font(AppFonts.PlainText.font)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            
                                    .padding(.horizontal, 30)
                                    .padding(.bottom, 30)
                                    .scrollTransition(.animated.threshold(.visible(0.9))) { content, phase in
                                        content
                                            .opacity(phase.isIdentity ? 1 : 0)
                                            .scaleEffect(phase.isIdentity ? 1 : 0.75)
                                            .blur(radius: phase.isIdentity ? 0 : 10)
                                    }
                            }
//                        }
                    }
                }
            }
        }.toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton() {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }.navigationBarBackButtonHidden()

    }
}



#Preview {
    @State var skill = Skill(name: "Back Handspring Stepout", discipline: .wag, apparatus: .BB, difficultyValue: .B, description: "Flic-flac with step-out, also with support on one arm", copNumber: 5.204, groupNumber: 5, namedAfter: "Vanessa Chambers")
    
    return SkillDetailView(skill: skill)
}


//
//let skillsDictionary: [Double: Skill] = [
//    35.204 : Skill(copNumber: 35.204, name: "Back Handspring Stepout", description: #"""Flic-flac with step-out, also with support on one arm"""#, apparatus: .BB, difficultyValue: "B", gifName: "back_handspring_so_3")
//]
