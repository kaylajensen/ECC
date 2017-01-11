//
//  LoginViewController.swift
//  OldeTowne
//
//  Created by Kayla Jensen on 9/22/16.
//  Copyright © 2016 kaylajensencoding. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore

class LoginViewController: UIViewController {
    
    let inputContainer : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    let logoImage : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "myecclogo")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let emailTextField : UITextField = {
        let email = UITextField()
        email.placeholder = "Email"
        email.textColor = UIColor.white
        email.translatesAutoresizingMaskIntoConstraints = false
        email.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightThin)
        email.autocapitalizationType = .none
        return email
    }()
    
    let passwordTextField : UITextField = {
        let email = UITextField()
        email.placeholder = "Password"
        email.textColor = UIColor.white
        email.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightThin)
        email.translatesAutoresizingMaskIntoConstraints = false
        email.isSecureTextEntry = true
        return email
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var adminGuestLoginSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Admin","Guest"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleAdminGuestChange), for: .valueChanged)
        return sc
    }()
    
    lazy var loginButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.setTitle("Enter", for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleAdminGuestLogin), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGradientBackground()
        
        view.addSubview(inputContainer)
        view.addSubview(loginButton)
        view.addSubview(logoImage)
        view.addSubview(adminGuestLoginSegmentedControl)
        
        // default view is for the guest to login
        passwordTextField.isHidden = true
        emailTextField.isHidden = true
        seperatorView.isHidden = true
        
        setupLogoView()
        setupSegmentedControl()
        setupInputsView()
        setupLoginButton()
        
    }
    
    func handleAdminGuestChange() {
        if (adminGuestLoginSegmentedControl.selectedSegmentIndex == 0) {
            let title = "Login"
            loginButton.setTitle(title, for: UIControlState())
            passwordTextField.isHidden = false
            emailTextField.isHidden = false
            seperatorView.isHidden = false
        } else {
            let title = "Enter"
            loginButton.setTitle(title, for: UIControlState())
            passwordTextField.isHidden = true
            emailTextField.isHidden = true
            seperatorView.isHidden = true
        }
    }
    
    func handleAdminGuestLogin() {
        if adminGuestLoginSegmentedControl.selectedSegmentIndex == 0 {
            handleAdminLogin()
        } else {
            //handle guest log in
            let email = "guest@gmail.com"
            let password = "guest16"
            
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error != nil {
                    print(error!)
                    return
                }
                //successfully logged in admin
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    func handleAdminLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            
            if let auth = FIRAuth.auth() {
                auth.addStateDidChangeListener() { auth, user in
                    if user != nil {
                    }
                }
            }
            //successfully logged in admin
            print("successful admin login")
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
    }
    
}


// Views setup
extension LoginViewController {
    func setupLogoView() {
        logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImage.topAnchor.constraint(equalTo: view.topAnchor,constant: 55).isActive = true
        logoImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
        logoImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func setupInputsView() {
        inputContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainer.topAnchor.constraint(equalTo: adminGuestLoginSegmentedControl.bottomAnchor).isActive = true
        inputContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
        inputContainer.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        inputContainer.addSubview(emailTextField)
        inputContainer.addSubview(seperatorView)
        inputContainer.addSubview(passwordTextField)
        
        emailTextField.leftAnchor.constraint(equalTo: inputContainer.leftAnchor,constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: inputContainer.topAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainer.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputContainer.heightAnchor,multiplier: 1/2).isActive = true
        
        seperatorView.leftAnchor.constraint(equalTo: inputContainer.leftAnchor).isActive = true
        seperatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        seperatorView.widthAnchor.constraint(equalTo: inputContainer.widthAnchor).isActive = true
        seperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: seperatorView.bottomAnchor).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: inputContainer.leftAnchor,constant: 12).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputContainer.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: inputContainer.heightAnchor,multiplier: 1/2).isActive = true
    }
    
    func setupLoginButton() {
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: inputContainer.bottomAnchor).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupSegmentedControl() {
        adminGuestLoginSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        adminGuestLoginSegmentedControl.topAnchor.constraint(equalTo: logoImage.bottomAnchor,constant: 35).isActive = true
        adminGuestLoginSegmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
        adminGuestLoginSegmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setGradientBackground() {
        let colorTop = UIColor.white.cgColor
        let colorBottom = LIGHT_BLUE.cgColor
        
        //let colorBottom = UIColor.lightGray.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.addSublayer(gradientLayer)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
