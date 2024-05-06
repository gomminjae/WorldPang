import UIKit
import SceneKit
import ARKit
import Vision
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

class ARViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    private let disposeBag = DisposeBag()
    private let viewModel = ARViewModel()
    
    var visionRequests = [VNRequest]()
    let dispatchQueueForML = DispatchQueue(label: "mobilenet")
    let tapGesture = UITapGestureRecognizer()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        setupView()
        bindRX()
        
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
                guard let sceneView = self?.sceneView else { return }
                self?.viewModel.aimViewTapped(sceneView: sceneView)
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
        
        let currentScore = PointManager.shared.getPoints()
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
            
        }
    }
}

