//
//  SkillDetailViewModel.swift
//  GymVision
//
//  Created by Vanessa Chambers on 4/1/24.
//
//  This class just separates the logic for generating all of the text for the skill detail view. 

import SwiftUI
import AWSS3


class SkillDetailViewModel: ObservableObject {
    @Published var disciplineText: String
    @Published var apparatusText: String
    @Published var dValue: String
    @Published var dValueText: String
    @Published var categoryLabel: String = "No Category"
    @Published var categoryDescription: String = "No description at this time."
    @Published var namedAfterString: String?
    @Published var gifData: Data?
    
    
    
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
        
        var namesArray = [String]()
        if let namedAfterWAG = skill.namedAfterWAG {
            for gymnast in namedAfterWAG {
                namesArray.append(getNiceName(for: gymnast, wag: true))
            }
        }

        if let namedAfterMAG = skill.namedAfterMAG {
            for gymnast in namedAfterMAG {
                namesArray.append(getNiceName(for: gymnast, wag: false))
            }
        }
        
        /// Formulating the named after string. 
        if !namesArray.isEmpty {
            var prefix = "This skill is named after "
            var suffix = ""
            let count = namesArray.count
                
            if count > 2 {
                prefix = prefix + namesArray.dropLast(1).joined(separator: ", ")
                suffix = ", and " + namesArray.suffix(1)[0]
            } else {
                prefix = prefix + namesArray.joined(separator: " and ")
            }
            
            if let yearNamed = skill.yearNamed {
                self.namedAfterString = prefix + suffix + ". It was added to the code of points in " + String(yearNamed) + "."
            } else {
                self.namedAfterString = prefix + suffix + "."
            }
        }
        
        //MARK: gif feetching code
        if let hasGif = skill.hasGif, hasGif {
            if let className = skill.className {
                fetchGifFromS3(className: className)
            }
            
        }
        
    }
    
    func fetchGifFromS3(className: String) {
        let bucket = "3605e390-a72e-480b-8435-19d7a740a2a9"
        let key = "skills_videos/" + className
        
        let transferUtility = AWSS3TransferUtility.default()
        print("🤲🏾here's the bucket: \(bucket) and key \(key)")
        let expression = AWSS3TransferUtilityDownloadExpression()
        expression.progressBlock = { (task, progress) in
            // what do i put here
            print("❤️ progress: \(progress)")
        }
        
        transferUtility.downloadData(
                fromBucket: bucket,
                key: key,
                expression: expression,
                completionHandler: { [weak self] (task, url, data, error) in
                    guard let self = self else { return }
                    if let error = error {
                        print("Error downloading GIF: \(error)")
                        return
                    } else if let data = data {
                        // Successfully downloaded data
                        DispatchQueue.main.async {
                            self.gifData = data
                        }
                    }
                }
        )
 
        
        
//        let awsDataLoader = AWSS3GifLoader()
//        DispatchQueue.main.async {
//            awsDataLoader.downloadGIFFromS3(bucket: bucket, key: key) { [self] data, error in
//                if let data = data {
//                    gifData = data
//                } else if let error = error {
//                    print("👺 ERROR DOWNLOAD GIF FROM S3 \(error)")
//                    fatalError()
//                }
//            }
//        }
        
    }
    
    func getNiceName(for gymnast: Gymnast, wag: Bool) -> String {
        var str = wag ? "" : "MAG gymnast "
        if let firstName = gymnast.firstName {
            str = str + firstName
        }
        if let lastName = gymnast.lastName {
            str = str + " " + lastName
        }
        if let federation = gymnast.federation {
            str = str + " of " + federation
        }
        
        return str
    }
    
    
}
