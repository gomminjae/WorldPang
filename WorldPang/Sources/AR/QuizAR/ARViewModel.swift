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
    

}

class ARViewModel: ARViewModelBindable {
    
    
    var selectedCategory: BehaviorSubject<ARCategory> = BehaviorSubject(value: .normal)
    var predictedObjectName: BehaviorSubject<String> = BehaviorSubject(value: "확인")
    
    private var visionRequests = [VNRequest]()
    private let disposeBag = DisposeBag()
    
    
    init() {
        bindToSelectedCategory()
    }
    
    
    
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
        do {
            let completionHandler: VNRequestCompletionHandler?
            
            switch try selectedCategory.value() {
            case .normal:
                completionHandler = classificationCompleteHandler
            case .fruits:
                completionHandler = classificationFruitsCompleteHandler
            default:
                print("Not supported")
                return
            }
            
            let request = VNCoreMLRequest(model: model, completionHandler: completionHandler)
            request.imageCropAndScaleOption = .centerCrop
            
            visionRequests = [request]
        } catch {
            print("Error creating VNCoreMLRequest: \(error)")
        }
    }
    func updateImageForCoreML(sceneView: ARSCNView) {
        guard let pixelBuff = sceneView.session.currentFrame?.capturedImage else { return }
        let ciImage = CIImage(cvImageBuffer: pixelBuff)
        let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        do {
            try imageRequestHandler.perform(visionRequests)
        } catch {
            print(error)
        }
    }
    
    func aimViewTapped(sceneView: ARSCNView) {
        updateImageForCoreML(sceneView: sceneView)
        //print("aimView Tapped")
        
        let screenCenter: CGPoint = CGPoint(x: sceneView.bounds.midX, y: sceneView.bounds.midY)
        
        let arHitTestResults: [ARHitTestResult] = sceneView.hitTest(screenCenter, types: [.featurePoint])
        
        if let closestResult = arHitTestResults.first {
            // Get Coordinates of HitTest
            let transform: matrix_float4x4 = closestResult.worldTransform
            let worldCoord: SCNVector3 = SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
            
            

            
            if let objectName = try? predictedObjectName.value() {
                print("Object Name:", objectName)
                let node: SCNNode = createNewBubbleParentNode(objectName)
                node.position = worldCoord
                sceneView.scene.rootNode.addChildNode(node)
            } else {
                print("No predicted object name")
            }
        }
        
    }
    
    func createNewBubbleParentNode(_ text : String) -> SCNNode {
       
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        
        let bubble = SCNText(string: text, extrusionDepth: CGFloat(0.01))
        var font = UIFont(name: "Futura", size: 0.15)
        font = font?.withTraits(traits: .traitBold)
        bubble.font = font
        bubble.firstMaterial?.diffuse.contents = UIColor.green
        bubble.firstMaterial?.specular.contents = UIColor.white
        bubble.firstMaterial?.isDoubleSided = true
        bubble.chamferRadius = CGFloat(0.1)
        
        let (minBound, maxBound) = bubble.boundingBox
        let bubbleNode = SCNNode(geometry: bubble)
        bubbleNode.pivot = SCNMatrix4MakeTranslation( (maxBound.x - minBound.x)/2, minBound.y, 0.1/2)
        bubbleNode.scale = SCNVector3Make(0.2, 0.2, 0.2)
        

        let bubbleNodeParent = SCNNode()
        bubbleNodeParent.addChildNode(bubbleNode)
        bubbleNodeParent.constraints = [billboardConstraint]
        
        return bubbleNodeParent
    }
    func classificationCompleteHandler(request: VNRequest, error: Error?) {
    
        if error != nil {
            print("Error: " + (error?.localizedDescription)!)
            return
        }
        guard let observations = request.results else {
            print("No results")
            return
        }
        
    
        let classifications = observations[0...1] // top 2 results
            .compactMap({ $0 as? VNClassificationObservation })
            .map({ "\($0.identifier) \(String(format:"- %.2f", $0.confidence))" })
            .joined(separator: "\n")
        
        let objectName: String = classifications.components(separatedBy: "-")[0].components(separatedBy: ",")[0]
        
        predictedObjectName.onNext(objectName)
    }
    
    func classificationFruitsCompleteHandler(
        request: VNRequest,
        error: Error?) {

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
        
        let objectNameComponents = topClassification.identifier.components(separatedBy: ",")
        let objectName = objectNameComponents[0]
        
        let confidenceString = String(format: "%.2f", topClassification.confidence * 100)
        print("Classification: \(objectName) Confidence: \(confidenceString)%")
        
        predictedObjectName.onNext(objectName)
    }

    
    
    
}
