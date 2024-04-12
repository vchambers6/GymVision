//
//  MainTheme.swift
//  GymVision
//
//  Created by Vanessa Chambers on 3/28/24.
//

import SwiftUI

struct AppFonts {
    struct PlainText {
        static let font: Font = .custom("Poppins-Light", size: 18.0)
        static let color: Color = .black
    }
    struct SubtitleText {
        static let font: Font = .custom("Poppins-Light", size: 14.0)
        static let color: Color = .black
    }
    struct PlainTextSemiBold {
        static let font: Font = .custom("Poppins-SemiBold", size: 18.0)
        static let color: Color = .black
    }
    
    struct LargeTitle {
        static let font: Font = .custom("Poppins-Light", size: 34.0)
        static let color: Color = .black
    }
    
    struct TextTitleSecondary {
        static let font: Font = .custom("Poppins-Light", size: 24.0)
        static let color: Color = .secondary
    }
    
    struct LargeTitleBold {
        static let font: Font = .custom("Poppins-ExtraBold", size: 34.0)
        static let color: Color = .black
    }
    
    struct LargeTitleBolder {
        static let font: Font = .custom("Poppins-Bold", size: 34.0)
        static let color: Color = .black
    }
    
    struct TextTitle {
        static let font: Font = .custom("Poppins-ExtraBold", size: 24.0)
        static let color: Color = .black
    }
    
    struct TextTitleBolder {
        static let font: Font = .custom("Poppins-Bold", size: 24.0)
        static let color: Color = .black
    }
    
    struct SmallButtonText {
        static let font: Font = .custom("Poppins-Bold", size: 14.0)
        static let color: Color = .white
    }
    
    struct MediumButtonText {
        static let font: Font = .custom("Poppins-Bold", size: 20.0)
        static let color: Color = .white
    }
}
struct MainTheme: ThemeProtocol {
    var largeTitleFont: Font =  .custom("Poppins-ExtraBold", size: 30.0)
    var textTitleFont: Font = .custom("Poppins-ExtraBold", size: 24.0)
    var normalBtnTitleFont: Font = .custom("Poppins-SemiBold", size: 20.0)
    var boldBtnTitleFont: Font = .custom("Poppins-Bold", size: 20.0)
    var bodyTextFont: Font = .custom("Poppins-Light", size: 18.0)
    var captionTxtFont: Font = .custom("Poppins-SemiBold", size: 20.0)
    var plainTextFont: Font = .custom("Poppins-Light", size: 18.0)
    
    
    var primaryThemeBGColor: Color { return Color("mnPrimaryThemeBGColor") }
    var btnBGColor: Color { return Color("mnBtnBGColor") }
//    var primaryThemeColor: Color { return Color("mnPrimaryThemeColor") }
//    var secondoryThemeColor: Color { return Color("mnSecondoryThemeColor") }
//    var affirmBtnTitleColor: Color { return Color("mnAffirmBtnTitleColor") }
//    var negativeBtnTitleColor: Color { return Color("mnNegativeBtnTitleColor") }
//    var bodyTextColor: Color { return Color("mnBodyTextColor") }
//    var textBoxColor: Color { return Color("mnTextBoxColor") }
}
