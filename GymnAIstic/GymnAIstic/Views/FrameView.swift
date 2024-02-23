//
//  FrameView.swift
//  LiveCameraSwiftUI
//
//  Created by Vanessa Chambers on 2/14/24.
//

import SwiftUI

struct FrameView: View {
    var image: CGImage?
    var label: String?
    var body: some View {
        
        if let image = image {
            GeometryReader { geo in
                Color.black
                    .frame(height: .infinity, alignment: .center)
                                       .ignoresSafeArea()
                ZStack(alignment: .center) {
                    /// Full screen image
                    Image(image, scale: 3.0, orientation: .up, label: Text("Gymnast Performing \(label ?? "" ) Skill"))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width, height: geo.size.height)
                    
                    /// Overview overlay button
                    NavigationLink(destination: OverviewView()) {
                        OverviewButton()
                            .padding()
                    }.frame(maxWidth: geo.size.width, maxHeight: geo.size.height, alignment: .topTrailing)
                    
                    /// Action classifier card
                    ActionClassifierCardView(skillLabel: label ?? "No Skill").frame(maxWidth: geo.size.width, maxHeight: geo.size.height, alignment: .bottom).padding()
                }
            }
        } else {
            
            GeometryReader { geo in
                Color.black
                    .frame(height: .infinity, alignment: .center)
                                       .ignoresSafeArea()
                ZStack(alignment: .center) {
                    /// Full screen image
                    Image("simone")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width, height: geo.size.height)
                    
                    /// Overview overlay button
                    NavigationLink(destination: OverviewView()) {
                        OverviewButton()
                            .padding()
                    }.frame(maxWidth: geo.size.width, maxHeight: geo.size.height, alignment: .topTrailing)
                    
                    /// Action classifier card
                    ActionClassifierCardView().frame(maxWidth: geo.size.width, maxHeight: geo.size.height, alignment: .bottom).padding()
                }
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
            )
        }
        .frame(width: 130, height: 30)
    }
}
        // MARK: OLD CODE -- NO WHITE BACKGROUND ON THIS
//        ZStack {
//            RoundedRectangle(cornerRadius: 25).fill(.gray.opacity(0.5))
//            
//            Button {
//                
//                print("Push to OverviewView")
//            } label: {
//                Label(
//                    title: { Text("Overview").font(.headline) },
//                    icon: { Image(systemName: "arrowshape.forward.circle").resizable()
//                            .scaledToFit()
//                        .frame(width: 20, height: 20) }
//                ).labelStyle(.titleAndIcon).foregroundColor(.white)
//            }
//            
//        }.frame(width: 130, height: 30)


#Preview {
    FrameView()
}
