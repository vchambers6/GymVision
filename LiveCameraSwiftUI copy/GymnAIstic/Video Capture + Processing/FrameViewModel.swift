//
//  FrameViewModel.swift
//  LiveCameraSwiftUI
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
    
    let frameHandler = FrameHandler()
    let frameProcessingChain = FrameProcessingChain()
    
    
    override init() {
        super.init()
        
        // MARK: NOT SURE WHERE TO PUT THIS STUFF, BUT I DO NEED TO PUT IT SOMEHWERE
        frameHandler.delegate = self
        frameProcessingChain.delegate = self
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
//            // Update the total number of frames for this action.
//            addFrameCount(frameCount, to: actionPrediction.label)
            
        }
        
        // TODO: update the labels based on the prediction
    }
    
}

// MARK: methods for drawing poses, updating labels, and counting frames
extension FrameViewModel {
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
