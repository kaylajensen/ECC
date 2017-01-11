//
//  PhotoCollectionViewController.swift
//  OTB
//
//  Created by Kayla Jensen on 12/20/16.
//  Copyright © 2016 kaylajensencoding. All rights reserved.
//

import UIKit
import DKImagePickerController

class FavoritePhotoCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UINavigationControllerDelegate {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var photos : [[String : String]] = [["photoId" : "", "albumId" : "", "label" : "CLT",
                                         "url" : "", "favorited" : "1"],
                                        ["photoId" : "", "albumId" : "", "label" : "DLU",
                                         "url" : "", "favorited" : "0"],
                                        ["photoId" : "", "albumId" : "", "label" : "ELV",
                                         "url" : "", "favorited" : "1"],
                                        ["photoId" : "", "albumId" : "", "label" : "FLW",
                                         "url" : "", "favorited" : "0"],
                                        ["photoId" : "", "albumId" : "", "label" : "GLX",
                                         "url" : "", "favorited" : "1"]]
    var collectionView : UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupCollectionView()
    }
    
    func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "collectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        view.addSubview(collectionView)
    }
    
    func setupNavigation() {
        view.backgroundColor = UIColor.white
        
        self.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(named: "outline_heart"), selectedImage: UIImage(named: "filled_in_heart"))
        self.tabBarController?.tabBar.tintColor = UIColor.white
        self.tabBarController?.tabBar.backgroundImage = UIImage.imageWithColor(color: UIColor.black.withAlphaComponent(OPACITY))
        self.tabBarController?.tabBar.shadowImage = UIImage()
        self.tabBarController?.tabBar.isTranslucent = true
        self.tabBarController?.tabBar.isHidden = false
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
    self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: UIColor.clear), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
}

extension FavoritePhotoCollectionViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return NetworkManager.shared.favoritePhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! PhotoCell
        
        cell.photoImageView.image = UIImage.imageWithColor(color: LIGHT_BLUE.withAlphaComponent(OPACITY))
        let photo = NetworkManager.shared.favoritePhotos[indexPath.row]
        cell.photoLabel.text = photo.label
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if isiPad() {
            return CGSize(width: 235, height: 235)
        }
        
        return CGSize(width: 350, height: 350)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("image selected: \(indexPath.row)")
    }
    
}
