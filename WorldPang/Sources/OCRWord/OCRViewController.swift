//
//  OCRViewController.swift
//  WorldPang
//
//  Created by 권민재 on 2023/10/17.
//

import UIKit
import Vision
import VisionKit
import RxSwift
import RxCocoa
import NaturalLanguage
import AVFoundation

class OCRViewController: BaseViewController {
    
    private lazy var captureDevice = AVCaptureDevice.default(for: .video)
    private var session: AVCaptureSession?
    private var output = AVCapturePhotoOutput()
    private var photoSetting: AVCapturePhotoSettings?
    
    let picker = UIImagePickerController() 
    
    private let disposeBag = DisposeBag()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainYellow

        // Do any additional setup after loading the view.
    }
    
    override func setupView() {
        view.backgroundColor = .mainYellow
        view.addSubview(titleLabel)
        
    }
    
    override func setupLayout() {
        
    }
    
    override func bindRX() {
        
        recognitionButton.rx.tap
            .subscribe(onDisposed:  { [weak self] in
                self?.setupAuthAlert()
            })
            .disposed(by: disposeBag)
        
    }
    
    func setupAuthAlert() {
        if let appName = Bundle.main.infoDictionary!["CFBundleName"] as? String {
            let alert = UIAlertController(title: "설정", message: "\(appName)", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            let confirmAction = UIAlertAction(title: "확인", style: .default) { action in
            }
            
            alert.addAction(cancelAction)
            alert.addAction(confirmAction)
            self.present(alert, animated: true)
        } else {
             
        }
    }
    

    func setupCamera() {
        guard let captureDevice = captureDevice else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session = AVCaptureSession()
            session?.sessionPreset = .photo
            session?.addInput(input)
            session?.addOutput(output)
        } catch {
            print(error)
        }
    }
    
    private func recognizeText(_ image: UIImage?) {
        guard let cgImage = image?.cgImage else { return }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNDetectTextRectanglesRequest { request, error in
            guard let observation = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                return
            }
            
            let resultText = observation.compactMap({
                $0.topCandidates(1).first?.string
            }).joined(separator: ", ")
            
        }
    }
    
    
    
    
    
    //MARK: UI
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Text Recognition"
        return label
    }()

    lazy var recognitionButton: UIButton = {
        let button = UIButton()
        button.setTitle("인식하기", for: .normal)
        button.backgroundColor = .mainYellow
        return button
    }()
    

    

}
extension OCRViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}
