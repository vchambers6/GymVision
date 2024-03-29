//
//  ThemeManager.swift
//  GymVision
//
//  Created by Vanessa Chambers on 3/28/24.
//

import SwiftUI

class ThemeManager: ObservableObject {
    @Published var selectedTheme: ThemeProtocol = MainTheme()
    
    func setTheme(_ theme: ThemeProtocol) {
        selectedTheme = theme
    }
}
