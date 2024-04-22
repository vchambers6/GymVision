////
////  ModelDataHandler.swift
////  GymVision
////
////  Created by Vanessa Chambers on 4/18/24.
////
//
//import Foundation
//
//import Accelerate
//import CoreImage
//import CoreMedia
//import TensorFlowLite
//
//
//struct Inference {
//    let confidence: Float
//    let label: String
//}
//
//typealias FileInfo = (name: String, extension: String)
//
//enum Model {
//    static let modelInfo: FileInfo = (name: "model", extension: "tflite")
//    static let labelsInfo: FileInfo = (name: "labels", extension: "txt")
//}
//
//
//class ModelDataHandler {
//    
//    // MARK: Paremeters on which model was trained
//    let batchSize = 1
//    let wantedInputChannels = 3
//    let wantedInputWidth = 224
//    let wantedInputHeight = 224
//    let stdDeviation: Float = 127.0
//    let mean: Float = 1.0
//    
//    // MARK: im not sure what this should be. it could need to be 44 for me idk
//    let threadCountLimit: Int32 = 10
//    
//    let threadCount: Int
//    
//    var labels: [String] = []
//    private let resultCount = 1
//    private let threshold = 0.5
//    
//    // TFLite interpreter for inferencing
//    private var interpreter: Interpreter
//    
//    private let bgraPixel = (channels: 4, alphaComponent: 3, lastBgrComponent: 2)
//    private let rgbPixelChannels = 3
//    private let colorStrideValue = 10
//
//    /// Information about the alpha component in RGBA data.
//    private let alphaComponent = (baseOffset: 4, moduloRemainder: 3)
//    
//    init?(modelFileInfo: FileInfo, labelsFileInfo: FileInfo, threadCount: Int = 1) {
//        
//        guard let modelPath = Bundle.main.path(
//            forResource: modelFileInfo.name,
//            ofType: modelFileInfo.extension
//        ) else {
//            print("Failed to load TensorFlowLite model file with name \(modelFileInfo.name)")
//            return nil
//        }
//        
//        self.threadCount = threadCount
//        var options = Interpreter.Options()
//        options.threadCount = threadCount
//        
//        do {
//            interpreter = try Interpreter(modelPath: modelPath, options: options)
//            try interpreter.allocateTensors()
//        }  catch let error {
//            print("failed to create interpretor with error: \(error.localizedDescription)")
//            return nil
//        }
//        
//        // Opens and loads clases listed into labels file
//        loadLabels(fromFileName: Model.labelsInfo.name, fileExtension: Model.labelsInfo.extension)
//    }
//    
//    func runModel(onData rgbFrameData: [Data]) -> [Inference] {
//        let outputTensor: Tensor
//        
//        // Copy the RGB data to the input `Tensor`.
//        for rgbFrame in rgbFrameData {
//            try interpreter.copy(rgbFrame, toInputAt: 0)
//            try interpreter.invoke()
//            let outputTensor = try interpreter.output(at: 0)
//        }
//        
//        
//        // Perform inference on loaded data
//        
//        
//        
//        
//    }
//}
//
//
//// MARK: Methods for data preprocessing and post processing:
//extension ModelDataHandler {
//    /**
//    Loads the labels from the labels file and stores it in an instance variable
//    */
//    func loadLabels(fromFileName fileName: String, fileExtension: String) {
//
//        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
//          fatalError("Labels file not found in bundle. Please add a labels file with name \(fileName).\(fileExtension) and try again")
//        }
//        do {
//          let contents = try String(contentsOf: fileURL, encoding: .utf8)
//          self.labels = contents.components(separatedBy: ",")
//          self.labels.removeAll { (label) -> Bool in
//            return label == ""
//          }
//        }
//        catch {
//          fatalError("Labels file named \(fileName).\(fileExtension) cannot be read. Please add a valid labels file and try again.")
//        }
//
//      }
//    
//    // MARK: may need to change return type to pixel buffer, but im not sure it matters
//    private func centerThumbnail(from frameBuffer: Frame, size: CGSize) -> CVPixelBuffer? {
//        
//        guard let pixelBuffer = CMSampleBufferGetImageBuffer(frameBuffer) else {
//            print("failed to unwrap image buffer from Frame")
//            return nil
//        }
//        
//        let imageWidth = CVPixelBufferGetWidth(pixelBuffer)
//        let imageHeight = CVPixelBufferGetHeight(pixelBuffer)
//        let pixelBufferType = CVPixelBufferGetPixelFormatType(pixelBuffer)
//        
//        assert(pixelBufferType == kCVPixelFormatType_32BGRA)
//        
//        let inputImageRowBytes = CVPixelBufferGetBytesPerRow(pixelBuffer)
//        let imageChannels = 4
//        
//        let thumbnailSize = min(imageWidth, imageHeight)
//        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
//        
//        var originX = 0
//        var originY = 0
//        
//        if imageWidth > imageHeight {
//            originX = (imageWidth - imageHeight) / 2
//        } else {
//            originY = (imageHeight - imageWidth ) / 2
//        }
//        
//        // Finds biggest square in pixel buffer and advances rows based on it -- not sure what this means
//        guard let inputBaseAddress = CVPixelBufferGetBaseAddress(pixelBuffer)?.advanced(by: originY * inputImageRowBytes + originX * imageChannels) else {
//              return nil
//        }
//        
//        // Gets vImage Buffer from input image -- stores image pixel information and row stride
//        var inputVImageBuffer = vImage_Buffer(data: inputBaseAddress, height: UInt(thumbnailSize), width: UInt(thumbnailSize), rowBytes: inputImageRowBytes)
//        
//        let thumbnailRowBytes = Int(size.width) * imageChannels
//        guard  let thumbnailBytes = malloc(Int(size.height) * thumbnailRowBytes) else {
//              return nil
//            }
//        
//        // Allocates a vImage buffer for thumbnail image.
//        var thumbnailVImageBuffer = vImage_Buffer(data: thumbnailBytes, height: UInt(size.height), width: UInt(size.width), rowBytes: thumbnailRowBytes)
//        
//        // Performs scale operation on input image buffer and stores it in thumbnail image buffer
//        let scaleError = vImageScale_ARGB8888(&inputVImageBuffer, &thumbnailVImageBuffer, nil, vImage_Flags(0))
//        
//        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
//        
//        guard scaleError == kvImageNoError else {
//              return nil
//            }
//        
//        let releaseCallBack: CVPixelBufferReleaseBytesCallback = {mutablePointer, pointer in
//
//              if let pointer = pointer {
//                free(UnsafeMutableRawPointer(mutating: pointer))
//              }
//            }
//
//            var thumbnailPixelBuffer: CVPixelBuffer?
//
//            // Converts the thumbnail vImage buffer to CVPixelBuffer
//            let conversionStatus = CVPixelBufferCreateWithBytes(nil, Int(size.width), Int(size.height), pixelBufferType, thumbnailBytes, thumbnailRowBytes, releaseCallBack, nil, nil, &thumbnailPixelBuffer)
//
//            guard conversionStatus == kCVReturnSuccess else {
//
//              free(thumbnailBytes)
//              return nil
//            }
//
//        return thumbnailPixelBuffer
//      }
//    
//    // MARK: not sure if isModelQuantized should be set to true or not
//    private func rgbDataFromBuffer(_ buffer: CVPixelBuffer, isModelQuantized: Bool = false) -> Data? {
//        
//        let byteCount = self.batchSize * self.wantedInputWidth * self.wantedInputChannels
//        
//        
//        CVPixelBufferLockBaseAddress(buffer, .readOnly)
//        defer { CVPixelBufferUnlockBaseAddress(buffer, .readOnly) }
//
//        let pixelBufferFormat = CVPixelBufferGetPixelFormatType(buffer)
//        assert(pixelBufferFormat == kCVPixelFormatType_32BGRA)
//
//        guard let sourceData = CVPixelBufferGetBaseAddress(buffer) else {
//            return nil
//        }
//
//        let width = CVPixelBufferGetWidth(buffer)
//        let height = CVPixelBufferGetHeight(buffer)
//        let sourceBytesPerRow = CVPixelBufferGetBytesPerRow(buffer)
//        let destinationChannelCount = 3
//        let destinationBytesPerRow = destinationChannelCount * width
//
//        var sourceBuffer = vImage_Buffer(data: sourceData,
//                                         height: vImagePixelCount(height),
//                                         width: vImagePixelCount(width),
//                                         rowBytes: sourceBytesPerRow)
//
//        guard let destinationData = malloc(height * destinationBytesPerRow) else {
//            print("Error: out of memory")
//            return nil
//        }
//
//        defer {
//            free(destinationData)
//        }
//
//        var destinationBuffer = vImage_Buffer(data: destinationData,
//                                              height: vImagePixelCount(height),
//                                              width: vImagePixelCount(width),
//                                              rowBytes: destinationBytesPerRow)
//
//        vImageConvert_BGRA8888toRGB888(&sourceBuffer, &destinationBuffer, UInt32(kvImageNoFlags))
//
//        let byteData = Data(bytes: destinationBuffer.data, count: destinationBuffer.rowBytes * height)
//        if isModelQuantized {
//            return byteData
//        }
//        
//        // Not quantized, convert to floats
//        let bytes = Array<UInt8>(unsafeData: byteData)!
//        var floats = [Float]()
//        for i in 0..<bytes.count {
//            floats.append(Float(bytes[i]) / 255.0)
//        }
//        return Data(copyingBufferOf: floats)
//    }
//    
//}
//
//// MARK: Methods for inference:
//extension ModelDataHandler {
//    /// Returns the top N inference results sorted in descending order.
//      private func getTopN(results: [Float]) -> [Inference] {
//        // Create a zipped array of tuples [(labelIndex: Int, confidence: Float)].
//        let zippedResults = zip(labels.indices, results)
//
//        // Sort the zipped results by confidence value in descending order.
//        let sortedResults = zippedResults.sorted { $0.1 > $1.1 }.prefix(resultCount)
//
//        // Return the `Inference` results.
//        return sortedResults.map { result in Inference(confidence: result.1, label: labels[result.0]) }
//      }
//}
//
//
//extension Data {
//  /// Creates a new buffer by copying the buffer pointer of the given array.
//  ///
//  /// - Warning: The given array's element type `T` must be trivial in that it can be copied bit
//  ///     for bit with no indirection or reference-counting operations; otherwise, reinterpreting
//  ///     data from the resulting buffer has undefined behavior.
//  /// - Parameter array: An array with elements of type `T`.
//  init<T>(copyingBufferOf array: [T]) {
//    self = array.withUnsafeBufferPointer(Data.init)
//  }
//}
//
//extension Array {
//  /// Creates a new array from the bytes of the given unsafe data.
//  ///
//  /// - Warning: The array's `Element` type must be trivial in that it can be copied bit for bit
//  ///     with no indirection or reference-counting operations; otherwise, copying the raw bytes in
//  ///     the `unsafeData`'s buffer to a new array returns an unsafe copy.
//  /// - Note: Returns `nil` if `unsafeData.count` is not a multiple of
//  ///     `MemoryLayout<Element>.stride`.
//  /// - Parameter unsafeData: The data containing the bytes to turn into an array.
//  init?(unsafeData: Data) {
//    guard unsafeData.count % MemoryLayout<Element>.stride == 0 else { return nil }
//    #if swift(>=5.0)
//    self = unsafeData.withUnsafeBytes { .init($0.bindMemory(to: Element.self)) }
//    #else
//    self = unsafeData.withUnsafeBytes {
//      .init(UnsafeBufferPointer<Element>(
//        start: $0,
//        count: unsafeData.count / MemoryLayout<Element>.stride
//      ))
//    }
//    #endif  // swift(>=5.0)
//  }
//}
