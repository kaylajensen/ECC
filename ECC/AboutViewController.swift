//
//  AboutViewController.swift
//  ECC
//
//  Created by Kayla Jensen on 12/21/16.
//  Copyright © 2016 kaylajensencoding. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import AudioToolbox
import FirebaseCore

class AboutViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setupViews()
    }

    func setupNavigation() {
        view.backgroundColor = UIColor.white
        
        self.tabBarItem = UITabBarItem(title: "About", image: UIImage(named: "shop_outline"), selectedImage: UIImage(named: "shop_filled"))
        self.tabBarController?.tabBar.tintColor = UIColor.black
        self.tabBarController?.tabBar.backgroundImage = UIImage.imageWithColor(color: UIColor.black.withAlphaComponent(OPACITY))
        self.tabBarController?.tabBar.shadowImage = UIImage()
        self.tabBarController?.tabBar.isTranslucent = true
        self.tabBarController?.tabBar.isHidden = false
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: UIColor.clear), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "logout"), style: .done, target: self, action: #selector(logUserOut))
    }
    
    func setupViews() {
        let image = UIImageView(image: UIImage(named: "celest2"))
        image.frame = self.view.frame
        image.contentMode = .scaleAspectFill
        view.addSubview(image)
        
        let overlay = UIView()
        overlay.backgroundColor = LIGHT_BLUE.withAlphaComponent(0.6)
        overlay.frame = self.view.frame
        image.addSubview(overlay)
        
        view.addSubview(logoView)
        logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoView.topAnchor.constraint(equalTo: view.topAnchor,constant:20).isActive = true
        logoView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        logoView.heightAnchor.constraint(equalToConstant: 175).isActive = true
        
        view.addSubview(container)
        container.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        container.topAnchor.constraint(equalTo: logoView.bottomAnchor,constant:35).isActive = true
        
        print("screen Height : \(screenHeight)")
        if screenHeight <= 667 {
            container.widthAnchor.constraint(equalTo: view.widthAnchor,constant:-10).isActive = true
            container.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.55).isActive = true
        } else {
            container.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60).isActive = true
            container.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7).isActive = true
        }
        
        view.addSubview(textContainer)
        textContainer.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        textContainer.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        textContainer.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        
        if isiPad() {
            textContainer.heightAnchor.constraint(equalToConstant: 300).isActive = true
        } else {
            textContainer.heightAnchor.constraint(equalTo: container.heightAnchor).isActive = true
        }
        
        setupLabels()
    }
    
    func setupLabels() {
        textContainer.addSubview(aboutLabel)
        aboutLabel.topAnchor.constraint(equalTo: textContainer.topAnchor).isActive = true
        aboutLabel.leftAnchor.constraint(equalTo: textContainer.leftAnchor).isActive = true
        aboutLabel.widthAnchor.constraint(equalTo: textContainer.widthAnchor).isActive = true
        aboutLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        let taglineLabel = UILabel()
        taglineLabel.text = tagLineString
        taglineLabel.textColor = UIColor.black
        taglineLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
        taglineLabel.textAlignment = .center
        taglineLabel.lineBreakMode = .byWordWrapping
        taglineLabel.numberOfLines = 0
        taglineLabel.translatesAutoresizingMaskIntoConstraints = false
        
        textContainer.addSubview(taglineLabel)
        taglineLabel.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor,constant:10).isActive = true
        taglineLabel.leftAnchor.constraint(equalTo: textContainer.leftAnchor).isActive = true
        taglineLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        taglineLabel.widthAnchor.constraint(equalTo: textContainer.widthAnchor).isActive = true
        
        let infoString = UILabel()
        infoString.text = phoneInfoString
        infoString.textColor = UIColor.black
        infoString.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
        infoString.lineBreakMode = .byWordWrapping
        infoString.numberOfLines = 0
        infoString.textAlignment = .center
        infoString.isUserInteractionEnabled = true
        infoString.translatesAutoresizingMaskIntoConstraints = false
        let phoneTap1 = UITapGestureRecognizer(target: self, action: #selector(phoneTapped))
        infoString.addGestureRecognizer(phoneTap1)
        
        textContainer.addSubview(infoString)
        infoString.topAnchor.constraint(equalTo: taglineLabel.bottomAnchor).isActive = true
        infoString.leftAnchor.constraint(equalTo: textContainer.leftAnchor).isActive = true
        if isiPad() {
            infoString.heightAnchor.constraint(equalToConstant: 15).isActive = true
        } else {
            infoString.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
        infoString.widthAnchor.constraint(equalTo: textContainer.widthAnchor).isActive = true
        
        textContainer.addSubview(hoursLabel)
        hoursLabel.topAnchor.constraint(equalTo: infoString.bottomAnchor,constant:30).isActive = true
        hoursLabel.leftAnchor.constraint(equalTo: aboutLabel.leftAnchor).isActive = true
        hoursLabel.widthAnchor.constraint(equalTo: aboutLabel.widthAnchor).isActive = true
        hoursLabel.heightAnchor.constraint(equalTo: aboutLabel.heightAnchor).isActive = true
        
        let mondayHours = UILabel()
        mondayHours.text = monFriHours
        mondayHours.textColor = UIColor.black
        mondayHours.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
        mondayHours.textAlignment = .center
        mondayHours.translatesAutoresizingMaskIntoConstraints = false
        
        textContainer.addSubview(mondayHours)
        mondayHours.topAnchor.constraint(equalTo: hoursLabel.bottomAnchor,constant:10).isActive = true
        mondayHours.leftAnchor.constraint(equalTo: textContainer.leftAnchor).isActive = true
        mondayHours.heightAnchor.constraint(equalToConstant: 18).isActive = true
        mondayHours.widthAnchor.constraint(equalTo: textContainer.widthAnchor).isActive = true
        
        let saturdayHours = UILabel()
        saturdayHours.text = satHours
        saturdayHours.textColor = UIColor.black
        saturdayHours.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
        saturdayHours.textAlignment = .center
        saturdayHours.translatesAutoresizingMaskIntoConstraints = false
        
        textContainer.addSubview(saturdayHours)
        saturdayHours.topAnchor.constraint(equalTo: mondayHours.bottomAnchor,constant:5).isActive = true
        saturdayHours.leftAnchor.constraint(equalTo: mondayHours.leftAnchor).isActive = true
        saturdayHours.heightAnchor.constraint(equalTo: mondayHours.heightAnchor).isActive = true
        saturdayHours.widthAnchor.constraint(equalTo: mondayHours.widthAnchor).isActive = true
        
        let sundayHours = UILabel()
        sundayHours.text = sunHours
        sundayHours.textColor = UIColor.black
        sundayHours.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
        sundayHours.textAlignment = .center
        sundayHours.translatesAutoresizingMaskIntoConstraints = false
        
        textContainer.addSubview(sundayHours)
        sundayHours.topAnchor.constraint(equalTo: saturdayHours.bottomAnchor,constant:5).isActive = true
        sundayHours.leftAnchor.constraint(equalTo: saturdayHours.leftAnchor).isActive = true
        sundayHours.heightAnchor.constraint(equalTo: saturdayHours.heightAnchor).isActive = true
        sundayHours.widthAnchor.constraint(equalTo: saturdayHours.widthAnchor).isActive = true

        textContainer.addSubview(contactLabel)
        contactLabel.topAnchor.constraint(equalTo: sundayHours.bottomAnchor,constant:30).isActive = true
        contactLabel.leftAnchor.constraint(equalTo: aboutLabel.leftAnchor).isActive = true
        contactLabel.widthAnchor.constraint(equalTo: aboutLabel.widthAnchor).isActive = true
        contactLabel.heightAnchor.constraint(equalTo: aboutLabel.heightAnchor).isActive = true
        
        let addressLabel = UILabel()
        addressLabel.text = "Ella's Celestial Cakes\n" + addressString
        addressLabel.textColor = UIColor.black
        addressLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
        addressLabel.textAlignment = .center
        addressLabel.numberOfLines = 0
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.isUserInteractionEnabled = true
        let mapGesture = UITapGestureRecognizer(target: self, action: #selector(openMaps))
        addressLabel.addGestureRecognizer(mapGesture)
        
        textContainer.addSubview(addressLabel)
        addressLabel.topAnchor.constraint(equalTo: contactLabel.bottomAnchor,constant:10).isActive = true
        addressLabel.leftAnchor.constraint(equalTo: textContainer.leftAnchor).isActive = true
        addressLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        addressLabel.widthAnchor.constraint(equalTo: textContainer.widthAnchor).isActive = true
        
        let emailLabel = UILabel()
        emailLabel.text = emailString
        emailLabel.textColor = UIColor.black
        emailLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
        emailLabel.textAlignment = .center
        emailLabel.numberOfLines = 0
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.isUserInteractionEnabled = true
        let emailTap = UITapGestureRecognizer(target: self, action: #selector(openEmail))
        emailLabel.addGestureRecognizer(emailTap)
        
        textContainer.addSubview(emailLabel)
        emailLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor,constant:5).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: textContainer.leftAnchor).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        emailLabel.widthAnchor.constraint(equalTo: textContainer.widthAnchor).isActive = true
        
        let phoneLabel = UILabel()
        phoneLabel.text = phoneString
        phoneLabel.textColor = UIColor.black
        phoneLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
        phoneLabel.textAlignment = .center
        phoneLabel.numberOfLines = 0
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneLabel.isUserInteractionEnabled = true
        let phoneTap2 = UITapGestureRecognizer(target: self, action: #selector(phoneTapped))
        phoneLabel.addGestureRecognizer(phoneTap2)
        
        textContainer.addSubview(phoneLabel)
        phoneLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor,constant:5).isActive = true
        phoneLabel.leftAnchor.constraint(equalTo: textContainer.leftAnchor).isActive = true
        phoneLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        phoneLabel.widthAnchor.constraint(equalTo: textContainer.widthAnchor).isActive = true
        
        view.addSubview(infoButton)
        infoButton.rightAnchor.constraint(equalTo: phoneLabel.rightAnchor).isActive = true
        infoButton.bottomAnchor.constraint(equalTo: phoneLabel.bottomAnchor).isActive = true
        infoButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        infoButton.widthAnchor.constraint(equalToConstant: 15).isActive = true
        
    }
    
    func phoneTapped() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        let number = phoneString
        let url = URL(string: "telprompt://\(number)")
        if UIApplication.shared.canOpenURL(url!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url!)
            }
        }
    }
    
    func infoButtonPressed() {
        let infoViewController = InfoViewController()
        self.navigationController?.pushViewController(infoViewController, animated: true)
    }
    
    func openEmail() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        let email = "mailto:@\(emailString)"
        let url = URL(string: email)
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(url!)
        }
    }
    
    func openMaps() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        let url = URL(string: "http://maps.apple.com/?q=Ella's+Celestial+Cakes&sll=\(bakeryLat),\(bakeryLon)")
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(url!)
        }
    }
    
    func logUserOut() {
        NetworkManager.shared.logUserOut()
        
        let loginController = LoginViewController()
        self.tabBarController?.selectedIndex = 0
        present(loginController, animated: false, completion: nil)
    }
    
    var logoView : UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "myecclogo")
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.6
        view.layer.shadowRadius = 15.0
        view.layer.masksToBounds =  false
        return view
    }()
    
    lazy var infoButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let origImage = UIImage(named: "info_outline");
        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = LIGHT_BLUE
        button.addTarget(self, action: #selector(infoButtonPressed), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    var container : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = false
        return view
    }()

    let textContainer : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    var aboutLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ABOUT"
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightHeavy)
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }()
    
    var hoursLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "HOURS"
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightHeavy)
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }()
    
    var contactLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "CONTACT"
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightHeavy)
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }()
    
    

}
