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
    
//    @State private var searchText = ""
    
    
    @Environment(\.isSearching) private var isSearching
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Color
                Color.primaryBG.ignoresSafeArea(.all)
                HStack {
                    switch loadingState {
                    case .loading:
                        ProgressView()
                    case .dormant:
                        List(viewModel.skills) { skill in
                            // TODO: NEED TO CHANGE THE UUID TO WHATEVER VAL IN DICT FOR THAT SKILL instead of the hard coded string -- i think i've already doen that??
                            NavigationLink(destination: SkillDetailView(skill: skill)) {
                                SkillTableRowView(skill: skill.name, apparatus: skill.apparatus)
                            }
                            
                        }.background(Color.primaryBG)
                            .scrollContentBackground(.hidden)
                    case .failed:
                        Text("Search Failed").font(AppFonts.PlainText.font)
                    }
                }.searchable(text: $viewModel.queryString, prompt: "Search for a skill").onSubmit(of: .search) {
                loadingState = .loading
                    Task {
                        do {
                            try await viewModel.getSkills()
                            loadingState = .dormant
                        } catch {
                            // Handle error
                            print("Error: \(error)")
                            loadingState = .failed
                        }
                    }
                }
            }
        }.font(AppFonts.PlainText.font)
        .toolbar {
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
