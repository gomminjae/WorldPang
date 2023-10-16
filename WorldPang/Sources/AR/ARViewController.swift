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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        
        self.tabBarController?.tabBar.isHidden = true
        
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
            $0.top.equalTo(view.safeAreaLayoutGuide)
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
        
        print(classifications)
        
        
       
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
        
        
        
        
    }
    
//    
//    func createBubbleNode(_ text: String) -> SCNNode {
//        
//    }
//    
//    
    
    
    //MARK: UI
    let aimView: UIView = {
        let view = UIView()
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
