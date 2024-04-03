//
//  SearchBarView.swift
//  GymVision
//
//  Created by Vanessa Chambers on 4/2/24.
//
// Created with help from this post: https://stackoverflow.com/questions/58012540/ios-swiftui-searchbar-and-rest-api


import SwiftUI

struct SearchBarView: View {
    
    @State var queryString: String = ""
    @ObservedObject var viewModel: SearchViewModel
    @Binding var loadingState: LoadingState
    
    var body: some View {
        
        HStack {
            TextField(
                "Search for skill...",
                text: $queryString,
                onCommit: performSearch
            ).textFieldStyle(RoundedBorderTextFieldStyle()).font(AppFonts.PlainText.font)
            Spacer()
            switch loadingState {
            case .dormant, .failed:
                Button(action: performSearch) {
                    Image(systemName: "magnifyingglass").resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color.mnBtnBG)
                }
            case .loading:
                ProgressView()
            }
            
        }
    }
    
    func performSearch() {
        loadingState = .loading
        Task {
            do {
                try await viewModel.getSkills(containing: queryString)
                loadingState = .dormant
            } catch {
                // Handle error
                print("Error: \(error)")
                loadingState = .failed
            }
        }
    }
}

//#Preview {
//    SearchBarView()
//}
