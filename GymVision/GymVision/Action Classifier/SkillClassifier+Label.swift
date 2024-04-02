/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Defines the app's knowledge of the model's class labels.
*/

// MARK: I'm modifying exercise classifier to use the labels for my model

extension SkillClassifier {
    enum Label: String, CaseIterable {
        case backHandspringStepout = "Back Handspring Stepout"
        case backLayoutStepout = "Back Layout Stepout"
        case backTuck = "Back Tuck"
        case frontAerial = "Front Aerial"
        case frontTuck = "Front Tuck"
        case fullTurn = "Full Turn"
        case lTurn = "L Turn"
        case sheepJump = "Sheep Jump"
        case sideAerial = "Side Aerial"
        case splitJump = "Split Jump"
        
        // TODO: I want to have a case that representes other actions, but i dont have this yet.
        // case otherAction = "Other Action"
        
        /// - Parameter label: the name of an action class
        init(_ string: String) {
            guard let label = Label(rawValue: string) else {
                let typeName = String(reflecting: Label.self)
                fatalError("Add the '\(string)' label to the '\(typeName)' type.")
            }
            self = label
            
        }
        
        var uuidString: String? {
            return SkillUUIDStore.shared.getUUIDString(forPrediction: self)
        }
    }
}

//extension ExerciseClassifier {
//    /// Represents the app's knowledge of the Exercise Classifier model's labels.
//    enum Label: String, CaseIterable {
//        case lunges = "Lunges"
//        case burpees = "Burpees"
//        case jumpingJacks = "Jumping Jacks"
//
//        /// A negative class that represents irrelevant actions.
//        case otherAction = "Other Action"
//
//        /// Creates a label from a string.
//        /// - Parameter label: The name of an action class.
//        init(_ string: String) {
//            guard let label = Label(rawValue: string) else {
//                let typeName = String(reflecting: Label.self)
//                fatalError("Add the `\(string)` label to the `\(typeName)` type.")
//            }
//
//            self = label
//        }
//    }
//}
