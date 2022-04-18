//
//  EnterEmailViewController.swift
//  LoginSampleApp
//
//  Created by Whyeon on 2022/04/18.
//

import UIKit
import FirebaseAuth

class EnterEmailViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.layer.cornerRadius = 30
        nextButton.isEnabled = false // 텍스트필드 작성전까지 비활성화
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.becomeFirstResponder() // 화면이 켜졌을때 커서가 이메일텍스트필드에 포커스
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Navigation Bar 보이기 이전 속성 가져가기때문에 따로 설정해주어야함.
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        //Firebase 이메일/비밀번호 인증 보냄
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        //신규 사용자 생성
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            // 같은 사용자 이메일과 패스워드를 넣어주면 17007 에러 코드를 발생함. 그대로 로그인하도록함.
            if let error = error {
                let code = (error as NSError).code
                switch code {
                case 17007: //이미 가입한 계정일 때
                    //로그인하기
                    self.loginUser(withEmail: email, password: password)
                default:
                    self.errorMessageLabel.text = error.localizedDescription // 그 외에 에러시 디스크립션 라벨에 출력
                }
            } else {
                self.showMainViewController() //아무 에러가 없을 경우 환영뷰로 이동
            }
        }
    }
    
    private func showMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        mainViewController.modalPresentationStyle = .fullScreen
        navigationController?.show(mainViewController, sender: nil)
    }
    
    // 로그인 하기
    private func loginUser(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            guard let self = self else { return }
            
            if let error = error {
                self.errorMessageLabel.text = error.localizedDescription //에러시 라벨에 출력
            } else {
                self.showMainViewController() // 에러가 없다면 메인뷰로 이동
            }
        }
    }
    
}

extension EnterEmailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { //키보드 return키를 누르면
        view.endEditing(true) //키보드 내림
        return false
    }
    
    //텍스트필드 수정이 완료되면 호출되는 함수
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isEmailEmpty = emailTextField.text == ""
        let isPasswordEmpty = passwordTextField.text == ""
        
        //두 텍스트필드가 빈것이 거짓일때 다음버튼 활성화
        nextButton.isEnabled = !isEmailEmpty && !isPasswordEmpty
    }
    
}
