//
//  Skill.swift
//  GymnAIstic
//
//  Created by Vanessa Chambers on 3/28/24.
//

import Foundation


struct Skill {
    var copNumber: Double
    var name: String
    var description: String
    var apparatus: Apparatus
    
    var difficultyValue: String?
    var vaultdifficultyValue: Double?
    var namedAfter: String?
    var gifName: String?
}


enum Apparatus: String {
    case VT = "Vault"
    case UB = "Uneven Bars"
    case BB = "Balance Beam"
    case FX = "Floor Exercise"
}

enum Discipline: String {
    case WAG = "WAG"
    case MAG = "MAG"
}
