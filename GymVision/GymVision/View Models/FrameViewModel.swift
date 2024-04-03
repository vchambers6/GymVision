//
//  FrameViewModel.swift
//  GymVision
//
//  Created by Vanessa Chambers on 2/21/24.
//

import AVFoundation
import Combine
import CoreImage
import Vision
import UIKit


class FrameViewModel: NSObject, ObservableObject {
    @Published var frame: CGImage?
    @Published var actionLabel: String?
    @Published var confidenceString: String?
    @Published var skillsObserved: [ActionPrediction] = []
    
    let frameHandler = FrameHandler()
    let frameProcessingChain = FrameProcessingChain()
    
    
    override init() {
        super.init()
        
        // MARK: NOT SURE WHERE TO PUT THIS STUFF, BUT I DO NEED TO PUT IT SOMEHWERE
        frameHandler.delegate = self
        frameProcessingChain.delegate = self
    }
    
    func stopTasks() {
        // Stop frame capture
        DispatchQueue.global(qos: .userInteractive).async { [ unowned self] in
            frameHandler.isEnabled = false
            frameProcessingChain.stopTasks()
            
            // MARK: I REALLY DON'T KNOW IF THIS IS THE BEST WAY TO GO ABOUT THIS, BUT I JUST WANT OT GET RID OF EVERYTHIGN WHEN WE NAVIGATE BACK AND NOT HAVE ANY REFERENCES
            // Clear all data
            DispatchQueue.main.async {
                self.frame = nil
                self.actionLabel = nil
                self.confidenceString = nil
                self.skillsObserved = []
            }
            
        }
    }
}

extension FrameViewModel: FrameHandlerDelegate {
    func videoCapture(_ videoCapture: FrameHandler, didCreate framePublisher: FramePublisher) {
       // TODO: NEED TO UNCOMMENT THIS and IMPLEMENT THIS FUNC
//        updateUILabelsWithPrediction(.startingPrediction)
        
        frameProcessingChain.upstreamFramePublisher = framePublisher
    }
}

extension FrameViewModel: FrameProcessingChainDelegate {
    func frameProcessingChain(_ chain: FrameProcessingChain, didDetect poses: [Pose]?, in frame: CGImage) {
        // TODO: need to create and call drawposes in the user interactive queue threa
        // Render the poses on a different queue than pose publisher.
        DispatchQueue.global(qos: .userInteractive).async {
            // MARK: found a bug here. the viewmodel was already deallocated, but for some reason the frame was not. I need to look into this
            DispatchQueue.main.async { [unowned self] in
                self.frame = frame
                
            }
            // Draw the poses onto the frame.
            self.drawPoses(poses, onto: frame)
        }
    }
    
    func frameProcessingChain(_ chain: FrameProcessingChain, didPredict actionPrediction: ActionPrediction, for frames: Int) {
        // TODO: need to increment frame count through func addFrameCount
        if actionPrediction.isModelLabel {
            self.actionLabel = actionPrediction.label
            self.confidenceString = actionPrediction.confidenceString
//            // Update the total number of frames for this action.
//            addFrameCount(frameCount, to: actionPrediction.label)
            addSkillObserved(actionPrediction)
            
        }
        
        // TODO: update the labels based on the prediction
    }
    
}

// MARK: methods for drawing poses, updating labels, and counting frames, and adding to the list of skills observed
extension FrameViewModel {
    private func addSkillObserved(_ currentSkill: ActionPrediction) {
        /// If observing the same skill, update the confidence
        // MARK: this will not handle skills performed 2x in a row (e.g. bhs bhs). I need to come up with a soln for that. for now this will have to do.
        if let lastSkill = skillsObserved.last {
            if currentSkill.label == lastSkill.label {
                if let lastIndex = skillsObserved.indices.last {
                    skillsObserved[lastIndex] = currentSkill.confidence > lastSkill.confidence ? currentSkill : lastSkill
                } else {
                    print("ERROR IN UPDATING THE CONFIDENCE OF THE SKILL")
                    return
                }
            } else {
                skillsObserved.append(currentSkill)
            }
        } else {
            skillsObserved.append(currentSkill)
        }
    }
    /// Draws poses as wireframes on top of a frame, and updates the user
    /// interface with the final image.
    /// - Parameters:
    ///   - poses: An array of human body poses.
    ///   - frame: An image.
    /// - Tag: drawPoses
    // TODO: I WONDER IF THERE IS A WAY TO DRAW THE POSES OVER THE IMAGE WITHOUT USING UIKIT. I DONT THINK SO. 
    private func drawPoses(_ poses: [Pose]?, onto frame: CGImage) {
        // Create a default render format at a scale of 1:1.
        let renderFormat = UIGraphicsImageRendererFormat()
        renderFormat.scale = 1.0

        // Create a renderer with the same size as the frame.
        let frameSize = CGSize(width: frame.width, height: frame.height)
        let poseRenderer = UIGraphicsImageRenderer(size: frameSize,
                                                   format: renderFormat)
        

        // Draw the frame first and then draw pose wireframes on top of it.
        let frameWithPosesRendering = poseRenderer.image { rendererContext in
            // The`UIGraphicsImageRenderer` instance flips the Y-Axis presuming
            // we're drawing with UIKit's coordinate system and orientation.
            let cgContext = rendererContext.cgContext

            // Get the inverse of the current transform matrix (CTM).
            let inverse = cgContext.ctm.inverted()

            // Restore the Y-Axis by multiplying the CTM by its inverse to reset
            // the context's transform matrix to the identity.
            cgContext.concatenate(inverse)

            // Draw the camera image first as the background.
            let imageRectangle = CGRect(origin: .zero, size: frameSize)
            cgContext.draw(frame, in: imageRectangle)

            // Create a transform that converts the poses' normalized point
            // coordinates `[0.0, 1.0]` to properly fit the frame's size.
            let pointTransform = CGAffineTransform(scaleX: frameSize.width,
                                                   y: frameSize.height)

            guard let poses = poses else { return }

            // Draw all the poses Vision found in the frame.
            for pose in poses {
                // Draw each pose as a wireframe at the scale of the image.
                pose.drawWireframeToContext(cgContext, applying: pointTransform)
            }
        }
        

        // Update the UI's full-screen image view on the main thread.
        // TODO: UNCOMMENT THIS
//        DispatchQueue.main.async { self.imageView.image = frameWithPosesRendering }
    }
}
