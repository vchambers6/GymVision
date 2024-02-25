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
    @State private var showTimeoutView = false
    
    /// This is for dismissing views -- because I am using a custom nav bar in this view
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
                        
                        /// Custom back button; returns to home view on tap
                        BackButton(buttonTitle: "Home") {
                            presentationMode.wrappedValue.dismiss()
                        }.frame(maxWidth: geo.size.width, maxHeight: geo.size.height, alignment: .topLeading).padding()

                        /// Overview overlay button
                        NavigationLink(destination: OverviewView(isCameraActive: $isCameraActive, skillsObserved: viewModel.skillsObserved)) {
                            OverviewButton()
                                .padding()
                        }.frame(maxWidth: geo.size.width, maxHeight: geo.size.height, alignment: .topTrailing)
                        
                        /// Action classifier card
                        ActionClassifierCardView(skillLabel: viewModel.actionLabel ?? "No Skill Observed", confidence: viewModel.confidenceString).frame(maxWidth: geo.size.width, maxHeight: geo.size.height, alignment: .bottom).padding()
                    }
                }.navigationBarHidden(true)
                
                .background(.black).navigationBarHidden(true)
            }
            /// This pauses the frame capture + processing when navigating to the OverviewView
            .onChange(of: isCameraActive) {
                /// At this point, isCameraActive should be non-nil
                guard let cameraEnabled = isCameraActive else  { return }
                cameraEnabled ? viewModel.frameHandler.enableCaptureSession() : viewModel.frameHandler.disableCaptureSession()
            }
        } else {
            if showTimeoutView {
                Text("AI feature failed to load.")
            } else {
                ProgressView {
                    Text("Loading AI feature...").onAppear {
                        /// If video feature doesn't load after 10 seconds, show the timeout view.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                            if self.viewModel.frame == nil {
                                self.showTimeoutView = true
                            }
                        }
                    }
                }
            }
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
