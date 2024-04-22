//
//  TFFrameProcessingChain.swift
//  GymVision
//
//  Created by Vanessa Chambers on 4/19/24.
//

import Vision
import Combine
import CoreImage
import Accelerate
import TensorFlowLite


protocol TFFrameProcessingChainDelegate: AnyObject {

    /// Informs the delegate when a video frame chain predicts an action.
    /// - Parameters:
    ///   - chain: A video-processing chain.
    ///   - actionPrediction: An action prediction.
    ///   - duration: The span of time the prediction represents.
    func frameProcessingChain(_ chain: TFFrameProcessingChain,
                              didPredict actionPrediction: Inference,
                              for frames: Int)
    
    func frameProcessingChain(_ chain: TFFrameProcessingChain, didGet frame: CGImage)
    
    func frameProcessingChain(_ chain: TFFrameProcessingChain, didGet testFrames: [TestFrame])
    
}

/// Builds a chain of Combine publishers / subscribers from the upstream frame
/// (sample buffer) publisher.
/// - Tag: VideoProcessingChain
class TFFrameProcessingChain {
    /// The video-processing chain's delegate.
    ///
    /// Set this property to receive poses and action predictions.
    /// - Tag: delegate-VideoProcessingChain
    weak var delegate: TFFrameProcessingChainDelegate?

    /// The upstream frame publisher.
    ///
    /// Set this property to begin extracting poses and predicting actions.
    /// - Tag: upstreamFramePublisher
    var upstreamFramePublisher: AnyPublisher<Frame, Never>! {
        didSet { buildProcessingChain() }
    }

    /// A cancellation token for the active video-processing chain.
    ///
    /// To tear down the frame processing chain, call this property's `cancel()`
    /// method, or allow it to deinitialize.
    private var frameProcessingChain: AnyCancellable?

    /// A human body pose request instance that finds poses in each video frame.
    ///
    /// The video-processing chain reuses this instance for all frames from any
    /// upstream publisher.
    /// - Tag: humanBodyPoseRequest
    private let humanBodyPoseRequest = VNDetectHumanBodyPoseRequest()

    /// The action classifier that recognizes exercise activities.
    private var actionClassifier: TFActionClassifier?

    /// The number of pose data instances the action classifier needs
    /// to make a prediction.
    /// - Tag: predictionWindowSize
    private var predictionWindowSize: Int = 48

    /// The number of pose data instances the window advances after each
    /// prediction.
    ///
    /// Increase the stride's value to make predictions less frequently.
    /// - Tag: windowStride
    private let windowStride = 8

    /// A performance reporter that logs the number of predictions and frames
    /// that pass through the chain.
    ///
    /// The reporter prints the prediction and frame counts to the console
    /// every second.
    private var performanceReporter = PerformanceReporter()
    
    
    // MARK: TFLite stuff -- may change if I have diff models
    let batchSize = 1
    let wantedInputChannels = 3
    let wantedInputWidth = 224
    let wantedInputHeight = 224
    let stdDeviation: Float = 127.0
    let mean: Float = 1.0

    // MARK: Constants
    let threadCountLimit: Int32 = 10

    // MARK: Instance Variables
    /// The current thread count used by the TensorFlow Lite Interpreter.
    let threadCount: Int = 1
    
    
    init(modelFileInfo: FileInfo, labelsFileInfo: FileInfo ) {
        TFActionClassifier.setup(TFActionClassifier.Config(modelFileInfo: modelFileInfo, labelsFileInfo: labelsFileInfo))
        guard let actionClassifier = TFActionClassifier.shared else {
            return
        }
        self.actionClassifier = actionClassifier
    }
    
    /// Stop the combine publisher
    func stopTasks() {
        frameProcessingChain?.cancel()
        performanceReporter?.stopTasks()
    }
    
    func scaledData(_ cgImage: CGImage) -> Data? {
        let cgImageNoAlpha = cgImage.removeAlpha()
        
        let size = CGSize(width: CGFloat(self.wantedInputWidth), height: CGFloat(self.wantedInputWidth))
        let cgImageResized = cgImageNoAlpha?.resize(size: size)
        
        guard let scaledBytes = cgImageResized?.dataProvider?.data as Data? else { return nil }
        let scaledInts = scaledBytes.map { Int32(Float32($0) / Constant.maxRGBValue) }
        print("🫨scaled ints length \(scaledInts.count)") // image no alpha height \(cgImageNoAlpha?.height), width: \(cgImageNoAlpha?.width)")
        
        return Data(copyingBufferOf: scaledInts)
//
//        let bitmapInfo = CGBitmapInfo(
//          rawValue: CGImageAlphaInfo.none.rawValue
//        )
//        let destWidth = self.wantedInputWidth
//        let destHeight = self.wantedInputHeight
//        let bitsPerComponent = 8
//        let bytesPerPixel = cgImage.bitsPerPixel / bitsPerComponent
//        print("🤢 look here at \(bytesPerPixel)")
//        let destBytesPerRow = destWidth * 3
//        
//        
//        // remove alpha from image
//        let context = CGContext(
//            data: nil, 
//            width: cgImage.width,
//            height: cgImage.height, 
//            bitsPerComponent: cgImage.bitsPerComponent,
//            bytesPerRow: cgImage.bytesPerRow,
//            space: cgImage.colorSpace!,
//            bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!
//        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: context.width, height: context.height))
//        return context.makeImage()
        
        
        
//            context.interpolationQuality = .high
        
//            context.draw(cgImage, in: CGRect(origin: CGPoint.zero, size: size))
//        let cgImageNoAlpha = context.makeImage()
//        
//        let resizeContext =
//        
//        
//       
//        
//        context.draw(cgImage, in: CGRect(origin: .zero, size: size))
//        guard let scaledBytes = context.makeImage()?.dataProvider?.data as Data? else { return nil }
//        let scaledInts = scaledBytes.map { Int32(Float32($0) / Constant.maxRGBValue) }
//        
//        return Data(copyingBufferOf: scaledInts)
  }
}

// MARK: - Combine Chain Builder
extension TFFrameProcessingChain {
    /// Clears and (re)builds a series of Combine publishers that subscribes to
    /// a video frame publisher and generates action predictions.
    ///
    /// The chain starts with the `upstreamFramePublisher` property and daisy-
    /// chains additional publishers that each subscribe to their upstream publisher.
    /// Each publisher in the chain transforms its input into an output
    /// it publishes to the next publisher in the chain.
    ///
    /// The last publisher in the chain generates action predictions.
    /// The final entity in the chain is a subscriber that receives action
    /// predictions and relays them to the video-processing chain's delegate by
    /// calling its `sendPrediction(_:)`method.
    /// - Tag: buildProcessingChain
    // MARK: REMOVED MUTATING BEFORE FUNC... NOT SURE HOW THIS WILL IMPACT IT
    private func buildProcessingChain() {
        // Only continue with a valid upstream frame publisher.
        guard upstreamFramePublisher != nil else { return }

        // Create the chain of publisher-subscribers that transform the raw video
        // frames from upstreamFramePublisher.
        frameProcessingChain = upstreamFramePublisher
            // ---- Frame (aka CMSampleBuffer) -- Frame ----
            
            // Convert each frame to a CGImage, skipping any that don't convert.
//            .compactMap(imageFromFrame)
            // Convert each CGImage to a Data, skipping any that don't convert
//            .map(scaledData)
            // Gather a window of multiarrays, starting with an empty window.
            
            .compactMap(pixelBufferFromFrame)
//            .compactMap(updateFrame)
            
            .compactMap(centerThumbnail)
//            .compactMap(updateFrame)
//            .compactMap(updateFrame)
            .map(rgbDataFromBuffer)
        
            .scan([Data?](), gatherWindow)

            // ---- [MLMultiArray?] -- [MLMultiArray?] ----

            // Only publish a window when it grows to the correct size.
            .filter(gateWindow)
            
            .map(getEveryOtherFrame)

            // ---- [MLMultiArray?] -- [MLMultiArray?] ----

            // Make an activity prediction from the window.
//            ./*flatMap(maxPublishers: .max(1)) { window in self.predictActionWithWindow(wind*/ow) }
            .map(predictActionWithWindow)
            // Send the action prediction to the delegate.
            .sink(receiveValue: sendPrediction)
    }
}
// MARK: - Transforms for Combine
extension TFFrameProcessingChain {
    
    private func pixelBufferFromFrame(_ buffer: Frame) -> CVPixelBuffer? {
        performanceReporter?.incrementFrameCount()

        guard let imageBuffer = buffer.imageBuffer else {
            print("The frame doesn't have an underlying image buffer.")
            return nil
        }
        
        // Create a Core Image context.
        let ciContext = CIContext(options: nil)

        // Create a Core Image image from the sample buffer.
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)

        // Generate a Core Graphics image from the Core Image image.
        guard let cgImage = ciContext.createCGImage(ciImage,
                                                    from: ciImage.extent) else {
            print("Unable to create an image from a frame.")
            return nil
        }
        DispatchQueue.main.async {
            self.delegate?.frameProcessingChain(self, didGet: cgImage)
        }
        return imageBuffer
    }
    /// Converts a sample buffer into a core graphics image.
    /// - Parameter buffer: A sample buffer, typically from a video capture.
    /// - Returns: A `CGImage` if Core Image successfully converts the sample
    /// buffer; otherwise `nil`.
    /// - Tag: imageFromFrame
    private func updateFrame(_ pixelBuffer: CVPixelBuffer) -> CVPixelBuffer? {
        
        
        return pixelBuffer
        
    }
    private func imageFromFrame(_ buffer: Frame) -> CGImage? {
        // Inform the performance reporter to log the frame in its count.
        performanceReporter?.incrementFrameCount()

        guard let imageBuffer = buffer.imageBuffer else {
            print("The frame doesn't have an underlying image buffer.")
            return nil
        }

        // Create a Core Image context.
        let ciContext = CIContext(options: nil)

        // Create a Core Image image from the sample buffer.
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)

        // Generate a Core Graphics image from the Core Image image.
        guard let cgImage = ciContext.createCGImage(ciImage,
                                                    from: ciImage.extent) else {
            print("Unable to create an image from a frame.")
            return nil
        }
        return cgImage
    }


    /// Collects a window of multiarrays by appending the most recent
    /// multiarray to the window.
    ///
    /// - Parameters:
    ///   - previousWindow: The previous window state from the last invocation.
    ///   - multiArray: The newest multiarray.
    /// - Returns: An`MLMultiArray` array.
    /// Before the methods appends the most recent body pose multiarray
    /// to the window, it removes the oldest multiarray elements
    /// if the previous window's count is the target size.
    /// - Tag: gatherWindow
    private func gatherWindow(previousWindow: [Data?],
                              currentFrame: Data?) -> [Data?] {
        var currentWindow = previousWindow

        // If the previous window size is the target size, it
        // means sendWindowWhenReady() just published an array window.
        if previousWindow.count == predictionWindowSize {
            // Advance the sliding array window by stride elements.
            currentWindow.removeFirst(windowStride)
        }

        // Add the newest multiarray to the window.
        currentWindow.append(currentFrame)

        // Publish the array window to the next subscriber.
        // The currentWindow becomes this method's next previousWindow when
        // it receives the next multiarray from the upstream publisher.
        return currentWindow
    }

    /// Returns a Boolean that indicates whether the window contains the
    /// number of multiarray elements the action classifier needs to make a
    /// prediction.
    /// - Parameter currentWindow: An array of multiarray optionals.
    /// - Returns: `true` if `currentWindow` contains `predictionWindowSize`
    /// elements; otherwise `false`.
    /// - Tag: gateWindow
    private func gateWindow(_ currentWindow: [Data?]) -> Bool {
        // TODO: need to figure out how to get every other frame.....
//        print("🥸 currentnwindow count \(currentWindow.count)")
        return currentWindow.count == predictionWindowSize
    }
    
    /// Returns every other element from the array, ready for inferece
    private func getEveryOtherFrame(_ frames: [Data?]) -> [Data?] {
//        return frames.enumerated().compactMap { $0.offset % 2 == 0 ? $0.element : nil }
        
        return frames.indices.compactMap {
            if $0 % 2 == 0 { return frames[$0] }
            else { return nil }
        }
    }
    
    /// Converts Frame object to an RGB Data object that can be used by the model
//    private func rgbDatafromFrame(_ frames: [Frame?]) -> [Data?] {
//        let frameData: [Data?] = frames.map { frame in
//            let buffer = CMSampleBufferGetImageBuffer(frame!)!
//            CVPixelBufferLockBaseAddress(buffer, .readOnly)
//            
//            // MARK: I have no idea what this line does:
//            defer { CVPixelBufferUnlockBaseAddress(buffer, .readOnly) }
//            
//            let sourceData = CVPixelBufferGetBaseAddress(buffer)!
//            let width = CVPixelBufferGetWidth(buffer)
//            let height = CVPixelBufferGetHeight(buffer)
//            let sourceBytesPerRow = CVPixelBufferGetBytesPerRow(buffer)
//            let destinationChannelCount = 3
//            let destinationBytesPerRow = destinationChannelCount * width
//
//            var sourceBuffer = vImage_Buffer(data: sourceData,
//                                             height: vImagePixelCount(height),
//                                             width: vImagePixelCount(width),
//                                             rowBytes: sourceBytesPerRow)
//
//            guard let destinationData = malloc(height * destinationBytesPerRow) else {
//                    print("Error: out of memory")
//            }
//            
//            defer {
//                free(destinationData)
//            }
//
//            var destinationBuffer = vImage_Buffer(data: destinationData,
//                                                  height: vImagePixelCount(height),
//                                                  width: vImagePixelCount(width),
//                                                  rowBytes: destinationBytesPerRow)
//
//            vImageConvert_BGRA8888toRGB888(&sourceBuffer, &destinationBuffer, UInt32(kvImageNoFlags))
//
//            let byteData = Data(bytes: destinationBuffer.data, count: destinationBuffer.rowBytes * height)
//
//            // Not quantized, convert to floats
//            let bytes = Array<UInt8>(unsafeData: byteData)!
//            var floats = [Float]()
//            for i in 0..<bytes.count {
//                floats.append(Float(bytes[i]) / 255.0)
//            }
//            return Data(copyingBufferOf: floats)
//          }
//            
//        }

    /// Makes a prediction from the multiarray window.
    /// - Parameter currentWindow: An`MLMultiArray?` array.
    /// - Returns: An `ActionPrediction`.
    /// - Tag: predictActionWithWindow
    private func predictActionWithWindow(_ currentWindow: [Data?]) -> Inference? {// AnyPublisher<Inference, Never> {
        var poseCount = 0
        
        let prediction = self.actionClassifier?.runModel(on: currentWindow)
        // MARK: this is for model testing purposes
//        guard let frameImages = self.actionClassifier?.dataToImage(currentWindow) else { return nil }
//        DispatchQueue.main.async {
//            self.delegate?.frameProcessingChain(self, didGet: frameImages)
//        }
        
        return prediction
        
//        return Future<Inference, Never> { promise in
//                DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [unowned self] in
//                    guard let res = self.actionClassifier?.runModel(on: currentWindow) else { return }
//                    promise(.success(res))
//                }
//            }
//            .eraseToAnyPublisher()
        
    }

    /// Sends an action prediction to the delegate on the main thread.
    /// - Parameter actionPrediction: The action classifier's prediction.
    /// - Tag: checkConfidence
    private func checkConfidence(_ actionPrediction: ActionPrediction) -> ActionPrediction {
        let minimumConfidence = 0.6

        let lowConfidence = actionPrediction.confidence < minimumConfidence
        return lowConfidence ? .lowConfidencePrediction : actionPrediction
        
        
    }
    
    private func sendPrediction(_ actionPrediction: Inference?) {
        // Send the prediction to the delegate on the main queue.
        
        guard let actionPrediction = actionPrediction  else { return }
        DispatchQueue.main.async {
            self.delegate?.frameProcessingChain(self,
                                                didPredict: actionPrediction,
                                                for: self.windowStride)
        }

        // Inform the performance reporter to log the prediction in its count.
        performanceReporter?.incrementPrediction()
    }

 
}

/// Methods for image pre processing
extension TFFrameProcessingChain {
    private func centerThumbnail(from pixelBuffer: CVPixelBuffer) -> CVPixelBuffer? {
        
        
        let size = CGSize(width: self.wantedInputWidth, height: self.wantedInputHeight)
        let imageWidth = CVPixelBufferGetWidth(pixelBuffer)
        let imageHeight = CVPixelBufferGetHeight(pixelBuffer)
        let pixelBufferType = CVPixelBufferGetPixelFormatType(pixelBuffer)

        assert(pixelBufferType == kCVPixelFormatType_32BGRA)

        let inputImageRowBytes = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let imageChannels = 4

        let thumbnailSize = min(imageWidth, imageHeight)
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))

        var originX = 0
        var originY = 0

        if imageWidth > imageHeight {
          originX = (imageWidth - imageHeight) / 2
        }
        else {
          originY = (imageHeight - imageWidth) / 2
        }

        // Finds the biggest square in the pixel buffer and advances rows based on it.
        guard let inputBaseAddress = CVPixelBufferGetBaseAddress(pixelBuffer)?.advanced(by: originY * inputImageRowBytes + originX * imageChannels) else {
          return nil
        }

        // Gets vImage Buffer from input image
        var inputVImageBuffer = vImage_Buffer(data: inputBaseAddress, height: UInt(thumbnailSize), width: UInt(thumbnailSize), rowBytes: inputImageRowBytes)

        let thumbnailRowBytes = Int(size.width) * imageChannels
        guard  let thumbnailBytes = malloc(Int(size.height) * thumbnailRowBytes) else {
          return nil
        }

        // Allocates a vImage buffer for thumbnail image.
        var thumbnailVImageBuffer = vImage_Buffer(data: thumbnailBytes, height: UInt(size.height), width: UInt(size.width), rowBytes: thumbnailRowBytes)

        // Performs the scale operation on input image buffer and stores it in thumbnail image buffer.
        let scaleError = vImageScale_ARGB8888(&inputVImageBuffer, &thumbnailVImageBuffer, nil, vImage_Flags(0))

        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))

        guard scaleError == kvImageNoError else {
          return nil
        }

        let releaseCallBack: CVPixelBufferReleaseBytesCallback = {mutablePointer, pointer in

          if let pointer = pointer {
            free(UnsafeMutableRawPointer(mutating: pointer))
          }
        }

        var thumbnailPixelBuffer: CVPixelBuffer?

        // Converts the thumbnail vImage buffer to CVPixelBuffer
        let conversionStatus = CVPixelBufferCreateWithBytes(nil, Int(size.width), Int(size.height), pixelBufferType, thumbnailBytes, thumbnailRowBytes, releaseCallBack, nil, nil, &thumbnailPixelBuffer)

        guard conversionStatus == kCVReturnSuccess else {

          free(thumbnailBytes)
          return nil
        }

        return thumbnailPixelBuffer
      }
        
    /// Returns the RGB data representation of the given image buffer with the specified `byteCount`.
      ///
      /// - Parameters
      ///   - buffer: The BGRA pixel buffer to convert to RGB data.
      ///   - byteCount: The expected byte count for the RGB data calculated using the values that the
      ///       model was trained on: `batchSize * imageWidth * imageHeight * componentsCount`.
      ///   - isModelQuantized: Whether the model is quantized (i.e. fixed point values rather than
      ///       floating point values).
      /// - Returns: The RGB data representation of the image buffer or `nil` if the buffer could not be
      ///     converted.
      private func rgbDataFromBuffer(
        _ buffer: CVPixelBuffer
      ) -> Data? {
        let byteCount = batchSize * wantedInputWidth * wantedInputHeight * wantedInputChannels
        CVPixelBufferLockBaseAddress(buffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(buffer, .readOnly) }

        let pixelBufferFormat = CVPixelBufferGetPixelFormatType(buffer)
        assert(pixelBufferFormat == kCVPixelFormatType_32BGRA)

        guard let sourceData = CVPixelBufferGetBaseAddress(buffer) else {
            return nil
        }

        let width = CVPixelBufferGetWidth(buffer)
        let height = CVPixelBufferGetHeight(buffer)
        let sourceBytesPerRow = CVPixelBufferGetBytesPerRow(buffer)
        let destinationChannelCount = 3
        let destinationBytesPerRow = destinationChannelCount * width

        var sourceBuffer = vImage_Buffer(data: sourceData,
                                         height: vImagePixelCount(height),
                                         width: vImagePixelCount(width),
                                         rowBytes: sourceBytesPerRow)

        guard let destinationData = malloc(height * destinationBytesPerRow) else {
            print("Error: out of memory")
            return nil
        }

        defer {
            free(destinationData)
        }

        var destinationBuffer = vImage_Buffer(data: destinationData,
                                              height: vImagePixelCount(height),
                                              width: vImagePixelCount(width),
                                              rowBytes: destinationBytesPerRow)

        vImageConvert_BGRA8888toRGB888(&sourceBuffer, &destinationBuffer, UInt32(kvImageNoFlags))

        let byteData = Data(bytes: destinationBuffer.data, count: destinationBuffer.rowBytes * height)

        // Not quantized, convert to floats
        let bytes = Array<UInt8>(unsafeData: byteData)!
        var floats = [Float]()
        for i in 0..<bytes.count {
            floats.append(Float(bytes[i]) / 255.0)
        }
        return Data(copyingBufferOf: floats)
      }
}

extension Data {
  /// Creates a new buffer by copying the buffer pointer of the given array.
  ///
  /// - Warning: The given array's element type `T` must be trivial in that it can be copied bit
  ///     for bit with no indirection or reference-counting operations; otherwise, reinterpreting
  ///     data from the resulting buffer has undefined behavior.
  /// - Parameter array: An array with elements of type `T`.
  init<T>(copyingBufferOf array: [T]) {
    self = array.withUnsafeBufferPointer(Data.init)
  }
    

}

// MARK: - Constants
private enum Constant {
  static let maxRGBValue: Float32 = 255.0
}


extension CGImage {
    func removeAlpha() -> CGImage? {
        let context = CGContext(
            data: nil,
            width: self.width,
            height: self.height,
            bitsPerComponent: self.bitsPerComponent,
            bytesPerRow: self.bytesPerRow,
            space: self.colorSpace!,
            bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!
        context.draw(self, in: CGRect(x: 0, y: 0, width: context.width, height: context.height))
        return context.makeImage()
    }
}


extension CGImage {
    func resize(size:CGSize) -> CGImage? {
        let width: Int = Int(size.width)
        let height: Int = Int(size.height)

        let bytesPerPixel = self.bitsPerPixel / self.bitsPerComponent
        let destBytesPerRow = width * bytesPerPixel


        guard let colorSpace = self.colorSpace else { return nil }
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: self.bitsPerComponent, bytesPerRow: destBytesPerRow, space: colorSpace, bitmapInfo: self.alphaInfo.rawValue) else { return nil }

        context.interpolationQuality = .high
        context.draw(self, in: CGRect(x: 0, y: 0, width: width, height: height))

        return context.makeImage()
    }
}
