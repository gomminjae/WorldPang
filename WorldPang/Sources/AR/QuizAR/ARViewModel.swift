//
//  ARViewModel.swift
//  WorldPang
//
//  Created by 권민재 on 5/3/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import ARKit
import SceneKit
import CoreML


enum RecognitionError: Error {
    case unableToInitializeCoreMLModel
    case resultIsEmpty
    case lowConfidence
    case yoloOutputFormatMismatch
}

enum ARCategory {
    case normal
    case space
    case fruits
}


protocol ARViewModelBindable {
    
    var selectedCategory: BehaviorSubject<ARCategory> { get }
    var predictedObjectName: BehaviorSubject<String> { get }
    
    func setupBindings(sceneTap: Observable<Void>, exitTap: Observable<Void>, startTap: Observable<Void>, sceneView: ARSCNView, storyboard: UIStoryboard?, viewController: UIViewController)

}

class ARViewModel: ARViewModelBindable {
    
    
    var selectedCategory: BehaviorSubject<ARCategory> = BehaviorSubject(value: .normal)
    var predictedObjectName: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    private var visionRequests = [VNRequest]()
    private let disposeBag = DisposeBag()
    
    
    
    private func bindToSelectedCategory() {
        selectedCategory
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] category in
                self?.updateMLModel(for: category)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateMLModel(for category: ARCategory) {
        switch category {
        case .normal:
            guard let model = try? VNCoreMLModel(for: MobileNetV2().model) else { fatalError() }
            updateVisionRequests(with: model)
        case .fruits:
            guard let model = try? VNCoreMLModel(for: fruits().model) else { fatalError() }
            updateVisionRequests(with: model)
        default:
            print("Not supported")
        }
    }
    private func updateVisionRequests(with model: VNCoreMLModel) {
        let request = VNCoreMLRequest(model: model, completionHandler: classificationCompleteHandler)
        request.imageCropAndScaleOption = .centerCrop
        visionRequests = [request]
    }
    
    func updateImageForCoreML(with pixelBuff: CVPixelBuffer?, sceneView: ARSCNView) {
        guard let pixelBuff = pixelBuff else { return }
        let ciImage = CIImage(cvImageBuffer: pixelBuff)
        let imageRequestHander = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        do {
            try imageRequestHander.perform(self.visionRequests)
        } catch {
            print(error)
        }
    }
    func classificationCompleteHandler(request: VNRequest, error: Error?) {
        // Catch Errors
        if error != nil {
            print("Error: " + (error?.localizedDescription)!)
            return
        }
        guard let observations = request.results else {
            print("No results")
            return
        }
        
        // Get Classifications
        let classifications = observations[0...1] // top 2 results
            .compactMap({ $0 as? VNClassificationObservation })
            .map({ "\($0.identifier) \(String(format:"- %.2f", $0.confidence))" })
            .joined(separator: "\n")
        
        let objectName: String = classifications.components(separatedBy: "-")[0].components(separatedBy: ",")[0]
        
        predictedObjectName.onNext(objectName)
    }
    
    func classificationFruitsCompleteHandler(request: VNRequest, error: Error?) {
        // Catch Errors
        if let error = error {
            print("Error: \(error.localizedDescription)")
            return
        }
        
        guard let observations = request.results else {
            print("No results")
            return
        }
        
        // Get Classifications
        let topClassifications = observations
            .compactMap { $0 as? VNClassificationObservation }
            .prefix(1) // top result
        
        guard let topClassification = topClassifications.first else {
            print("No classifications found")
            return
        }
        
        // Extract information from the top classification
        let objectNameComponents = topClassification.identifier.components(separatedBy: ",")
        let objectName = objectNameComponents[0]
        
        // Print or use the information as needed
        let confidenceString = String(format: "%.2f", topClassification.confidence * 100)
        print("Classification: \(objectName) Confidence: \(confidenceString)%")
        
        // Pass the predicted object name to the appropriate method or property
        predictedObjectName.onNext(objectName)
    }

    
    
    
    func setupBindings(sceneTap: RxSwift.Observable<Void>, exitTap: Observable<Void>, startTap: RxSwift.Observable<Void>, sceneView: ARSCNView, storyboard: UIStoryboard?, viewController: UIViewController) {
        print("binding")
    }
    
    
    
}
