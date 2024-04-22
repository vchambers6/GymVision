//
//  TFActionClassifier+Inputs.swift
//  GymVision
//
//  Created by Vanessa Chambers on 4/19/24.
//

import TensorFlowLite
import CoreML

struct TFLiteClassifierData {
    var inputName: String?
    var outputName: String?
    var shape: [Int]
    var inputDataType: InputDataType
}

enum InputDataType {
    case int32, float32
}

class TFActionClassifierInputs {
    static let shared = TFActionClassifierInputs()
    private var outputToInputMap : [Int: Int] = [
        1:1,
        2:2,
        3:3,
        4:4,
        5:5,
        6:6,
        7:7,
        8:8,
        9:9,
        11:10,
        12:11,
        13:12,
        14:13,
        15:14,
        16:15,
        17:16
        
    ]
    
    private let interpreter: Interpreter
    
    init() {
        let model = FileInfo(name: "model", extension: "tflite")
        guard let modelPath = Bundle.main.path(
            forResource: model.name,
            ofType: model.extension
        ) else {
            fatalError("model path for model \(model.name) does not exist")
        }
        
        var options = Interpreter.Options()
        options.threadCount = 3
        
        do {
            self.interpreter = try Interpreter(modelPath: modelPath, options: options)
            try self.interpreter.allocateTensors()
            
            // Initialize input
            for i in 0..<44 {
                do {
                    let input = try self.interpreter.input(at: i)
                    let data = self.getDataObjectFor(shape: input.shape.dimensions, of: input.dataType)!
                    try self.interpreter.copy(data, toInputAt: i)
                    
                } catch {
                    print("❌error accessing interpreter input at index \(i) \n\(error)")
                    fatalError()
                }
                
            }
        } catch {
            print("error initializing TFLite interpreter \(error)")
            fatalError()
        }
    }
    
    func getInterpreter() -> Interpreter {
        return self.interpreter
    }
    
    
    func getDataObjectFor(shape: [Int], of dataType: Tensor.DataType) -> Data? {
//        guard let shape = self.inputDetails[index]?.shape else { return nil}
//        guard let dataType = self.inputDetails[index]?.inputDataType else { return nil}
        let totalElements = shape.reduce(1, *)
        let data: Data
        switch dataType {
        case .int32:
            let zerosArray = [Int32](repeating: 0, count: totalElements)
            data = Data(bytes: zerosArray, count: totalElements * MemoryLayout<Int32>.size)
        case .float32:
            let zerosArray = [Float32](repeating: 0, count: totalElements)
            data = Data(bytes: zerosArray, count: totalElements * MemoryLayout<Float32>.size)
        default:
            let zerosArray = [Int32](repeating: 0, count: totalElements)
            data = Data(bytes: zerosArray, count: totalElements * MemoryLayout<Float32>.size)
        }
        return data
    }
}
