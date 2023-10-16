import UIKit
import SceneKit
import ARKit
import Vision
import SnapKit
import RxSwift
import RxCocoa



class ARViewController: UIViewController {
    
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    private let disposeBag = DisposeBag()
    
    
    var visionRequests = [VNRequest]()
    let dispatchQueueForML = DispatchQueue(label: "mobilenet")
    
    var predictedObjectName = PublishSubject<String>()
    var objectName: String = "_"
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        
        
        setupView()
        bindRX()
        
        setupMLModel()
        
        runCorML()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        
        
        sceneView.session.run(configuration)
    
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
        self.tabBarController?.tabBar.isHidden = false
        
        
    }
    
    private func setupView() {
        sceneView.addSubview(aimView)
        sceneView.addSubview(toolBox)
        
        toolBox.addArrangedSubview(exitButton)
        
        aimView.snp.makeConstraints {
            $0.centerX.equalTo(sceneView)
            $0.centerY.equalTo(sceneView)
            $0.width.equalTo(100)
            $0.height.equalTo(100)
        }
        
        toolBox.snp.makeConstraints {
            $0.top.equalTo(view)
            $0.trailing.equalTo(sceneView)
            $0.width.equalTo(100)
            $0.height.equalTo(200)
            
        }
    }
    
    private func bindRX() {
        exitButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popToViewController(HomeViewController(), animated: true)
            })
            .disposed(by: disposeBag)
        
        aimView.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.aimViewTapped()
            })
            .disposed(by: disposeBag)
        
        predictedObjectName
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] objectName in
                self?.objectName = objectName
            })
            .disposed(by: disposeBag)
        
        exitButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.changeAllNode()
            })
            .disposed(by: disposeBag)
        
    }
    
    
    
    
    
    func runCorML() {
        dispatchQueueForML.async {
            self.updateImageForCoreML()
            
            self.runCorML()
        }
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
        
        let objectName: String = classifications.components(separatedBy: "-")[0].components(separatedBy: ",")[0]
        
        predictedObjectName.onNext(objectName)
        
       
    }
    
    func updateImageForCoreML() {
        let pixelBuff: CVPixelBuffer? = (sceneView.session.currentFrame?.capturedImage)
        
        if pixelBuff == nil { return }
        
        let ciImage: CIImage = CIImage(cvImageBuffer: pixelBuff!)
        
        let imageRequestHander = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        do {
            try imageRequestHander.perform(self.visionRequests)
        } catch {
            print(error)
        }
    }
    
    func aimViewTapped() {
        let screenCenter: CGPoint = CGPoint(x: self.sceneView.bounds.midX, y: self.sceneView.bounds.midY)
        
        let arHitTestResults : [ARHitTestResult] = sceneView.hitTest(screenCenter, types: [.featurePoint]) // Alternatively, we could use '.existingPlaneUsingExtent' for more grounded hit-test-points.
        
        if let closestResult = arHitTestResults.first {
            // Get Coordinates of HitTest
            let transform : matrix_float4x4 = closestResult.worldTransform
            let worldCoord : SCNVector3 = SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
            
            // Create 3D Text
            let node : SCNNode = createNewBubbleParentNode(objectName)
            sceneView.scene.rootNode.addChildNode(node)
            node.position = worldCoord
        }
        
        
    }
    
    
    
    func createNewBubbleParentNode(_ text : String) -> SCNNode {
        // Warning: Creating 3D Text is susceptible to crashing. To reduce chances of crashing; reduce number of polygons, letters, smoothness, etc.
        
        // TEXT BILLBOARD CONSTRAINT
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        
        // BUBBLE-TEXT
        let bubble = SCNText(string: text, extrusionDepth: CGFloat(0.01))
        var font = UIFont(name: "Futura", size: 0.15)
        font = font?.withTraits(traits: .traitBold)
        bubble.font = font
        bubble.firstMaterial?.diffuse.contents = UIColor.green
        bubble.firstMaterial?.specular.contents = UIColor.white
        bubble.firstMaterial?.isDoubleSided = true
        // bubble.flatness // setting this too low can cause crashes.
        bubble.chamferRadius = CGFloat(0.1)
        
        // BUBBLE NODE
        let (minBound, maxBound) = bubble.boundingBox
        let bubbleNode = SCNNode(geometry: bubble)
        // Centre Node - to Centre-Bottom point
        bubbleNode.pivot = SCNMatrix4MakeTranslation( (maxBound.x - minBound.x)/2, minBound.y, 0.1/2)
        // Reduce default text size
        bubbleNode.scale = SCNVector3Make(0.2, 0.2, 0.2)
        
        // CENTRE POINT NODE
        let sphere = SCNSphere(radius: 0.005)
        sphere.firstMaterial?.diffuse.contents = UIColor.subYellow
        let sphereNode = SCNNode(geometry: sphere)
        
        // BUBBLE PARENT NODE
        let bubbleNodeParent = SCNNode()
        bubbleNodeParent.addChildNode(bubbleNode)
        bubbleNodeParent.addChildNode(sphereNode)
        bubbleNodeParent.constraints = [billboardConstraint]
        
        return bubbleNodeParent
    }
    
    func changeAllNode() {
        let allTextNodes = sceneView.scene.rootNode.childNodes(passingTest: { (node, _) in
            return node.geometry is SCNText
        })
        
        for textNode in allTextNodes {
            if let textGeometry = textNode.geometry as? SCNText {
                textGeometry.string = "?"
            }
        }
                                                                               
        
    }
    
    
    
    //MARK: UI
    let aimView: UIButton = {
        let view = UIButton()
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.yellow.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    
    let stopButton: UIView = {
        let view = UIView()
        let button = UIButton(frame: view.bounds)
        button.backgroundColor = .clear
        return view
    }()
    
    let toolBox: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20.0
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.layer.borderWidth = 1
        stack.backgroundColor = .mainYellow
        stack.alpha = 0.5
        stack.layer.borderColor = UIColor.orange.cgColor
        
        return stack
    }()
    
    
    let exitButton: UIButton = {
        let button = UIButton()
        button.setTitle("종료하기", for: .normal)
        return button
    }()
    
    let userStateView: UIView = {
        let view = UIView()
        return view
    }()
    
    
    
    
}

extension ARViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            // Do any desired updates to SceneKit here.
        }
    }
}

extension UIFont {
    // Based on: https://stackoverflow.com/questions/4713236/how-do-i-set-bold-and-italic-on-uilabel-of-iphone-ipad
    func withTraits(traits:UIFontDescriptor.SymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
}
