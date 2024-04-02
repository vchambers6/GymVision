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
    
    private var mapping: [SkillClassifier.Label: UUID] = [:]
    
    private init() {}
    
    func addMapping(prediction: SkillClassifier.Label, uuid: UUID) {
        mapping[prediction] = uuid
    }
        
    func getUUID(forPrediction prediction: SkillClassifier.Label) -> UUID? {
        return mapping[prediction]
    }
}


