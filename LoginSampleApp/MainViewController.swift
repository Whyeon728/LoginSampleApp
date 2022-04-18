//
//  MainViewController.swift
//  LoginSampleApp
//
//  Created by Whyeon on 2022/04/19.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 팝 제스쳐 안되도록 설정
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.configureButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true //네비게이션바 숨김
        
        let email = Auth.auth().currentUser?.email ?? "고객" // 파이어베이스 인증에서 이메일을 읽어옴; 없으면 "고객"으로 표시
        self.welcomeLabel.text =
        """
        환영합니다.
        \(email)님.
        """


    }
    
    private func configureButton() {
        self.logoutButton.layer.borderWidth = 1
        self.logoutButton.layer.borderColor = UIColor.white.cgColor
        self.logoutButton.layer.cornerRadius = 30
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        
        //루트 뷰로 이동
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
