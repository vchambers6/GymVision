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
            ZStack {
                Image(image, scale: 3.0, orientation: .up, label: Text("Gymnast Performing \(label ?? "" ) Skill")).resizable().aspectRatio(contentMode: .fill)
                /// Overview Button
                
                HStack {
                    Spacer()
                    VStack {
                        NavigationLink(destination: OverviewView()) {
                            OverviewButton().padding(75)
                        }
                        Spacer()
                    }
                }
                
                
                ActionClassifierCardView(skillLabel: label ?? "No Skill").offset(y: 100)
            }
            
        } else {
            ZStack {
                
               Image("simone").resizable()
                    .aspectRatio(contentMode: .fill).zIndex(1)
                /// Overview Button
                VStack {
                    HStack {
                        Spacer()
                        NavigationLink(destination: OverviewView()) {
                            OverviewButton()
                        }
                        .buttonStyle(PlainButtonStyle()) // Remove the default button style to avoid extra padding
                        .padding(.trailing).zIndex(2) // Adjust the padding as needed
                    }
                    Spacer()
                }
                
                
                    
//                OverviewButton().offset(x: 120, y:-340)
                ActionClassifierCardView().offset(y: 280).zIndex(2)
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
