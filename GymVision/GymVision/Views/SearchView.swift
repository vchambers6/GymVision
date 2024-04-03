//
//  SearchView.swift
//  GymVision
//
//  Created by Vanessa Chambers on 4/2/24.
//

import SwiftUI

struct SearchView: View {
    
    @StateObject var viewModel = SearchViewModel()
    @State var loadingState: LoadingState = .dormant
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.mnPrimaryThemeBG.ignoresSafeArea(.all)
                VStack {
                    SearchBarView(viewModel: viewModel, loadingState: $loadingState).padding(.leading).padding(.trailing)
                    Spacer()
                    HStack {
                        switch loadingState {
                        case .loading, .dormant:
                            List(viewModel.skills) { skill in
                                // TODO: NEED TO CHANGE THE UUID TO WHATEVER VAL IN DICT FOR THAT SKILL instead of the hard coded string
                                NavigationLink(destination: StaticSkillDetailView()) {
                                    SkillTableRowView(skill: skill.name)
                                }
                                
                            }.background(Color.mnPrimaryThemeBG)
                                .scrollContentBackground(.hidden)
                        case .failed:
                            Text("Search Failed").font(AppFonts.PlainText.font)
                        }
                    }
                }
            }
        }.toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton(buttonTitle: "Home") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }.navigationBarBackButtonHidden()
    }
}

#Preview {
    SearchView()
}

enum LoadingState {
    case dormant, loading, failed
}
