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
    
    var body: some View {
        
        if let image = viewModel.frame {
            GeometryReader { geo in
                
                ZStack(alignment: .center) {
                    /// Full screen image
                    Image(image, scale: 3.0, orientation: .up, label: Text("Gymnast Performing \(viewModel.actionLabel ?? "" ) Skill"))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width, height: geo.size.height)
                    
                    /// Overview overlay button
                    NavigationLink(destination: OverviewView(isCameraActive: $isCameraActive, skillsObserved: viewModel.skillsObserved)) {
                        OverviewButton()
                            .padding()
                    }.frame(maxWidth: geo.size.width, maxHeight: geo.size.height, alignment: .top)
//                        .onDisappear(perform: {
//                        isCameraActive = true
//                    })
                    
                    /// Action classifier card
                    ActionClassifierCardView(skillLabel: viewModel.actionLabel ?? "No Skill").frame(maxWidth: geo.size.width, maxHeight: geo.size.height, alignment: .bottom).padding()
                }.background(.black)
                ///Uncomment this to center the view vertically
//                .frame(maxHeight: .infinity, alignment: .center)
//                    .ignoresSafeArea().background(.black)
            }.onChange(of: isCameraActive) {
                // At this point, isCameraActive should be non-nil
                guard let cameraEnabled = isCameraActive else  { return }
                cameraEnabled ? viewModel.frameHandler.enableCaptureSession() : viewModel.frameHandler.disableCaptureSession()
            }
        } else {
            /// This is for preview purposes only. I may just comment this out
            GeometryReader { geo in
                ZStack(alignment: .center) {
                    
                    /// Full screen image
                    Image("simone")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width, height: geo.size.height)
                    
                    /// Overview overlay button
                    NavigationLink(destination: OverviewView(isCameraActive: $isCameraActive, skillsObserved: [])) {
                        OverviewButton()
                            .padding()
                        
                    }.frame(maxWidth: geo.size.width, maxHeight: geo.size.height, alignment: .topTrailing)
                    
                    /// Action classifier card
                    ActionClassifierCardView().frame(maxWidth: geo.size.width, maxHeight: geo.size.height, alignment: .bottom).padding()
                }.background(.black)
                    
            }
        }
    }
}

struct OverviewButton: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25).fill(Color.gray.opacity(0.5))
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
