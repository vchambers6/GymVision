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
    var namedAfterWAG: [Gymnast]?
    var namedAfterMAG: [Gymnast]?
    var yearNamed: Int?
    var hasGif: Bool?
    var className: String?
    
    /// These two columns are here for internal purposes
    var createdAt: Date?
    var updatedAt: Date?
}

struct Gymnast: Codable {
    var lastName: String?
    var firstName: String?
    var federation: String?
}

enum Discipline: String, Codable {
    case WAG, MAG
    
    var disciplineAbbreviationString: String {
        switch self {
        case .WAG: return "WAG"
        case .MAG: return "MAG"
        }
    }
    
    var fullNameString: String {
        switch self {
        case .WAG: return "Women's Artistic Gymnastics"
        case .MAG: return "Men's Artistics Gymnastics"
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

enum Federation: String, Codable {
    case ALB
    case AND
    case ARG
    case ARM
    case AUS
    case AUT
    case AZE
    case BEL
    case BER
    case BIH
    case BLR
    case BOL
    case BRA
    case BUL
    case CAN
    case CHI
    case CHN
    case COL
    case COR
    case CRO
    case CYP
    case CZE
    case DDR
    case DEN
    case ECU
    case ERI
    case ESP
    case EST
    case FIN
    case FRA
    case GBR
    case GEO
    case GER
    case GHA
    case GRE
    case HKG
    case HUN
    case IND
    case IRI
    case IRL
    case ISL
    case ISR
    case ITA
    case JAM
    case JPN
    case KAZ
    case KEN
    case KGZ
    case KOR
    case KOS
    case LAT
    case LBN
    case LIE
    case LTU
    case LUX
    case MAD
    case MAR
    case MAS
    case MDA
    case MEX
    case MGL
    case MKD
    case MLT
    case MNE
    case MON
    case NED
    case NGR
    case NOR
    case NZL
    case OAR
    case PAK
    case PHI
    case POL
    case POR
    case PRK
    case PUR
    case ROU
    case RSA
    case SGP
    case SLO
    case SMR
    case SRB
    case SUI
    case SVK
    case SWE
    case TBC
    case TGA
    case THA
    case TLS
    case TOG
    case TPE
    case TTO
    case TUR
    case UKR
    case USA
    case USSR
    case UZB
    
    // case DDr
    // case USSR
    // case TBC
    // case TTO
    
    
    var countryString: String {
        switch self {
        
        case .ALB:
            return "Albania"
        case .AND:
            return "Andorra"
        case .ARG:
            return "Argentina"
        case .ARM:
            return "Armenia"
        case .AUS:
            return "Australia"
        case .AUT:
            return "Austria"
        case .AZE:
            return "Azerbaijan"
        case .BEL:
            return "Belgium"
        case .BER:
            return "Bermuda"
        case .BIH:
            return "Bosnia and Herzegovina"
        case .BLR:
            return "Belarus"
        case .BOL:
            return "Bolivia"
        case .BRA:
            return "Brazil"
        case .BUL:
            return "Bulgaria"
        case .CAN:
            return "Canada"
        case .CHI:
            return "Chile"
        case .CHN:
            return "China"
        case .COL:
            return "Colombia"
        case .COR:
            return "United Korean Team"
        case .CRO:
            return "Croatia"
        case .CYP:
            return "Cyprus"
        case .CZE:
            return "Czech Republic"
        case .DDR:
            return "East Germany"
        case .DEN:
            return "Denmark"
        case .ECU:
            return "Ecuador"
        case .ERI:
            return "Eritrea"
        case .ESP:
            return "Spain"
        case .EST:
            return "Estonia"
        case .FIN:
            return "Finland"
        case .FRA:
            return "France"
        case .GBR:
            return "Great Britain"
        case .GEO:
            return "Georgia"
        case .GER:
            return "Germany"
        case .GHA:
            return "Ghana"
        case .GRE:
            return "Greece"
        case .HKG:
            return "Hong Kong, China"
        case .HUN:
            return "Hungary"
        case .IND:
            return "India"
        case .IRI:
            return "Islamic Republic of Iran"
        case .IRL:
            return "Ireland"
        case .ISL:
            return "Iceland"
        case .ISR:
            return "Israel"
        case .ITA:
            return "Italy"
        case .JAM:
            return "Jamaica"
        case .JPN:
            return "Japan"
        case .KAZ:
            return "Kazakhstan"
        case .KEN:
            return "Kenya"
        case .KGZ:
            return "Kyrgyzstan"
        case .KOR:
            return "Republic of Korea"
        case .KOS:
            return "Kosovo"
        case .LAT:
            return "Latvia"
        case .LBN:
            return "Lebanon"
        case .LIE:
            return "Liechtenstein"
        case .LTU:
            return "Lithuania"
        case .LUX:
            return "Luxembourg"
        case .MAD:
            return "Madagascar"
        case .MAR:
            return "Morocco"
        case .MAS:
            return "Malaysia"
        case .MDA:
            return "Republic of Moldova"
        case .MEX:
            return "Mexico"
        case .MGL:
            return "Mongolia"
        case .MKD:
            return "the Former Yugoslav Republic of Macedonia"
        case .MLT:
            return "Malta"
        case .MNE:
            return "Montenegro"
        case .MON:
            return "Monaco"
        case .NED:
            return "Netherlands"
        case .NGR:
            return "Nigeria"
        case .NOR:
            return "Norway"
        case .NZL:
            return "New Zealand"
        case .OAR:
            return "Olympic Athlete from Russia"
        case .PAK:
            return "Pakistan"
        case .PHI:
            return "Philippines"
        case .POL:
            return "Poland"
        case .POR:
            return "Portugal"
        case .PRK:
            return "Democratic People's Republic of Korea"
        case .PUR:
            return "Puerto Rico"
        case .ROU:
            return "Romania"
        case .RSA:
            return "South Africa"
        case .SGP:
            return "Singapore"
        case .SLO:
            return "Solvenia"
        case .SMR:
            return "San Marino"
        case .SRB:
            return "Serbia"
        case .SUI:
            return "Switzerland"
        case .SVK:
            return "Slovakia"
        case .SWE:
            return "Sweden"
        case .TGA:
            return "Tonga"
        case .THA:
            return "Thailand"
        case .TBC:
            return ""
        case .TLS:
            return "Democratic Republic of Timor-Leste"
        case .TOG:
            return "Togo"
        case .TPE:
            return "Chinese Taipei"
        case .TTO:
            return "Trinidad and Tobago"
        case .TUR:
            return "Turkey"
        case .UKR:
            return "Ukraine"
        case .USA:
            return "United States of America"
        case .USSR:
            return "Soviet Union"
        case .UZB:
            return "Uzbekistan"
        }
    
    }
    
    var countryAdjectiveString: String {
        switch self {
        
        case .ALB:
            return "Albanian"
        case .AND:
            return "Andorran"
        case .ARG:
            return "Argentine"
        case .ARM:
            return "Armenian"
        case .AUS:
            return "Australian"
        case .AUT:
            return "Austrian"
        case .AZE:
            return "Azerbaijani"
        case .BEL:
            return "Belarusian"
        case .BER:
            return "Bermudan"
        case .BIH:
            return "Bosnian/Herzegovinian"
        case .BLR:
            return "Belarusian"
        case .BOL:
            return "Bolivian"
        case .BRA:
            return "Brazilian"
        case .BUL:
            return "Bulgarian"
        case .CAN:
            return "Canadian"
        case .CHI:
            return "Chilean"
        case .CHN:
            return "Chinese"
        case .COL:
            return "Colombian"
        case .COR:
            return "Korean"
        case .CRO:
            return "Croatian"
        case .CYP:
            return "Cypriot"
        case .CZE:
            return "Czech"
        case .DDR:
            return "East German"
        case .DEN:
            return "Danish"
        case .ECU:
            return "Ecuadorian"
        case .ERI:
            return "Eritrean"
        case .ESP:
            return "Spanish"
        case .EST:
            return "Estonian"
        case .FIN:
            return "Finnish"
        case .FRA:
            return "French"
        case .GBR:
            return "British"
        case .GEO:
            return "Georgian"
        case .GER:
            return "German"
        case .GHA:
            return "Ghanaian"
        case .GRE:
            return "Greek"
        case .HKG:
            return "Hong Kongese"
        case .HUN:
            return "Hungarian"
        case .IND:
            return "Indian"
        case .IRI:
            return "Iranian"
        case .IRL:
            return "Irish"
        case .ISL:
            return "Icelandic"
        case .ISR:
            return "Israel"
        case .ITA:
            return "Italian"
        case .JAM:
            return "Jamaican"
        case .JPN:
            return "Japanese"
        case .KAZ:
            return "Kazakh"
        case .KEN:
            return "Kenyan"
        case .KGZ:
            return "Kyrgyz"
        case .KOR:
            return "South Korean"
        case .KOS:
            return "Kosovar"
        case .LAT:
            return "Latvian"
        case .LBN:
            return "Lebanese"
        case .LIE:
            return "Liechtensteiner"
        case .LTU:
            return "Lithuanian"
        case .LUX:
            return "Luxembourger"
        case .MAD:
            return "Malagasy"
        case .MAR:
            return "Moroccan"
        case .MAS:
            return "Malaysian"
        case .MDA:
            return "Moldovan"
        case .MEX:
            return "Mexican"
        case .MGL:
            return "Mongolian"
        case .MKD:
            return "Macedonian"
        case .MLT:
            return "Maltese"
        case .MNE:
            return "Montenegrin"
        case .MON:
            return "Monégasque"
        case .NED:
            return "Dutch"
        case .NGR:
            return "Nigerian"
        case .NOR:
            return "Norwegian"
        case .NZL:
            return "Kiwi"
        case .OAR:
            return "Olympic Athlete from Russia Federation"
        case .PAK:
            return "Pakistani"
        case .PHI:
            return "Filipino"
        case .POL:
            return "Polish"
        case .POR:
            return "Portuguese"
        case .PRK:
            return "North Korean"
        case .PUR:
            return "Puerto Rican"
        case .ROU:
            return "Romanian"
        case .RSA:
            return "South African"
        case .SGP:
            return "Singaporean"
        case .SLO:
            return "Slovene"
        case .SMR:
            return "Sammarinese"
        case .SRB:
            return "Serbian"
        case .SUI:
            return "Swiss"
        case .SVK:
            return "Slovak"
        case .SWE:
            return "Swedish"
        case .TBC:
            return "(Federation not Found)"
        case .TGA:
            return "Tongan"
        case .THA:
            return "Thai"
        case .TLS:
            return "Timorese"
        case .TOG:
            return "Togolese"
        case .TPE:
            return "Taiwanese"
        case .TTO:
            return "Trinbagonian"
        case .TUR:
            return "Turkish"
        case .UKR:
            return "Ukranian"
        case .USA:
            return "American"
        case .USSR:
            return "Soviet"
        case .UZB:
            return "Uzbek"
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
