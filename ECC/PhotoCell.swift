//
//  PhotoCell.swift
//  OldeTowne
//
//  Created by Kayla Jensen on 10/9/16.
//  Copyright © 2016 kaylajensencoding. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    var photoId : String?
    
    var photoLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightThin)
        label.textColor = UIColor.white
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = false
        return label
    }()
    
    var gradient : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var photoImageView : UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var favoritedIcon : UIButton = {
        let image = UIButton()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = UIViewContentMode.scaleAspectFit
        image.setImage(UIImage(named: "outline_heart"), for: .normal)
        image.addTarget(self, action: #selector(imageFavorited(sender:)), for: .touchUpInside)
        return image
    }()
    
    func imageFavorited(sender: AnyObject) {
        
        print("photoId : \(photoId)")
        
        if(favoritedIcon.currentImage == UIImage(named: "outline_heart")) {
            favoritedIcon.setImage(UIImage(named: "filled_in_heart"), for: .normal)
        } else {
            favoritedIcon.setImage(UIImage(named: "outline_heart"), for: .normal)
        }
    }
    
    func setFavorited() {
        favoritedIcon.setImage(UIImage(named: "filled_in_heart"), for: .normal)
    }
    
    lazy var editPhotoButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.black
        button.setTitle("Edit", for: UIControlState.normal)
        return button
    }()
    
    lazy var deletePhotoButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.black
        button.setTitle("Delete", for: UIControlState.normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        photoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        contentView.addSubview(photoImageView)
        photoImageView.layer.masksToBounds = false
        photoImageView.clipsToBounds = true
        
        gradient.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.size.width, height: 80)
        contentView.addSubview(gradient)
        gradient.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        gradient.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        gradient.heightAnchor.constraint(equalToConstant: 80).isActive = true
        gradient.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        
        let colorTop = UIColor.clear.cgColor
        let colorBottom = UIColor.black.cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = gradient.frame
        gradient.layer.addSublayer(gradientLayer)
        
        gradient.addSubview(photoLabel)
        photoLabel.centerXAnchor.constraint(equalTo: gradient.centerXAnchor).isActive = true
        photoLabel.centerYAnchor.constraint(equalTo: gradient.centerYAnchor).isActive = true
        photoLabel.widthAnchor.constraint(equalTo: gradient.widthAnchor,constant:-30).isActive = true
        photoLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        contentView.addSubview(editPhotoButton)
        editPhotoButton.leftAnchor.constraint(equalTo: gradient.leftAnchor).isActive = true
        editPhotoButton.centerYAnchor.constraint(equalTo: gradient.centerYAnchor).isActive = true
        editPhotoButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        editPhotoButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        contentView.addSubview(deletePhotoButton)
        deletePhotoButton.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        deletePhotoButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        deletePhotoButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        deletePhotoButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
