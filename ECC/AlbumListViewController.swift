//
//  ViewController.swift
//  OTB
//
//  Created by Kayla Jensen on 12/19/16.
//  Copyright © 2016 kaylajensencoding. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore

class AlbumListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    override var prefersStatusBarHidden: Bool {
        return true
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
    
    var indicator = UIActivityIndicatorView()
    var tableView = UITableView()
    
    var albums = [Album]()
    var selectedTask : Album? = nil
    var albumReference : FIRDatabaseReference?
    var photosReference : FIRDatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !NetworkManager.shared.checkIfUserIsLoggedIn() {
            let loginController = LoginViewController()
            present(loginController, animated: false, completion: nil)
        }
        
        setupTabNavigationBar()
        setupTableView()
        setupIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        albumReference = FIRDatabase.database().reference().child("albums")
        photosReference = albumReference?.child("photos")
        
        albumReference?.queryOrdered(byChild: "name").observe(.value, with: { (snapshot) in
            print("getting .value")
            var items : [Album] = []
            for item in snapshot.children {
                let album = Album(snapshot: item as! FIRDataSnapshot)
                print("got an album : \(album.name)")
                items.append(album)
            }
            print("should print here")
            self.albums = items
            self.indicator.stopAnimating()
            
            if NetworkManager.shared.checkIfUserIsLoggedIn() {
                self.tableView.reloadData()
                self.checkForCreateAlbum()
            }
        })
        print("done with query")
    }
    
    func setupIndicator() {
        indicator.color = LIGHT_BLUE
        indicator.startAnimating()
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func checkForCreateAlbum() {
        if isAdmin {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "add_photo"), style: .plain, target: self, action: #selector(createNewAlbum))
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    func setupTabNavigationBar() {
        view.backgroundColor = UIColor.white
        self.tabBarItem = UITabBarItem(title: "Albums", image: UIImage(named: "gallery_outline"), selectedImage: UIImage(named: "gallery_filled"))
        self.tabBarController?.tabBar.tintColor = UIColor.white
        self.tabBarController?.tabBar.backgroundImage = UIImage.imageWithColor(color: UIColor.black.withAlphaComponent(OPACITY))
        self.tabBarController?.tabBar.shadowImage = UIImage()
        self.tabBarController?.tabBar.isTranslucent = true
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: UIColor.clear), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        if isAdmin {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "add_photo"), style: .plain, target: self, action: #selector(createNewAlbum))
        }
        
    }
    
    func createNewAlbum() {
        let attributedString = NSAttributedString(string: "Create New Album", attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 19, weight:UIFontWeightSemibold),
            NSForegroundColorAttributeName : UIColor.black
            ])
        let alertController = UIAlertController(title: "", message: "",  preferredStyle: .alert)
        alertController.setValue(attributedString, forKey: "attributedTitle")
        alertController.addTextField(
            configurationHandler: {(textField: UITextField!) in
                let att = NSAttributedString(string: "Album Name", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)])
                textField.attributedPlaceholder = att
                textField.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)
                textField.autocapitalizationType = .words
                textField.autocorrectionType = .yes
        })
        alertController.addTextField(
            configurationHandler: {(textField: UITextField!) in
                let att = NSAttributedString(string: "Album Description", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)])
                textField.attributedPlaceholder = att
                textField.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)
                textField.autocapitalizationType = .sentences
                textField.autocorrectionType = .yes
                textField.layer.cornerRadius = 5

        })
        
        let action = UIAlertAction(title: "Create",
                                   style: UIAlertActionStyle.cancel,
                                   handler: {
                                    (paramAction:UIAlertAction!) in
                                    if let textFields = alertController.textFields{
                                        let theTextFields = textFields as [UITextField]
                                        let nameText = theTextFields[0].text
                                        let descriptionText = theTextFields[1].text
                                        if (nameText != "" && descriptionText != "") {
                                            print("name: \(nameText) description: \(descriptionText)")
                                            let taskFirebasePath = self.albumReference?.ref.childByAutoId()
                                            let album = Album(name: nameText, description: descriptionText, id: taskFirebasePath?.key, firebaseReference: nil)
                                            taskFirebasePath?.setValue(album.toDictionary())
                                        }
                                    }
        })
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler:  nil)
        
        alertController.addAction(cancel)
        alertController.addAction(action)
        let subview = alertController.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.tintColor = UIColor.black
        alertContentView.backgroundColor = UIColor.black
        alertContentView.isOpaque = true
        alertContentView.layer.cornerRadius = 16
        alertContentView.alpha = 1
        
        self.present(alertController,
                     animated: true,
                     completion: nil)
    }

    
    func setupTableView() {
        let image = UIImageView(image: UIImage(named: "celest2"))
        image.frame = self.view.frame
        image.contentMode = .scaleAspectFill
        view.addSubview(image)
        
        let overlay = UIView()
        overlay.backgroundColor = LIGHT_BLUE.withAlphaComponent(0.6)
        overlay.frame = self.view.frame
        image.addSubview(overlay)
        
        view.addSubview(logoView)
        logoView.topAnchor.constraint(equalTo: view.topAnchor,constant:20).isActive = true
        logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        logoView.heightAnchor.constraint(equalToConstant: 175).isActive = true
        
        let tableFrame = CGRect(x: 0, y: 250, width: self.view.frame.width, height: self.view.frame.height)
        tableView = UITableView(frame: tableFrame, style: .plain)
        tableView.backgroundColor = UIColor.clear

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: logoView.bottomAnchor,constant:15).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        tableView.register(AlbumCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.layer.masksToBounds = true
        tableView.clipsToBounds = true
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension AlbumListViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AlbumCell
        
        if isAdmin {
            cell.deleteCell.addTarget(self, action: #selector(deleteCell(sender:)), for: .touchUpInside)
            cell.editCell.addTarget(self, action: #selector(editCell(sender:)), for: .touchUpInside)
            cell.deleteCell.isHidden = false
            cell.editCell.isHidden = false
        } else {
            cell.deleteCell.isHidden = true
            cell.editCell.isHidden = true
        }
        
        let album = self.albums[indexPath.row]
        cell.myTextLabel.text = album.name
        cell.myDetailsTextLabel.text = album.description
        
        if indexPath.row%2 == 0 {
            cell.backgroundColor = UIColor.white.withAlphaComponent(0.55)
            cell.myTextLabel.textColor = UIColor.black
            cell.myDetailsTextLabel.textColor = UIColor.black
        } else {
            cell.backgroundColor = UIColor.black.withAlphaComponent(0.45)
            cell.myTextLabel.textColor = UIColor.white
            cell.myDetailsTextLabel.textColor = UIColor.white
        }
        
        return cell
    }
    
    func deleteCell(sender: AnyObject) {
        let position: CGPoint = sender.convert(.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: position)
        let album = albums[(indexPath?.row)!]
        let name = album.name!
        
        let attributedString = NSAttributedString(string: "Are you sure you want to delete album \"\(name)\"?", attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 19, weight:UIFontWeightSemibold),
            NSForegroundColorAttributeName : UIColor.black
            ])
        let alertController = UIAlertController(title: "", message: "",  preferredStyle: .alert)
        alertController.setValue(attributedString, forKey: "attributedTitle")

        let action = UIAlertAction(title: "Delete",
                                   style: UIAlertActionStyle.cancel,
                                   handler: {
                                    (paramAction:UIAlertAction!) in
                                        album.firebaseReference?.removeValue()
        })
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler:  nil)
        
        alertController.addAction(cancel)
        alertController.addAction(action)
        let subview = alertController.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.tintColor = UIColor.black
        alertContentView.backgroundColor = UIColor.black
        alertContentView.isOpaque = true
        alertContentView.layer.cornerRadius = 16
        alertContentView.alpha = 1
        
        self.present(alertController,
                     animated: true,
                     completion: nil)
    }
    
    func editCell(sender: AnyObject) {
        let position: CGPoint = sender.convert(.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: position)
        selectedTask = albums[(indexPath?.row)!]
        
        let attributedString = NSAttributedString(string: "Edit Album", attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 19, weight:UIFontWeightSemibold),
            NSForegroundColorAttributeName : UIColor.black
            ])
        let alertController = UIAlertController(title: "", message: "",  preferredStyle: .alert)
        alertController.setValue(attributedString, forKey: "attributedTitle")
        alertController.addTextField(
            configurationHandler: {(textField: UITextField!) in
                let att = NSAttributedString(string: "Album Name", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)])
                textField.attributedPlaceholder = att
                textField.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)
                textField.autocapitalizationType = .words
                textField.autocorrectionType = .yes
                textField.text = self.selectedTask?.name
        })
        alertController.addTextField(
            configurationHandler: {(textField: UITextField!) in
                let att = NSAttributedString(string: "Album Description", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)])
                textField.attributedPlaceholder = att
                textField.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)
                textField.autocapitalizationType = .sentences
                textField.autocorrectionType = .yes
                textField.layer.cornerRadius = 5
                textField.text = self.selectedTask?.description
                
        })
        
        let action = UIAlertAction(title: "Save",
                                   style: UIAlertActionStyle.cancel,
                                   handler: {
                                    (paramAction:UIAlertAction!) in
                                    if let textFields = alertController.textFields{
                                        let theTextFields = textFields as [UITextField]
                                        let nameText = theTextFields[0].text
                                        let descriptionText = theTextFields[1].text
                                        if (nameText != "" && descriptionText != "") {
                                            print("name: \(nameText) description: \(descriptionText)")
                                            self.selectedTask?.firebaseReference?.updateChildValues(["name" : nameText!,"description" : descriptionText!])
                                        }
                                    }
        })
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler:  nil)
        
        alertController.addAction(cancel)
        alertController.addAction(action)
        let subview = alertController.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.tintColor = UIColor.black
        alertContentView.backgroundColor = UIColor.black
        alertContentView.isOpaque = true
        alertContentView.layer.cornerRadius = 16
        alertContentView.alpha = 1
        
        self.present(alertController,
                     animated: true,
                     completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photoViewController = PhotoCollectionViewController()
        selectedTask = albums[indexPath.row]
        photoViewController.selectedAlbum = selectedTask
        self.navigationController?.pushViewController(photoViewController, animated: true)
    }
}


extension UIImage {
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

