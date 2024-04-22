//
//  TFActionClassifier.swift
//  GymVision
//
//  Created by Vanessa Chambers on 4/18/24.
//

import Accelerate
import CoreImage
import CoreML
import TensorFlowLite


/// Stores one formatted inference.
struct Inference {
  let confidence: Float
  let label: String
    
    /// A string that represents the confidence as percentage if applicable;
    /// otherwise `nil`.
    var confidenceString: String? {
        // Convert the confidence to a percentage based string.
        let percent = confidence * 100
        let formatString = percent >= 99.5 ? "%2.0f %%" : "%2.1f %%"
        return String(format: formatString, percent)
    }
}

struct TestFrame: Identifiable {
    var id: UUID
    
    var image: UIImage
    var frameCount: Int
}

/// Information about a model file or labels file.
typealias FileInfo = (name: String, extension: String)

/// Information about the model to be loaded.
enum Model {
  static let modelInfo: FileInfo = (name: "model", extension: "tflite")
  static let labelsInfo: FileInfo = (name: "labels", extension: "txt")
}

class TFActionClassifier {
    
    static let shared = TFActionClassifier()
    private let frameCount: Int = 24
    private var labels: [String] = []
    
    private var interpreter: Interpreter?
    private var initialInterpreter: Interpreter?
    struct Config {
        let modelFileInfo: FileInfo
        let labelsFileInfo: FileInfo
    }
    private static var config:Config?
    
    class func setup(_ config:Config){
        TFActionClassifier.config = config
    }
    init?() {
        // Construct the path to the model file.
        guard let config = TFActionClassifier.config else {
            fatalError("Error - you must call setup before accessing MySingleton.shared")
        }
        guard let modelPath = Bundle.main.path(
            forResource: config.modelFileInfo.name,
            ofType: config.modelFileInfo.extension
        ) else {
            return
        }

        var options = Interpreter.Options()
        options.threadCount = 4
        do {
            self.interpreter = try Interpreter(modelPath: modelPath, options: options)
//            try interpreter?.allocateTensors()
//            initializeInterpreterInput()
//            self.interpreter = initialInterpreter
        } catch {
            print("error initializing TFLite interpreter \(error)")
        }
        
        loadLabels(fromFileName: config.labelsFileInfo.name, fileExtension: config.labelsFileInfo.extension)
    }
    
    
    /// This function tells you the input and output details of the interpretor
    func runModel(on window: [Data?]) -> Inference? {
        print("🏁started running model")
        guard let interpreter = self.interpreter else { return nil }
        /// allocate tensors for model input and output.
        do {
//            let test = TFActionClassifierInputs.shared.getInterpreter()
//            self.interpreter = test
            try interpreter.allocateTensors()
            initializeInterpreterInput()
            
        } catch {
            print("❌ error allocating tensors \(error)")
        }
        print("✅initialized input tensors")
        let data = try! interpreter.input(at: 37).data
        let floats = data.withUnsafeBytes { (rawBufferPointer) -> [Float32] in
            let floatBufferPointer = rawBufferPointer.bindMemory(to: Float32.self)
             return Array(floatBufferPointer)
        }
//        print("input tensor data \(floats)")
        
        
        
        /// inference on each frame
        var logits: [Float32]?
        do {
            var count = 0
//            print("🤠# of frames in winow \(window.count)")
            for frame in window {
//                print("😹current frame count \(count) \n")
                guard let frame = frame else { return nil }
                // replace the item at index 37 with the current frame
                try interpreter.copy(frame, toInputAt: 37)
                
                // run the model on input
                try interpreter.invoke()
                
                // save the logits from this loop
                let logits_data = try interpreter.output(at: 10)
                logits = [Float32](unsafeData: logits_data.data)
                
                // update the input tensors with te results from the ouputs
                self.updateInputTensors()
                count = count + 1
            }
            
        } catch {
            print("❌error in running inference on data \(error)")
        }
        
        // Get probabilites from logits
        guard let logits = logits else { return nil}
        let probabilities = softmax(logits)
        let (index, confidence) = argmax(probabilities)
        print("👺 here are the logits \(logits)")
        print("❤️pred is \(self.labels[index]) with confidence \(confidence)")
//        dataToImage(window)
         return Inference(confidence: confidence, label: self.labels[index])
        
        
        
    }
    func updateInputTensors() {
        for i in 0..<44 {
            do {
                if let output = try interpreter?.output(at: i) {
                    /// don't want to copy the logits, which is at index 10
                    if i == 10{
                        continue
                    } /// want to copy everything up until the 37th index for the outputs, so  i -> (i-1) up until (i-1) = 36. the image goes at 37.
                    else if (11...37).contains(i) {
                        try interpreter?.copy(output.data, toInputAt: i - 1)
                    } else {
                        try interpreter?.copy(output.data, toInputAt: i)
                    }
                }
            } catch {
                fatalError("error transferring output at index \(i): \(error)")
            }
        }
    }
    func initializeInterpreterInput() {
        
        let actionClassifierInputHelper = TFActionClassifierInputs.shared
        for i in 0..<44 {
            do {
                if let input = try interpreter?.input(at: i) {
                    let data = actionClassifierInputHelper.getDataObjectFor(shape: input.shape.dimensions, of: input.dataType)!
                    try interpreter?.copy(data, toInputAt: i)
                }
            } catch {
                print("❌error accessing interpreter input at index \(i) \n\(error)")
            }
            
        }
    }
    func loadLabels(fromFileName fileName: String, fileExtension: String) {

        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
          fatalError("Labels file not found in bundle. Please add a labels file with name \(fileName).\(fileExtension) and try again")
        }
        do {
          let contents = try String(contentsOf: fileURL, encoding: .utf8)
          self.labels = contents.components(separatedBy: ",")
          self.labels.removeAll { (label) -> Bool in
            return label == ""
          }
        }
        catch {
          fatalError("Labels file named \(fileName).\(fileExtension) cannot be read. Please add a valid labels file and try again.")
        }

      }
    
    func dataToImage(_ dataList: [Data?]) -> [TestFrame] {
        let width: Int = 224
        let height: Int = 224
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var count = 1
        let bitmapInfo = CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue
        var res = [TestFrame]()
        for img in dataList {
//            let source = CGImageSourceCreateWithData(img! as CFData, nil)!
//            let cgImage = CGImageSourceCreateImageAtIndex(source, 0, [:] as CFDictionary)
//            guard let cgImage = CGImage(
//                   width: width,
//                   height: height,
//                   bitsPerComponent: 8,
//                   bitsPerPixel: 32,
//                   bytesPerRow: width * 4,
//                   space: CGColorSpaceCreateDeviceRGB(),
//                   bitmapInfo: CGBitmapInfo(rawValue: bitmapInfo),
//                   provider: CGDataProvider(data: img! as CFData)!,
//                   decode: nil,
//                   shouldInterpolate: false,
//                   intent: .defaultIntent
//               ) else {
//                   return []
//               }
            
            do {
                guard let imgFrom = img else { return [] }
                
                let uiImage = UIImage(data: imgFrom, size: CGSize(width: 224, height: 224))//UIImage(cgImage: cgImage)
                UIImageWriteToSavedPhotosAlbum(uiImage!, nil, nil, nil);
                res.append(TestFrame(id: UUID(), image: uiImage!, frameCount: count))
//                let data = uiImage.jpegData(compressionQuality: 100.0)
//                let filename = paths[0].appendingPathComponent("tflitemodeldata_\(count).png")
//                try data?.write(to: filename)
            } catch {
                fatalError("error writing image data to the file...  \(error)")
            }
            
//            print("😹Image \(count) DATA here: \n \(img?.copyBytes(to: .))")
            
            
            count = count + 1
            
        }
        return res
        
    }

    
}

/// This is for testing the action classifier purposes. Otherwise, I shouldn't use these functions 
extension TFActionClassifier {
    func tryInterpreter() {
        let actionClassifierInputHelper = TFActionClassifierInputs.shared
        do {
            if let interpreter = self.interpreter {
                try interpreter.allocateTensors()
            }
        } catch {
            print("❌ error allocating tensors \(error)")
        }
        
        for i in 0..<44 {
            do {
                if let input = try interpreter?.input(at: i) {
                    let dType: InputDataType
                    let data = actionClassifierInputHelper.getDataObjectFor(shape: input.shape.dimensions, of: input.dataType)!
                    try interpreter?.copy(data, toInputAt: i)
                } else {
                    print("❓something failed at index \(i)")
                }
                
//                if let input = try interpreter?.output(at: i) {
//                    print("🌟Interpreter data at output \(i) is of type \(input.dataType) and has data \(input.dataType) and has shape \(input.shape) and name \(input.name)\n")
//                } else {
//                    print("❓something failed at index \(i)")
//                }
                
            } catch {
                print("❌error accessing interpreter at index \(i) \n\(error)")
            }
            
        }
        do {
            try interpreter?.invoke()
            guard let outputData = try interpreter?.output(at: 10) else { return }
            let logits = [Float32](unsafeData: outputData.data)
//            print("😹 logits: \(logits)")
            let probabilities = softmax(logits!)
//            print("😹 probabilities: \(probabilities)")
            
        } catch {
            print("❌ error invoking interpreter \(error)")
        }
        
        
        for i in 0..<44 {
            do {
                if let output = try interpreter?.output(at: i) {
                    /// don't want to copy the logits, which is at index 10
                    if i == 10{
                        continue
                    } /// want to copy everything up until the 37th index for the outputs, so  i -> (i-1) up until (i-1) = 36. the image goes at 37.
                    else if (11...37).contains(i) {
                        try interpreter?.copy(output.data, toInputAt: i - 1)
                    } else {
                        try interpreter?.copy(output.data, toInputAt: i)
                    }
//                    print("🌟Interpreter data at input \(i) is of type \(input.dataType) and has data \(input.dataType) and has shape \(input.shape) and name \(input.name)")
                }
            } catch {
                print("❌error accessing interpreter at index \(i) \n\(error)")
            }
            
        }
        
        print("\n \n OKAYYYYYY")
        goThroughInputs()
        
        
    }
    
    func goThroughInputs() {
        for i in 0..<44 {
            do {
                if let input = try interpreter?.input(at: i) {
                    print("🌟Interpreter data at input \(i) is of type \(input.dataType) and has data \(input.dataType) and has shape \(input.shape) and name \(input.name)")
                }
//
                if let input = try interpreter?.output(at: i) {
                    print("🌟Interpreter data at output \(i) is of type \(input.dataType) and has data \(input.dataType) and has shape \(input.shape) and name \(input.name)\n")
                } else {
                    print("❓something failed at index \(i)")
                }
                
            } catch {
                print("❌error accessing interpreter at index \(i) \n\(error)")
            }
            
        }

        
    }
    
    
    
}


extension Array {
  /// Creates a new array from the bytes of the given unsafe data.
  ///
  /// - Warning: The array's `Element` type must be trivial in that it can be copied bit for bit
  ///     with no indirection or reference-counting operations; otherwise, copying the raw bytes in
  ///     the `unsafeData`'s buffer to a new array returns an unsafe copy.
  /// - Note: Returns `nil` if `unsafeData.count` is not a multiple of
  ///     `MemoryLayout<Element>.stride`.
  /// - Parameter unsafeData: The data containing the bytes to turn into an array.
  init?(unsafeData: Data) {
    guard unsafeData.count % MemoryLayout<Element>.stride == 0 else { return nil }
    #if swift(>=5.0)
    self = unsafeData.withUnsafeBytes { .init($0.bindMemory(to: Element.self)) }
    #else
    self = unsafeData.withUnsafeBytes {
      .init(UnsafeBufferPointer<Element>(
        start: $0,
        count: unsafeData.count / MemoryLayout<Element>.stride
      ))
    }
    #endif  // swift(>=5.0)
  }
}


extension UIImage {
    
//    func dataToFloat32Array(data: Data) -> [Float32] {
//        
//    }
    
    convenience init?(data: Data, size: CGSize) {
        let width = Int(size.width)
        let height = Int(size.height)
        
        let count = data.count / MemoryLayout<Float32>.stride
        let floats = data.withUnsafeBytes { (rawBufferPointer) -> [Float32] in
            let floatBufferPointer = rawBufferPointer.bindMemory(to: Float32.self)
             return Array(floatBufferPointer)
        }
        
//        let floats = data.toArray(type: Float32.self)
        
//        print(array)
        

        let bufferCapacity = width * height * 4
        let unsafePointer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferCapacity)
        let unsafeBuffer = UnsafeMutableBufferPointer<UInt8>(
            start: unsafePointer,
            count: bufferCapacity)
        defer {
            unsafePointer.deallocate()
        }

        for x in 0..<width {
            for y in 0..<height {
                let floatIndex = (y * width + x) * 3
                let index = (y * width + x) * 4
                let red = UInt8(floats[floatIndex] * 255)
                let green = UInt8(floats[floatIndex + 1] * 255)
                let blue = UInt8(floats[floatIndex + 2] * 255)

                unsafeBuffer[index] = red
                unsafeBuffer[index + 1] = green
                unsafeBuffer[index + 2] = blue
                unsafeBuffer[index + 3] = 0
            }
        }

        let outData = Data(buffer: unsafeBuffer)

        // Construct image from output tensor data
        let alphaInfo = CGImageAlphaInfo.noneSkipLast
        let bitmapInfo = CGBitmapInfo(rawValue: alphaInfo.rawValue)
            .union(.byteOrder32Big)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard
            let imageDataProvider = CGDataProvider(data: outData as CFData),
            let cgImage = CGImage(
                width: width,
                height: height,
                bitsPerComponent: 8,
                bitsPerPixel: 32,
                bytesPerRow: MemoryLayout<UInt8>.size * 4 * Int(size.width),
                space: colorSpace,
                bitmapInfo: bitmapInfo,
                provider: imageDataProvider,
                decode: nil,
                shouldInterpolate: false,
                intent: .defaultIntent
            )
        else {
            return nil
        }
        self.init(cgImage: cgImage)
    }
}
