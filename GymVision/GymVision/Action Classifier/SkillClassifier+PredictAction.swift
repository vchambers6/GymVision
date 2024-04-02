/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Provides a convenience method that makes a prediction from a multiarray window.
*/

import CoreML

extension SkillClassifier {
    /// Predicts an action from a series of landmarks' positions over time.
    /// - Parameter window: An `MLMultiarray` that contains the locations of a
    /// person's body landmarks for multiple points in time.
    /// - Returns: An `ActionPrediction`.
    /// - Tag: predictActionFromWindow
    func predictActionFromWindow(_ window: MLMultiArray) -> ActionPrediction {
        do {
            let output = try prediction(poses: window)
            let action = Label(output.label)
            let uuidString = action.uuidString
            let confidence = output.labelProbabilities[output.label]!

            return ActionPrediction(label: action.rawValue, confidence: confidence, uuidString: uuidString)

        } catch {
            fatalError("SkillClassifier prediction error: \(error)")
        }
    }
}
