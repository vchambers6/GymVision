//
//  SkillDetailViewModel.swift
//  GymVision
//
//  Created by Vanessa Chambers on 4/1/24.
//
//  This class just separates the logic for generating all of the text for the skill detail view. 

import SwiftUI


class SkillDetailViewModel: ObservableObject {
    @Published var disciplineText: String
    @Published var apparatusText: String
    @Published var dValue: String
    @Published var dValueText: String
    @Published var categoryLabel: String = "No Category"
    @Published var categoryDescription: String = "No description at this time."
    
    
    
    init(skill: Skill) {
        self.disciplineText = "This skill is under the code of points for \(skill.discipline.fullNameString)."
        self.apparatusText = "This skill is performed on the \(skill.apparatus.apparatusString.lowercased()) apparatus. \(skill.discipline.fullNameString) contains four apparatus: vault, uneven bars, balance beam, and floor exercise."
        if let dValue = skill.difficultyValue {
            self.dValueText = "This skill has a difficulty value of '\(dValue.rawValue).' Skills on the uneven bars, balance beam, and floor exercise can have difficulty values ranging from A (least difficult) to J (most difficult)."
            self.dValue = dValue.rawValue
        } else if let dValue = skill.vaultDifficultyValue {
            self.dValueText = "This skill has a difficulty value of \(String(dValue)). Skills on vault can have difficulty values ranging from 2.0 (least difficult) to 6.4 (most difficult)."
            self.dValue = String(dValue)
        } else {
            self.dValueText = "This skill has no difficulty value."
            self.dValue = "N/A"
        }
        
        // determining category string
        if let category = SkillCategoryStore.shared.getCategoryLabels(for: skill) {
            self.categoryLabel = category.shortString
            self.categoryDescription = category.longString
        }
    }
    
    
}
