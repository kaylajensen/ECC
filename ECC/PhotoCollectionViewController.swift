//
//  PhotoCollectionViewController.swift
//  ECC
//
//  Created by Kayla Jensen on 12/20/16.
//  Copyright © 2016 kaylajensencoding. All rights reserved.
//

import UIKit
import DKImagePickerController
import Firebase
import FirebaseCore

class PhotoCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UINavigationControllerDelegate {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var gradient : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var expandedContainer : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.purple
        return view
    }()
    
    var expandedImageView : UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var exitExpanded : UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "close")
        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(exitExpandedPressed), for: .touchUpInside)
        return button
    }()
    
    var expandedLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightThin)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    var indicator = UIActivityIndicatorView()
    var selectedAlbum : Album? = nil
    var collectionView : UICollectionView!
    
    var photos = [Photo]()
    var photoReference : FIRDatabaseReference?
    var albumReference : FIRDatabaseReference?
    var uiPhotos = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigation()
        setupIndicator()
        setupExpandedView()
        
        let selectedAlbumId = selectedAlbum?.id
        albumReference = FIRDatabase.database().reference().child("albums").child(selectedAlbumId!)
        photoReference = albumReference?.child("photos")
        
        photoReference?.queryOrdered(byChild: "label").observe(.value, with: { (snapshot) in
            var items : [Photo] = []
            for item in snapshot.children {
                
                let photo = Photo(snapshot: item as! FIRDataSnapshot)
                if photo.albumId == selectedAlbumId {
                    items.append(photo)
                    if !isAdmin {
                        let decodedData = NSData(base64Encoded: photo.url!, options: .ignoreUnknownCharacters)
                        let decodedImage = UIImage(data: decodedData as! Data)
                        self.uiPhotos.append(decodedImage!)
                    }
                }
            }
            self.photos = items
            self.indicator.stopAnimating()
            self.collectionView.reloadData()
        })
    }
    
    func setupIndicator() {
        indicator.color = LIGHT_BLUE
        indicator.startAnimating()
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func setupExpandedView() {
        
        view.addSubview(expandedImageView)
        expandedImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        expandedImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        expandedImageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        expandedImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        expandedImageView.isHidden = true
        
        let viewTop = UIView()
        viewTop.backgroundColor = UIColor.clear
        viewTop.translatesAutoresizingMaskIntoConstraints = false
        
        let grad = UIView()
        grad.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50)
        let colorTop1 = UIColor.black.cgColor
        let colorBottom1 = UIColor.clear.cgColor
        let gradientLayer1 = CAGradientLayer()
        gradientLayer1.colors = [colorTop1, colorBottom1]
        gradientLayer1.locations = [0.0, 1.0]
        gradientLayer1.frame = grad.frame
        grad.layer.addSublayer(gradientLayer1)

        viewTop.addSubview(grad)
        
        viewTop.addSubview(exitExpanded)
        exitExpanded.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        expandedImageView.addSubview(viewTop)
        viewTop.topAnchor.constraint(equalTo: expandedImageView.topAnchor).isActive = true
        viewTop.widthAnchor.constraint(equalTo: expandedImageView.widthAnchor).isActive = true
        viewTop.centerXAnchor.constraint(equalTo: expandedImageView.centerXAnchor).isActive = true
        viewTop.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let viewBottom = UIView()
        viewBottom.backgroundColor = UIColor.clear
        viewBottom.translatesAutoresizingMaskIntoConstraints = false
        
        expandedImageView.addSubview(viewBottom)
        viewBottom.bottomAnchor.constraint(equalTo: expandedImageView.bottomAnchor).isActive = true
        viewBottom.widthAnchor.constraint(equalTo: expandedImageView.widthAnchor).isActive = true
        viewBottom.centerXAnchor.constraint(equalTo: expandedImageView.centerXAnchor).isActive = true
        viewBottom.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        gradient.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50)
        let colorTop = UIColor.clear.cgColor
        let colorBottom = UIColor.black.cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = gradient.frame
        gradient.layer.addSublayer(gradientLayer)
        
        viewBottom.addSubview(gradient)
        viewBottom.addSubview(expandedLabel)
        expandedLabel.rightAnchor.constraint(equalTo: viewBottom.rightAnchor,constant:-15).isActive = true
        expandedLabel.bottomAnchor.constraint(equalTo: viewBottom.bottomAnchor,constant:-15).isActive = true
        expandedLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        expandedLabel.widthAnchor.constraint(equalTo: viewBottom.widthAnchor).isActive = true
    }
    
    func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "collectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.black
        view.addSubview(collectionView)
    }
    
    func exitExpandedPressed() {
        expandedImageView.isHidden = true
        collectionView.isUserInteractionEnabled = true
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setupNavigation() {
        view.backgroundColor = UIColor.white
        
        if isAdmin {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "add_photo"), style: .plain, target: self, action: #selector(addPhotos))
        }
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: UIColor.clear), for: .default)
        self.tabBarController?.tabBar.isHidden = true
        self.title = selectedAlbum?.name
        let titleDict = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict
    }
    
    func addPhotos() {
        let pickerController = DKImagePickerController()
        pickerController.delegate = self
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            print("num photos to upload: \(assets.count)")
            for each in assets {
                each.fetchOriginalImageWithCompleteBlock({ (image, info) in
                    if let imageData = UIImagePNGRepresentation(image!) {
                        print("imageData : \(imageData)")
                        let base64string = imageData.base64EncodedString(options: .lineLength64Characters)
                        let photoFirebasePath = self.photoReference?.ref.childByAutoId()
                        let photo = Photo(label: "", id: photoFirebasePath?.key, url: base64string, albumId: self.selectedAlbum?.id, firebaseReference: nil)
                        photoFirebasePath?.setValue(photo.toDictionary())
                    }
                })
            }
        }
        self.present(pickerController, animated: true, completion: nil)
    }
}

extension PhotoCollectionViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let photo = photos[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! PhotoCell
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        cell.photoImageView.contentMode = .scaleAspectFill
        cell.photoLabel.text = photo.label
        cell.photoId = photo.id
        
        if isAdmin {
            cell.deletePhotoButton.addTarget(self, action: #selector(deletePhotoPressed(sender:)), for: .touchUpInside)
            cell.editPhotoButton.addTarget(self, action: #selector(editPhotoPressed(sender:)), for: .touchUpInside)
            let decodedData = NSData(base64Encoded: photo.url!, options: .ignoreUnknownCharacters)
            let decodedImage = UIImage(data: decodedData as! Data)
            cell.photoImageView.image = decodedImage
            cell.editPhotoButton.isHidden = false
            cell.deletePhotoButton.isHidden = false
        } else {
            cell.photoImageView.image = uiPhotos[indexPath.row]
            cell.editPhotoButton.isHidden = true
            cell.deletePhotoButton.isHidden = true
        }
        
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if isiPad() {
            return CGSize(width: 235, height: 235)
        }
        
        return CGSize(width: self.view.frame.size.width, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("image selected: \(indexPath.row)")
        let photo = photos[indexPath.row]
        
        if isAdmin {
            let decodedData = NSData(base64Encoded: photo.url!, options: .ignoreUnknownCharacters)
            let decodedImage = UIImage(data: decodedData as! Data)
            expandedImageView.image = decodedImage
        } else {
            expandedImageView.image = uiPhotos[indexPath.row]
        }

        expandedLabel.text = photo.label
        collectionView.isUserInteractionEnabled = false
        
        self.navigationController?.navigationBar.isHidden = true
        expandedImageView.isHidden = false
        
    }

}

extension PhotoCollectionViewController {
    func deletePhotoPressed(sender: AnyObject) {
        let position: CGPoint = sender.convert(.zero, to: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: position)
        let photo = photos[(indexPath?.row)!]
        let label = photo.label!
        
        let attributedString = NSAttributedString(string: "Are you sure you want to delete photo with label \"\(label)\"?", attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 19, weight:UIFontWeightSemibold),
            NSForegroundColorAttributeName : UIColor.black
            ])
        let alertController = UIAlertController(title: "", message: "",  preferredStyle: .alert)
        alertController.setValue(attributedString, forKey: "attributedTitle")
        
        let action = UIAlertAction(title: "Delete",
                                   style: UIAlertActionStyle.cancel,
                                   handler: {
                                    (paramAction:UIAlertAction!) in
                                    photo.firebaseReference?.removeValue()
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
    
    func editPhotoPressed(sender: AnyObject) {
        print("edit photo pressed")
        let position: CGPoint = sender.convert(.zero, to: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: position)
        let photo = photos[(indexPath?.row)!]
        
        let attributedString = NSAttributedString(string: "Edit Photo Label", attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 19, weight:UIFontWeightSemibold),
            NSForegroundColorAttributeName : UIColor.black
            ])
        let alertController = UIAlertController(title: "", message: "",  preferredStyle: .alert)
        alertController.setValue(attributedString, forKey: "attributedTitle")
        
        alertController.addTextField(
            configurationHandler: {(textField: UITextField!) in
                let att = NSAttributedString(string: "Label Name", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)])
                textField.attributedPlaceholder = att
                textField.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)
                textField.autocapitalizationType = .sentences
                textField.autocorrectionType = .yes
                textField.layer.cornerRadius = 5
                if photo.label != "" {
                    textField.text = photo.label
                }
                
        })
        
        let action = UIAlertAction(title: "Save",
                                   style: UIAlertActionStyle.cancel,
                                   handler: {
                                    (paramAction:UIAlertAction!) in
                                    if let textFields = alertController.textFields{
                                        let theTextFields = textFields as [UITextField]
                                        let nameText = theTextFields[0].text
                                        if (nameText != "" && nameText != photo.label) {
                                            print("label: \(nameText)")
                                            photo.firebaseReference?.updateChildValues(["label" : nameText!])
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
        self.present(alertController, animated: true, completion: nil)
    }
}
