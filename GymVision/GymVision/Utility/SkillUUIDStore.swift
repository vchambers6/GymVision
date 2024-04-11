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
        .backHandspringStepout : "A6C4A026-DFB2-4219-B3BB-207499C96AF1",
        .splitJump : "5361CB0E-F4F9-4F8A-BCB3-3E39DA462CAA",
        .sheepJump : "A0A5C682-2D0A-480B-958E-9157031B3931",
        .fullTurn : "C2F7725B-CC19-4637-9B51-A9EC61ED7524",
        .lTurn : "C2F7725B-CC19-4637-9B51-A9EC61ED7524",
        .backLayoutStepout : "BFDC00D0-7DED-47B8-AD23-3E1924D834C1",
        .backTuck : "398F025C-0D17-4CC5-BBAC-5BC0E1355863",
        .sideAerial : "FA43AE0B-F1A1-4B80-B83E-FABD13316CE8",
        .frontAerial : "491FE0C1-B33B-43EB-B92F-72128C0DEE3A",
        .frontTuck : "2EB4920D-702E-41A6-A425-4127A3905EB9"
    ]
    
    private init() {}
    
    func addMapping(prediction: SkillClassifier.Label, uuid: String) {
        mapping[prediction] = uuid
    }
        
    func getUUIDString(forPrediction prediction: SkillClassifier.Label) -> String? {
        return mapping[prediction]
    }
}


