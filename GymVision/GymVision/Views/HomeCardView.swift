//
//  HomeCardView.swift
//  GymVision
//
//  Created by Vanessa Chambers on 4/11/24.
//

import SwiftUI

//struct HomeCardView: View {
//    var title = "What's new on GymVision"
//    var subtitle = "v1.0"
//    var body: some View {
//        VStack {
//            
//            VStack {
//                Text(title).font(AppFonts.TextTitleBolder.font).foregroundStyle(Color.primaryTitleText).multilineTextAlignment(.center).minimumScaleFactor(0.5)
//                Text(subtitle).font(AppFonts.PlainText.font).foregroundStyle(Color.primaryBodyText).multilineTextAlignment(.center).minimumScaleFactor(0.5)
//            }.padding(.bottom, 20)
//            Text("GymVision is officially released! The first version (v1.0) features:").font(AppFonts.PlainText.font)
//            
//            Spacer()
//        }.frame(maxHeight: 400, alignment: .center).padding(30)
//    }
//}
struct HomeCardView<Content: View>: View {
    var title: String?
    var subtitle: String?
    var iconSystemName: String?
    let content: Content
    
    init(title: String? = nil, subtitle: String? = nil, iconSystemName: String? = nil, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.title = title
        self.iconSystemName = iconSystemName
        self.subtitle = subtitle
    }
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10).stroke(Color.primaryBorder, lineWidth: 1.5).fill(Color.secondaryBG).shadow(radius: 5)
            
            VStack {
                
                if let title = self.title {
                    VStack {
                        if let iconSystemName = self.iconSystemName {
                            HStack {
                                Image(systemName: iconSystemName).resizable()
                                    .aspectRatio(contentMode: .fit).foregroundColor(Color.secondaryAccent).frame(width: 25, height: 25)
                                Text(title).font(AppFonts.TextTitleBolder.font).foregroundStyle(Color.primaryTitleText).multilineTextAlignment(.center).minimumScaleFactor(0.5).lineLimit(1)
                            }
                        } else {
                            Text(title).font(AppFonts.TextTitleBolder.font).foregroundStyle(Color.primaryTitleText).multilineTextAlignment(.center).minimumScaleFactor(0.5)
                        }
                        
                        if let subtitle = self.subtitle {
                            Text(subtitle).font(AppFonts.SubtitleText.font).foregroundStyle(Color.primaryBodyText).multilineTextAlignment(.center).minimumScaleFactor(0.5)
                        }
                    }.padding(.bottom, 20)
                }
                content.minimumScaleFactor(0.5)
                Spacer()
            }.frame(alignment: .center).padding(15)
        }.padding(20).frame(maxHeight: 500)
    }
}
//
////struct HomeCardView: View {
////    var body: some View {
////        TabView {
////            Image("yose")
////            Image("yose")
////            Image("yose")
////        }.tabViewStyle(.page(indexDisplayMode: .always))
////            .indexViewStyle(.page(backgroundDisplayMode: .always))
////    }
////}
//
//struct UpdateCardView:View {
//    var bodyText: String = "GymVision is officially released! The first version (v1.0) features:"
//    var body: some View {
//        Text(bodyText).font(AppFonts.PlainText.font).foregroundStyle(Color.primaryBodyText)
//        
//    }
//}

