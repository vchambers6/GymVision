//
//  TopNavigationBar.swift
//  GymnAIstic
//
//  Created by Vanessa Chambers on 2/24/24.
//
// This code was generated via ChatGPT on 2/24/23

import SwiftUI


struct BackButton: View {
    var buttonTitle: String = "Back"
    var backButtonAction: () -> Void
    
    var body: some View {
        Button(action: {
            backButtonAction()
        }) {
            Image(systemName: "chevron.left")
            Text(buttonTitle)
        }
        .foregroundColor(.blue)
        
    }
}

//struct TopNavigationBar: View {
//    var title: String?
//    var backButtonTitle: String = "Back"
//    var backButtonAction: () -> Void
//    
//    
//    var body: some View {
//        
//        HStack { }.toolbar {
//            
//            ToolbarItem {
//                Button(action: {
//                    backButtonAction()
//                }) {
//                    Image(systemName: "chevron.left")
//                    Text(backButtonTitle)
//                }
//                .foregroundColor(.blue)
//                
//            }
//        }
//
////        GeometryReader { geo in
////            VStack {
////                HStack {
////                    Button(action: {
////                        backButtonAction()
////                    }) {
////                        Image(systemName: "chevron.left")
////                        Text(backButtonTitle)
////                    }
////                    .foregroundColor(.blue)
////                    
////                    Spacer()
////                    if let header = title {
////                        Text(header)
////                            .font(.headline).frame(maxWidth: .infinity, alignment: .center)
////                            .multilineTextAlignment(.center)
////                    }
////                    Spacer()
////                    
////                }
////                .padding()
////                .background(Color(UIColor.systemBackground))
////                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
////                
////                Spacer(minLength: 0) // Push content to the top
////            }
////        }
//    }
//}
//
////struct ContentView: View {
////    var body: some View {
////        NavigationView {
////            VStack {
////                Text("Your Content Here")
////            }
////            .navigationBarHidden(true) // Hide default navigation bar
////            
////            CustomNavigationBar(title: "Detail", backButtonTitle: "Back") {
////                // Custom back button action
////                print("Back button tapped")
////            }
////        }
////    }
////}



#Preview {
    BackButton(buttonTitle: "Back", backButtonAction: {print("Test View")})
}



