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
    struct PlainTextBold {
        static let font: Font = .custom("Poppins-Bold", size: 18.0)
        static let color: Color = .black
    }
    
    struct TextTitle {
        static let font: Font = .custom("Poppins-ExtraBold", size: 24.0)
        static let color: Color = .black
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
