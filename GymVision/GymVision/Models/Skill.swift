//
//  Skill.swift
//  GymnAIstic
//
//  Created by Vanessa Chambers on 3/28/24.
//

import Foundation

struct Skill: Identifiable, Codable {
    var id: UUID?
    var name: String
    var discipline: Discipline
    var apparatus: Apparatus
    var difficultyValue: DifficultyValue?
    var vaultDifficultyValue: Double?
    var description: String
    var copNumber: Double?
    var vaultCopNumber: Double?
    var groupNumber: Int
    var namedAfter: String?
    
    
    /// These two columns are here for internal purposes
    var createdAt: Date?
    var updatedAt: Date?
}

enum Discipline: String, Codable {
    case wag, mag
    
    var disciplineAbbreviationString: String {
        switch self {
        case .wag: return "WAG"
        case .mag: return "MAG"
        }
    }
    
    var fullNameString: String {
        switch self {
        case .wag: return "Women's Artistic Gymnastics"
        case .mag: return "Men's Artistics Gymnastics"
        }
    }
}

enum Apparatus: String, Codable {
    case VT, UB, BB, FX, PH, SR, PB, HB
    
    var apparatusString: String {
        switch self {
        case .VT: return "Vault"
        case .UB: return "Uneven Bars"
        case .BB: return "Balance Beam"
        case .FX: return "Floor Exercise"
            
        /// Mag apparatuses
        case .PH: return "Pommel Horse"
        case .SR: return "Still Rings"
        case .PB: return "Parallel Bars"
        case .HB: return "Horizontal Bar"
        }
    }
    
    var apparatusAbbreviationString: String {
        switch self {
        case .VT: return "VT"
        case .UB: return "UB"
        case .BB: return "BB"
        case .FX: return "FX"
            
        /// Mag apparatuses
        case .PH: return "PH"
        case .SR: return "SR"
        case .PB: return "PB"
        case .HB: return "HB"
        }
    }
}

enum DifficultyValue: String, Codable { // Got rid of RawRepresentable
    typealias RawValue = String

    case A, B, C, D, E, F, G, H, I, J

    init?(rawValue: Character){
        switch rawValue {
        case "A" : self = .A
        case "B" : self = .B
        case "C" : self = .C
        case "D" : self = .D
        case "E" : self = .E
        case "F" : self = .F
        case "G" : self = .G
        case "H" : self = .H
        case "I" : self = .I
        case "J" : self = .J
        default : return nil
        }
    }
}

// MARK: OLD STUFF
//struct Skill {
//    var copNumber: Double
//    var name: String
//    var description: String
//    var apparatus: Apparatus
//    
//    var difficultyValue: String?
//    var vaultdifficultyValue: Double?
//    var namedAfter: String?
//    var gifName: String?
//}
//
//
//enum Apparatus: String {
//    case VT = "Vault"
//    case UB = "Uneven Bars"
//    case BB = "Balance Beam"
//    case FX = "Floor Exercise"
//}
//
//enum Discipline: String {
//    case WAG = "WAG"
//    case MAG = "MAG"
//}
