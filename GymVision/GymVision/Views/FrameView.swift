//
//  FrameView.swift
//  GymVision
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
        VStack {
            if let image = viewModel.frame {
                /// Uncomment this for preview purposes
                //        if true {
                NavigationView {
                    VStack {
                        ZStack(alignment: .center) {
                            /// Full screen image
                            Image(image, scale: 3.0, orientation: .up, label: Text("Gymnast Performing \(viewModel.actionLabel ?? "" ) Skill"))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxHeight: .infinity).ignoresSafeArea()
                            /// Action classifier card
                            ActionClassifierCardView(skillLabel: viewModel.actionLabel ?? "No Skill Observed", confidence: viewModel.confidenceString).frame(maxHeight: .infinity, alignment: .bottom).padding()
                        }
                    }
                    
                    .background(.black)
                
                }.background(.black)
                    .navigationBarTitleDisplayMode(.inline).toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            BackButton(buttonTitle: "Home") {
                                viewModel.stopTasks()
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            NavigationLink(destination: OverviewView(isCameraActive: $isCameraActive, skillsObserved: viewModel.skillsObserved)) {
                                OverviewButton()
                            }
                        }
                    }.navigationBarBackButtonHidden()
                /// This pauses the frame capture + processing when navigating to the OverviewView
                    .onChange(of: isCameraActive) {
                        /// At this point, isCameraActive should be non-nil
                        guard let cameraEnabled = isCameraActive else  { return }
                        cameraEnabled ? viewModel.frameHandler.enableCaptureSession() : viewModel.frameHandler.disableCaptureSession()
                    }
            } else {
                NavigationView {
                    ZStack {
                        Color.primaryBG.ignoresSafeArea()
                        if showTimeoutView {
                            Text("AI feature failed to load.")
                                .foregroundStyle(Color.primaryBodyText)
                        } else {
                            ProgressView {
                                Text("Loading AI feature...")
                                    .foregroundStyle(Color.primaryBodyText)
                                    .onAppear {
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
                }.toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        BackButton(buttonTitle: "Home") {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }.navigationBarBackButtonHidden()
            }}
    }
}

// the button background is not showing up at all I don't think
struct OverviewButton: View {
    var body: some View {
        ZStack {
            // TODO: I need this rectangle to SHOW UP!!! it's nto showing up
            RoundedRectangle(cornerRadius: 25).fill(Color.primaryIcon.opacity(0.5))
            Label(
                title: {
                    Text("Overview")
                        .font(AppFonts.PlainTextSemiBold.font)
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
