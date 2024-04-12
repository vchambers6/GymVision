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
    @StateObject var viewModel: SkillDetailViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init(skill: Skill) {
        self.skill = skill
        _viewModel = StateObject(wrappedValue: SkillDetailViewModel(skill: skill))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background color
                Color.primaryBG.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                ScrollView(.vertical) {
                    
                    ZStack {
                        // Blurred background
                        Color.secondaryBG.blur(radius: 18)
                        VStack {
                            Text(skill.name)
                                .font(AppFonts.LargeTitleBolder.font)
                                .foregroundColor(Color.primaryTitleText)
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
                        IconView(iconText: skill.discipline.disciplineAbbreviationString, popOverText: viewModel.disciplineText)
                        Spacer()
                        IconView(iconText: skill.apparatus.apparatusAbbreviationString, popOverText: viewModel.apparatusText)
                        if skill.difficultyValue != nil || skill.vaultDifficultyValue != nil {
                            Spacer()
                            IconView(iconText: viewModel.dValue, popOverText: viewModel.dValueText)
                        }
                    }.padding(.top, 45).padding(.bottom, 15).padding(.horizontal, 30)
                        .scrollTransition(.animated.threshold(.visible(0.9))) { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1 : 0)
                                    .scaleEffect(phase.isIdentity ? 1 : 0.75)
                                    .blur(radius: phase.isIdentity ? 0 : 10)
                            }
                    CategoryCardView(mainText: viewModel.categoryLabel, popOverText: viewModel.categoryDescription).padding(.horizontal, 30).padding(.top, 15).padding(.bottom, 20)
                        .scrollTransition(.animated.threshold(.visible(0.9))) { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1 : 0)
                                    .scaleEffect(phase.isIdentity ? 1 : 0.75)
                                    .blur(radius: phase.isIdentity ? 0 : 10)
                            }
                    VStack {
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
                        
                        if let namedAfterString = viewModel.namedAfterString  {
                            Text(namedAfterString)
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
                    }.foregroundStyle(.primaryBodyText)
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
    @State var skill = Skill(name: "Back Handspring Stepout", discipline: .WAG, apparatus: .BB, difficultyValue: .B, description: "Flic-flac with step-out, also with support on one arm", copNumber: 5.204, groupNumber: 5, namedAfterWAG: [Gymnast(lastName: "Chambers", firstName: "Vanessa", federation: "USA")])
    
    return SkillDetailView(skill: skill)
}


