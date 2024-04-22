//
//  FrameHandler.swift
//  GymVision
//
//  Created by Vanessa Chambers on 2/14/24.
//

import AVFoundation
import Combine
import CoreImage
import Vision

/// - Tag: Frame
typealias Frame = CMSampleBuffer
typealias FramePublisher = AnyPublisher<Frame, Never>

protocol FrameHandlerDelegate: AnyObject {
    /// Informs the delegate when the Video Capture creates a new publisher.
    /// - Parameters:
    ///   - framePublisher: The new frame publisher.
    func videoCapture(_ videoCapture: FrameHandler,
                      didCreate framePublisher: FramePublisher)
}


// To pass data from this class to the view, we make this an ObservableObject
class FrameHandler: NSObject, ObservableObject {
    @Published var frame: CGImage?
    private var permissionGranted = false
    private let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    // Used to go from ciImage to cgImage
//    private let context = CIContext()
    
    
    //MARK: added these vars to make a frame publisher
    /// The initial Combine publisher that forwards the video frames as the
    /// capture session produces them.
    /// - Tag: framePublisher
    private var framePublisher: PassthroughSubject<Frame, Never>?
    weak var delegate: FrameHandlerDelegate! {
        didSet { createVideoFramePublisher() }
    }
    /// A Boolean that indicates whether to publish video frames.
    ///
    /// Set to `false`  to stop publishing frames and reduce the app's power
    /// consumption, typically when the app doesn't need the camera's video
    /// frames such as showing dialog or other UI that obscures the camera
    /// preview.
    var isEnabled = true {
        didSet { isEnabled ? enableCaptureSession() : disableCaptureSession() }
    }
    
    override init() {
        super.init()
        checkPermission()
        sessionQueue.async { [unowned self] in
            
            // MARK: uncomment below and comment out after line to return to original
            // self.setupCaptureSession()
            // MARK: putting this in the init creates a bug because the delegate has not been set at this point, so when accessing the delegate we get a nil value.
            // TODO: need to figure out this ... probbaly start running the capture session after we call createVideoFramePublisher
//            self.createVideoFramePublisher()
//            
//            self.captureSession.startRunning()
        }
    }
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            permissionGranted = true
        case .notDetermined:
            requestAccess()
        default:
            permissionGranted = false
        }
    }
    
    func requestAccess() {
        AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
            self.permissionGranted = granted
        }
    }
    
    // MARK: this func used to be private but i changed it because I want to use this functino in FrameView
    func enableCaptureSession() {
        if !captureSession.isRunning {
            DispatchQueue.global(qos: .userInteractive).async { [unowned self] in
                captureSession.startRunning()
            }
        }
    }

    // MARK: this func used to be private but i changed it because I want to use this functino in FrameView
    func disableCaptureSession() {
        if captureSession.isRunning {
            DispatchQueue.global(qos: .userInteractive).async { [unowned self] in
                captureSession.stopRunning()
            }
        }
    }
    
    /// Creates a video frame publisher by starting or reconfiguring the
    /// video capture session.
    /// - Tag: createVideoFramePublisher
    private func createVideoFramePublisher() {
        // (Re)configure the capture session.
        guard let videoDataOutput = configureCaptureSession() else { return }

        // Create a new passthrough subject that publishes frames to subscribers.
        let passthroughSubject = PassthroughSubject<Frame, Never>()

        // Keep a reference to the publisher.
        framePublisher = passthroughSubject

        // Set the video capture as the video output's delegate.
        videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBufferQueue"))

        // Create a generic publisher by type erasing the passthrough publisher.
        let genericFramePublisher = passthroughSubject.eraseToAnyPublisher()

        // Send the publisher to the `VideoCapture` instance's delegate.
        // MARK: THIS IS THE STEP I AM CONFUSED BY -- who should be the delegate of this class / do we need a delegate -- maybe i will make a frame view model which is a delegate for both 
        delegate.videoCapture(self, didCreate: genericFramePublisher)
    }
    
    // returns equiv of videoOutput in setupCaptureSession
    func configureCaptureSession() -> AVCaptureVideoDataOutput? {
        disableCaptureSession()
        
        guard isEnabled else {
            // Leave the camera disabled.
            return nil
        }
        
        // (Re)start the capture session after this method returns.
        defer { enableCaptureSession() }
        
        // Tell the capture session to start configuration.
        captureSession.beginConfiguration()

        // Finalize the configuration after this method returns.
        defer { captureSession.commitConfiguration() }

        
        // MARK: I want the frame rate to be 30, but right now the model only takes in 24 frames at a time.
        let modelFrameRate = 24.0 // SkillClassifier.frameRate

        let input = AVCaptureDeviceInput.createCameraInput(position: AVCaptureDevice.Position.back,
                                                           frameRate: modelFrameRate)

        let output = AVCaptureVideoDataOutput.withPixelFormatType(kCVPixelFormatType_32BGRA)
        
        let success = configureCaptureConnection(input, output)
        return success ? output : nil
        
        
//        let videoOutput = AVCaptureVideoDataOutput()
//        
//        guard permissionGranted else {return nil}
//        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return nil}
//        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else { return nil }
//        guard captureSession.canAddInput(videoDeviceInput) else { return nil}
//        captureSession.addInput(videoDeviceInput)
////        
////        // a FrameHandler is set as the delegate; the delegate gest notified when the videoOutput sends a frmae to the smapleBuffer
////        // MARK: If modifying the capture output before presenting it to the view, i think we may need to come back to this
//////        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBufferQueue"))
//        captureSession.addOutput(videoOutput)
//        videoOutput.connection(with: .video)?.videoOrientation = .portrait
//        
//        return videoOutput
        
        
    }
    
    
    
    
    func setupCaptureSession() {
        let videoOutput = AVCaptureVideoDataOutput()
        
        guard permissionGranted else {return}
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else { return }
        guard captureSession.canAddInput(videoDeviceInput) else { return }
        captureSession.addInput(videoDeviceInput)
        
        // a FrameHandler is set as the delegate; the delegate gest notified when the videoOutput sends a frmae to the smapleBuffer
        // MARK: If modifying the capture output before presenting it to the view, i think we may need to come back to this
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBufferQueue"))
        captureSession.addOutput(videoOutput)
        videoOutput.connection(with: .video)?.videoOrientation = .portrait
        
        
    
    }
}


extension FrameHandler: AVCaptureVideoDataOutputSampleBufferDelegate {
    // invoked whenever there is a new frame
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: Frame, from connection: AVCaptureConnection) {
        // MARK: Rather than converting the frame to a CGImage, I think i just need to send it to the framePublisher
        // takes the frame from the sample buffer and converts it to a CGImage
        guard let cgImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else { return }
        DispatchQueue.main.async { [unowned self] in
            self.frame = cgImage
            
        }
        
        
        // Forward the frame through the publisher.
        framePublisher?.send(sampleBuffer)
        
    }
    
    // imageFromSampleBuffer passes the sampleBuffer (CoreMedia object) into an imageBuffer (CoreVideo object), which is passed to ciImage (CoreImage image) which is then converted to cgImage (CoreGraphics image).
    // MARK: Look at the imageFromFrame method in VideoProcessingChain in Guess My Exercise
    func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> CGImage? {
        
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        
        // Create a Core Image context.
        let ciContext = CIContext(options: nil)
        
        // Create a Core Image image from the sample buffer.
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        
        // if this fails, then try using the context which is a property of this class
        guard let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        
        return cgImage
    }
}


// MARK: I Just wanted to separate this. honestly i will probably put all the stuff from the sample project from apple developer in this extension 
extension FrameHandler {
    /// Sets the connection's orientation, image mirroring, and video stabilization.
    /// - Tag: configureCaptureConnection
    private func configureCaptureConnection(_ input: AVCaptureDeviceInput?,
                                            _ output: AVCaptureVideoDataOutput?) -> Bool {

        guard let input = input else { return false }
        guard let output = output else { return false }

        // Clear inputs and outputs from the capture session.
        captureSession.inputs.forEach(captureSession.removeInput)
        captureSession.outputs.forEach(captureSession.removeOutput)

        guard captureSession.canAddInput(input) else {
            print("The camera input isn't compatible with the capture session.")
            return false
        }

        guard captureSession.canAddOutput(output) else {
            print("The video output isn't compatible with the capture session.")
            return false
        }

        // Add the input and output to the capture session.
        captureSession.addInput(input)
        captureSession.addOutput(output)

        // This capture session must only have one connection.
        guard captureSession.connections.count == 1 else {
            let count = captureSession.connections.count
            print("The capture session has \(count) connections instead of 1.")
            return false
        }

        // Configure the first, and only, connection.
        guard let connection = captureSession.connections.first else {
            print("Getting the first/only capture-session connection shouldn't fail.")
            return false
        }

        // MARK: CAN PROBABLY UNCOMMENT ALL OF THIS IF I WANT TO HAVE MORE REACTIVITY / CUSTOMIZABILITY
        if connection.isVideoOrientationSupported {
            // Set the video capture's orientation to match that of the device.
            connection.videoOrientation = .portrait
        }
//
//        if connection.isVideoMirroringSupported {
//            connection.isVideoMirrored = horizontalFlip
//        }
//
//        if connection.isVideoStabilizationSupported {
//            if videoStabilizationEnabled {
//                connection.preferredVideoStabilizationMode = .standard
//            } else {
//                connection.preferredVideoStabilizationMode = .off
//            }
//        }

        // Discard newer frames if the app is busy with an earlier frame.
        output.alwaysDiscardsLateVideoFrames = true

        return true
    }
    
    
}
