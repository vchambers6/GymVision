//
//  SkillCategoryStore.swift
//  GymVision
//
//  Created by Vanessa Chambers on 4/4/24.
//
//  Singleton class for retrieving the category a skill belongs to

import Foundation

class SkillCategoryStore {
    static let shared = SkillCategoryStore()
    
    private var categoryStore: [Apparatus: [Int: CategoryLabel]] = [
        .VT: [
            1: CategoryLabel(
                shortString: "Non-Salto Vaults",
                longString: #"Group 1 – handspring, Yamashita, round-off with or without LA turn in 1st and/or 2nd flight phase"#),
            2: CategoryLabel(
                shortString: "Front Handspring Vaults",
                longString: #"Group 2 – handspring fwd with/without 1/1 turn (360°) in 1st flight phase – salto fwd/bwd with/without la twist in 2nd flight phase"#),
            3: CategoryLabel(
                shortString: "Tsukahara Vaults",
                longString: #"Group 3 – handspring with ¼ - ½ turn (90°-180°) in 1st flight phase (Tsukahara) – salto bwd with/without twist in 2nd flight phase"#),
            4: CategoryLabel(
                shortString: "Yurchenko Vaults",
                longString: #"Group 4 – round-off (Yurchenko) with/wo ¾ turn (270°) in 1st flight phase – salto bwd with/without twist in 2nd flight phase"#),
            5: CategoryLabel(
                shortString: "Half-on Vaults",
                longString: #"Group 5 – round-off with ½ turn (180°) in 1st flight phase – salto fwd/bwd with/without twist in 2nd flight phase"#),
        ],
        .UB: [
            1: CategoryLabel(
                shortString: "Mounts",
                longString: #"Group 1 – how the gymnast gets on the uneven bars"#),
            2: CategoryLabel(
                shortString: #"Casts & Clear Hip Circles"#,
                longString: #"Group 2 – casts and circling skills executed in the straight body position with hips near the bar"#),
            3: CategoryLabel(
                shortString: "Giant Circles",
                longString: #"Group 3 – circling skills executed in the straight body position"#),
            4: CategoryLabel(
                shortString: "Stalder Circles",
                longString: #"Group 4 – circling skills executed in the stalder (legs straddled with a deep bend of the hips) position"#),
            5: CategoryLabel(
                shortString: "Pike Circles",
                longString: #"Group 5 – circling skills executed in the piked position "#),
            6: CategoryLabel(
                shortString: "Dismounts",
                longString: #"Group 6 – how the gymnast gets off the uneven bars"#)
        ],
        .BB: [
            1: CategoryLabel(
                shortString: "Mounts",
                longString: #"Group 1 – how the gymnast gets on the balance beam"#),
            2: CategoryLabel(
                shortString: "Jumps",
                longString: #"Group 2 – gymnastic leaps, jumps, and hops"#),
            3: CategoryLabel(
                shortString: "Turns",
                longString: #"Group 3 – gymnastic turns"#),
            4: CategoryLabel(
                shortString: "Non-flight",
                longString: #"Group 4 – holds and acrobatic non-flight"#),
            5: CategoryLabel(
                shortString: "Acrobatic Flight",
                longString: #"Group 5 - acrobatic flight"#),
            6: CategoryLabel(
                shortString: "Dismounts",
                longString: #"Group 6 – how the gymnast gets off the balance beam "#)
        ],
        .FX: [
            1: CategoryLabel(
                shortString: "Jumps",
                longString: #"Group 1 – gymnastic leaps, jumps, and hops"#),
            2: CategoryLabel(
                shortString: "Turns",
                longString: #"Group 2 – gymnastic turns"""#),
            3: CategoryLabel(
                shortString: "Hand Support Elements",
                longString: #"Group 3 – skills requiring support of hands on the floor"#),
            4: CategoryLabel(
                shortString: #"Front & Side Saltos"#,
                longString: #"Group 4 – saltos forward and sideward"#),
            5: CategoryLabel(
                shortString: "Saltos Backward",
                longString: #"Group 5 - saltos backward"#)
        ]
    ]
    
    func getCategoryLabels(for skill: Skill) -> CategoryLabel? {
        
        return categoryStore[skill.apparatus]?[skill.groupNumber]
    }
}

struct CategoryLabel {
    var shortString: String
    var longString: String
}
