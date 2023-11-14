//
//  OCRViewController.swift
//  WorldPang
//
//  Created by 권민재 on 2023/10/17.
//

import UIKit
import Vision
import RxSwift
import RxCocoa
import NaturalLanguage

class OCRViewController: BaseViewController {
    
    
    let picker = UIImagePickerController() 
    
    @IBOutlet weak var actionButton: UIButton!
    
    @IBOutlet weak var selectedImageView: UIImageView!
    private let viewModel = OCRViewModel()
    private let disposeBag = DisposeBag()
    
    
    //Papago
    
    
    @IBOutlet weak var resultTextView: UITextView!
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
        
        actionButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.openImagePicker()
            })
            .disposed(by: disposeBag)
        
        viewModel.selectedImageSubject
            .subscribe(onNext: { [weak self] image in
                if let image = image {
                    self!.selectedImageView.image = image
                    self?.viewModel.recognizedText(on: image)
                } else { }
            })
            .disposed(by: disposeBag)
        
        viewModel.recognizedTextSubject
            .bind(to: resultTextView.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.recognizedTextSubject
            .subscribe(onNext: { [weak self] text in
                self?.viewModel.translation(with: text?.removeNewLines() ?? "")
                print(text?.removeNewLines())
            })
            .disposed(by: disposeBag)
    
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func openImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        let alertController = UIAlertController(title: "Select Image Source", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "카메라", style: .default) { [weak self] _ in
            imagePicker.sourceType = .camera
            self?.present(imagePicker, animated: true, completion: nil)
        }
        
        let albumAction = UIAlertAction(title: "앨범", style: .default) { [weak self] _ in
            self?.present(imagePicker, animated: true, completion: nil)
            imagePicker.sourceType = .photoLibrary
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(albumAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            viewModel.selectedImageSubject.onNext(editedImage)
        } else if let originalImage = info[.originalImage] as? UIImage {
            viewModel.selectedImageSubject.onNext(originalImage)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    // 이미지 선택이 취소되었을 때 호출되는 메서드
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        viewModel.selectedImageSubject.onNext(nil)
        picker.dismiss(animated: true, completion: nil)
    }
    
}
