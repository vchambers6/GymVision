//
//  ThemeProtocol.swift
//  GymVision
//
//  Created by Vanessa Chambers on 3/28/24.
//

import SwiftUI

protocol ThemeProtocol {
    var largeTitleFont: Font { get }
    var textTitleFont: Font { get }
    var normalBtnTitleFont: Font { get }
    var boldBtnTitleFont: Font { get }
    var bodyTextFont: Font { get }
    var plainTextFont: Font { get }
    var captionTxtFont: Font { get }
    
    var primaryThemeBGColor: Color { get }
    var btnBGColor: Color { get }
    
    
//    var primaryThemeColor: Color { get }
//    var secondoryThemeColor: Color { get }
//    var affirmBtnTitleColor: Color { get }
//    var negativeBtnTitleColor: Color { get }
//    var bodyTextColor: Color { get }
//    var textBoxColor: Color { get }
}
