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
            .backHandspringStepout : "A6CC6950-0FBC-4C7B-B70A-5D1921C28708",
            .splitJump : "CA1D40B5-B0BD-4120-8EA3-101397C27E51",
            .sheepJump : "6A5974A8-BD64-4987-BE75-B317824E0FE2",
            .fullTurn : "6943CEB5-1B55-4883-BD2E-DA445416220E",
            .lTurn : "D550C075-79AA-4AA1-8D9B-76028FD3A126",
            .backLayoutStepout : "6726AEC9-2790-4195-B9EA-F4E21E353E19",
            .backTuck : "45020B18-2B52-4338-9DE1-4D737004ABF3",
            .sideAerial : "2A4B5480-969F-47CC-9D87-0CEABC4586BE",
            .frontAerial : "0D327C44-B337-4D17-B7B2-B062AB013039",
            .frontTuck : "FD22645B-A042-486D-9100-E2B0CFBC1013"
        ]
    
    private init() {}
    
    func addMapping(prediction: SkillClassifier.Label, uuid: String) {
        mapping[prediction] = uuid
    }
        
    func getUUIDString(forPrediction prediction: SkillClassifier.Label) -> String? {
        return mapping[prediction]
    }
}


