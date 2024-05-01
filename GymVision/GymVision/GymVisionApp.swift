//
//  GymVisionApp.swift
//  GymVision
//
//  Created by Vanessa Chambers on 2/14/24.
//

import SwiftUI
import AWSCore

@main
struct GymVisionApp: App {
    var themeManager = ThemeManager()
    
    // Setup AWS S3 Credentials on launch
    // MARK: I am not sure if this is slowing down the app -- need to investigate
    init() {
        let identityPoolId = Bundle.main.infoDictionary?["IDENTITY_POOL_ID"] as? String ?? "YOUR_IDENTITY_POOL_ID"
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityPoolId: identityPoolId)
        let serviceConfiguration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = serviceConfiguration
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(themeManager)
        }
    }
}
