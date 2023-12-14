import UIKit
import SceneKit
import ARKit
import Vision
import SnapKit
import RxSwift
import RxCocoa
import RxGesture


enum ARCategory {
    case normal
    case space
    case fruits
}

enum RecognitionError: Error {
    case unableToInitializeCoreMLModel
    case resultIsEmpty
    case lowConfidence
    case yoloOutputFormatMismatch
}

class ARViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    
    private let disposeBag = DisposeBag()
    private let arViewModel = ARViewModel()
    
    var selectedCategory: ARCategory = .normal {
        didSet {
            updateMLModel(for: selectedCategory)
        }
    }
    

    
    var visionRequests = [VNRequest]()
    let dispatchQueueForML = DispatchQueue(label: "mobilenet")
    
    var predictedObjectName = PublishSubject<String>()
    var objectName: String = "_"
    
    let tapGesture = UITapGestureRecognizer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        
        setupView()
        bindRX()
        
        updateMLModel(for: selectedCategory)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.vertical,.horizontal]
        
        sceneView.session.run(configuration)
       

    
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
        self.tabBarController?.tabBar.isHidden = false
        
        
    }
    
    private func setupView() {
        sceneView.addGestureRecognizer(tapGesture)
        
        
        
        sceneView.addSubview(aimView)
        sceneView.addSubview(toolBox)
        
        toolBox.addArrangedSubview(exitButton)
        toolBox.addArrangedSubview(startButton)
        
       
       
        
        aimView.snp.makeConstraints {
            $0.centerX.equalTo(sceneView)
            $0.centerY.equalTo(sceneView)
            $0.width.equalTo(250)
            $0.height.equalTo(250)
        }
        
        toolBox.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(sceneView)
            $0.width.equalTo(100)
            $0.height.equalTo(200)
            
        }
        
    }
    
    private func bindRX() {
        
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
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                //self?.dismiss(animated: true)
                self?.showResultView()
            })
            .disposed(by: disposeBag)
        
        startButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.aimView.isHidden = true
                self?.changeAllNode()
            })
            .disposed(by: disposeBag)
        
        tapGesture.rx.event
            .subscribe(onNext: { [weak self] gesture in
                guard let self = self else { return }
                
                let location = gesture.location(in: self.sceneView)
                let hitResult = self.sceneView.hitTest(location, options: nil)
                
                guard let hitedNode = hitResult.first?.node else {
                    print("not exist node")
                    return
                }
                
                if let quizVC = self.storyboard?.instantiateViewController(withIdentifier: "QuizVC") as? QuizViewController {
                    if let textGeometry = hitedNode.geometry as? SCNText,
                       let textName = self.getTextNodeData(for: hitedNode)  {
                        print(textName)
                        quizVC.textNodeString = textName
                        quizVC.selectedNode = hitedNode
                    }
                    self.present(quizVC, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        
    }
    
    private func updateMLModel(for category: ARCategory) {
        switch category {
        case .normal:
            guard let model = try? VNCoreMLModel(for: MobileNetV2().model) else { fatalError() }
            updateVisionRequests(with: model)
        case.fruits:
            guard let model = try? VNCoreMLModel(for: fruits().model) else { fatalError() }
            updateVisionRequests(with: model)
        default:
            print("없음")
        }
    }
    private func updateVisionRequests(with model: VNCoreMLModel) {
        
        if selectedCategory == .normal {
            let request = VNCoreMLRequest(model: model, completionHandler: classificationCompleteHandler)
            request.imageCropAndScaleOption = .centerCrop
            visionRequests = [request]
        } else if selectedCategory == .fruits {
            let request = VNCoreMLRequest(model: model, completionHandler: classificationFruitsCompleteHandler)
            request.imageCropAndScaleOption = .centerCrop
            visionRequests = [request]
        }
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
        
        updateImageForCoreML()
        
        
        let screenCenter: CGPoint = CGPoint(x: self.sceneView.bounds.midX, y: self.sceneView.bounds.midY)
        
        let arHitTestResults : [ARHitTestResult] = sceneView.hitTest(screenCenter, types: [.featurePoint])
        
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
    
    private func changeAllNode() {
        let allTextNodes = sceneView.scene.rootNode.childNodes(passingTest: { (node, _) in
            return node.geometry is SCNText
        })
        
        for textNode in allTextNodes {
            if let textGeometry = textNode.geometry as? SCNText {
                textGeometry.setValue(textGeometry.string, forKey: "name")
                textGeometry.string = "    ?"
            }
        }
    }
    
    private func getTextNodeData(for textNode: SCNNode) -> String? {
        if let textGeometry = textNode.geometry as? SCNText {
            return textGeometry.value(forKey: "name") as? String
        }
        
        return nil
    }
    
    private func showResultView() {
        let view = UIView()
        view.backgroundColor = .white
        
        let label = UILabel()
        label.textColor = .mainBlue
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        sceneView.addSubview(view)
        view.addSubview(label)
        
        view.layer.cornerRadius = 20 
        
        view.snp.makeConstraints {
            $0.centerX.equalTo(sceneView)
            $0.centerY.equalTo(sceneView)
            $0.width.equalTo(300)
            $0.height.equalTo(250)
        }
        
        label.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.centerY.equalTo(view)
        }
        
        var currentScore = PointManager.shared.getPoints()
        label.text = "총 획득한 포인트는 \(currentScore)입니다!"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            view.removeFromSuperview()
            self.dismiss(animated: true)
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
        stack.backgroundColor = .black
        stack.alpha = 0.4
        //stack.layer.borderColor = UIColor.orange.cgColor
        
        return stack
    }()
    
    
    let exitButton: UIButton = {
        let button = UIButton()
        button.setTitle("종료하기", for: .normal)
        button.titleLabel?.textColor = .black
        return button
    }()
    
    let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("시작하기", for: .normal)
        button.titleLabel?.textColor = .black 
        return button
    }()

    
    let userQuizStateView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.4
        return view
    }()
    
    let correntScoreLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 맞춘 퀴즈: 0"
        label.textColor = .white
        return label
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
extension Array where Element: Comparable {
    func argmax() -> Int? {
        guard let maxElement = self.max() else { return nil }
        return firstIndex(of: maxElement)
    }
}
