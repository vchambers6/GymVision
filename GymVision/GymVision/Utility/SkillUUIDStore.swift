//
//  SkillUUIDStore.swift
//  GymVision
//
//  Created by Vanessa Chambers on 4/1/24.
//
//  Singleton Class for mapping Action Prediction Lables to the corresponding UUID in the database for lookup purposes

import Foundation


class SkillUUIDStore {
    static let shared = SkillUUIDStore()
    
    private var mapping: [SkillClassifier.Label: String] = [
        .backHandspringStepout : "B76A7FBD-940F-4E8A-B48A-0D9481A8F4F9",
        .splitJump : "FB4A09CB-0D89-4843-97F6-43944422A364",
        .sheepJump : "DFD8C864-8831-4315-995F-6225CBD5F311",
        .fullTurn : "EB2015A0-A310-462B-8759-1EBAF72AAEA5",
        .lTurn : "30359592-44FD-4602-92C0-2FD37078FF30",
        .backLayoutStepout : "212F18A9-127F-43D4-984E-8FA174C0C240",
        .backTuck : "B9518268-235C-4A5A-89BF-9CFB593FA199",
        .sideAerial : "D4D00BA9-5E42-48BB-AFE6-F733777B7703",
        .frontAerial : "B36A4D5F-07E6-418B-BE97-46C15BDE16A4",
        .frontTuck : "6C8CCC45-ACCE-4FBF-8E4E-C1E214B55913"
    ]
    
    private init() {}
    
    func addMapping(prediction: SkillClassifier.Label, uuid: String) {
        mapping[prediction] = uuid
    }
        
    func getUUIDString(forPrediction prediction: SkillClassifier.Label) -> String? {
        return mapping[prediction]
    }
}


