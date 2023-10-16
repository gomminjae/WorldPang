//
//  ARQuizViewController.swift
//  WorldPang
//
//  Created by 권민재 on 2023/10/16.
//

import UIKit
import RealityKit
import Vision
import SnapKit
import ARKit


class ARQuizViewController: BaseViewController {

    @IBOutlet weak var arView: ARView!
    
    var visionRequests = [VNRequest]()
    let dispatchQueueForML = DispatchQueue(label: "mobilenet")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMLModel()
        runCorML()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        arView.session.run(configuration)
        self.tabBarController?.tabBar.isHidden = true
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arView.session.pause()
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    
    
    override func setupView() {
        
    }
    
    override func setupLayout() {
        
    }
    override func bindRX() {
    }
    
    private func setupMLModel() {
        guard let model = try? VNCoreMLModel(for: MobileNetV2().model) else { fatalError() }
        
        let request = VNCoreMLRequest(model: model, completionHandler: classificationCompleteHandler)
        request.imageCropAndScaleOption = .centerCrop
        visionRequests = [request]
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
        
        print(classifications)
        
        
       
    }
    func runCorML() {
        dispatchQueueForML.async {
            self.updateImageForCoreML()
            
            self.runCorML()
        }
    }
    
    
    
    
    func updateImageForCoreML() {
        let pixelBuff: CVPixelBuffer? = (arView.session.currentFrame?.capturedImage)
        
        if pixelBuff == nil { return }
        
        let ciImage: CIImage = CIImage(cvImageBuffer: pixelBuff!)
        
        let imageRequestHander = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        do {
            try imageRequestHander.perform(self.visionRequests)
        } catch {
            print(error)
        }
    }
    
    
    
    
    

   
}
