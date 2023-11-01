//
//  ObjectDetectionService.swift
//  WorldPang
//
//  Created by 권민재 on 2023/11/01.
//

import UIKit
import CoreML
import Vision
import SceneKit

enum RecognitionError: Error {
    case unablemodel
    case emptyResult
    case lowConfidence
}



class ObjectDetectionService {
    
    struct MLRequest {
        let pixelBuffer: CVPixelBuffer
    }
    
    struct MLResponse {
        let boundingBox: CGRect
        let classification: String
    }
    
    
    var mlModel = try! VNCoreMLModel(for: YOLOv3Tiny().model)
    
    lazy var coreMLRequest: VNCoreMLRequest = {
        return VNCoreMLRequest(model: mlModel,
                               completionHandler: self.coreMlRequestHandler)
    }()
    
    private var completion: ((Result<MLResponse, Error>) -> Void)?
    
    func detect(on request: MLRequest, completion: @escaping (Result<MLResponse, Error>) -> Void) {
        self.completion = completion
        
        let orientation = CGImagePropertyOrientation(rawValue:  UIDevice.current.exifOrientation) ?? .up
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: request.pixelBuffer,
                                                        orientation: orientation)
        
        do {
            try imageRequestHandler.perform([coreMLRequest])
        } catch {
            self.complete(.failure(error))
            return
        }
    }
    
    private func coreMlRequestHandler(_ request: VNRequest?, error: Error?) {
        if let error = error {
            complete(.failure(error))
            return
        }
        
        guard let request = request, let results = request.results as? [VNRecognizedObjectObservation] else {
            complete(.failure(RecognitionError.emptyResult))
            return
        }
        
        guard let result = results.first(where: { $0.confidence >= -0.01 }),
            let classification = result.labels.first else {
                complete(.failure(RecognitionError.lowConfidence))
                return
        }
        
        let response = MLResponse(boundingBox: result.boundingBox,
                                classification: classification.identifier)
        
        complete(.success(response))
    }
    
   private  func complete(_ result: Result<MLResponse, Error>) {
        DispatchQueue.main.async {
            self.completion?(result)
            self.completion = nil
        }
    }
}
