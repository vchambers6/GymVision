//
//  FrameView.swift
//  LiveCameraSwiftUI
//
//  Created by Vanessa Chambers on 2/14/24.
//

import SwiftUI

struct FrameView: View {
    
    @StateObject private var viewModel = FrameViewModel()
    @State private var isCameraActive: Bool?
    
    // This is for dismissing views -- because I am using a custom nav bar
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        if let image = viewModel.frame {
        /// Uncomment this for preview purposes
//        if true {
            GeometryReader { geo in
                VStack {
                    ZStack(alignment: .center) {
                        /// Full screen image
                        Image(image, scale: 3.0, orientation: .up, label: Text("Gymnast Performing \(viewModel.actionLabel ?? "" ) Skill"))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width, height: geo.size.height)
                        
                        /// Uncomment this for preview purposes
//                        Image("simone")
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: geo.size.width, height: geo.size.height)
                        
                        /// Back button
                        BackButton(buttonTitle: "Home") {
                            presentationMode.wrappedValue.dismiss()
                        }.frame(maxWidth: geo.size.width, maxHeight: geo.size.height, alignment: .topLeading).padding()
//                        TopNavigationBar(backButtonTitle: "Home") {
//                            // Dismiss the view when the custom back button is tapped
//
//                        }
                        /// Overview overlay button
                        NavigationLink(destination: OverviewView(isCameraActive: $isCameraActive, skillsObserved: viewModel.skillsObserved)) {
                            OverviewButton()
                                .padding()
                        }.frame(maxWidth: geo.size.width, maxHeight: geo.size.height, alignment: .topTrailing)
    //                        .onDisappear(perform: {
    //                        isCameraActive = true
    //                    })
                        
                        /// Action classifier card
                        ActionClassifierCardView(skillLabel: viewModel.actionLabel ?? "No Skill").frame(maxWidth: geo.size.width, maxHeight: geo.size.height, alignment: .bottom).padding()
                    }
                }.navigationBarHidden(true)
                
                .background(.black).navigationBarHidden(true)
                ///Uncomment this to center the view vertically
//                .frame(maxHeight: .infinity, alignment: .center)
//                    .ignoresSafeArea().background(.black)
            }.onChange(of: isCameraActive) {
                // At this point, isCameraActive should be non-nil
                guard let cameraEnabled = isCameraActive else  { return }
                cameraEnabled ? viewModel.frameHandler.enableCaptureSession() : viewModel.frameHandler.disableCaptureSession()
            }
        } else {
            Text("AI feature unavailable.")
        }
    }
}

struct OverviewButton: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25).fill(Color.gray.opacity(0.6))
            Label(
                title: {
                    Text("Overview")
                        .font(.headline)
                        .foregroundColor(.white)
                },
                icon: {
                    Image(systemName: "arrowshape.forward.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                }
            ).labelStyle(.titleOnly)
        }
        .frame(width: 130, height: 30)
    }
}

#Preview {
    FrameView()
}
