//
//  AlbumCell.swift
//  OTB
//
//  Created by Kayla Jensen on 12/20/16.
//  Copyright © 2016 kaylajensencoding. All rights reserved.
//

import Foundation
import UIKit

class AlbumCell : UITableViewCell {
    
    var myTextLabel = UILabel()
    var myDetailsTextLabel = UILabel()
    
    var deleteCell : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Delete", for: .normal)
        button.tintColor = UIColor.white
        return button
    }()
    
    var editCell : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit", for: .normal)
        button.tintColor = UIColor.white
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectionStyle = .none
        //self.backgroundColor = UIColor.clear
        
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor.clear
        contentView.addSubview(container)
        container.addSubview(myTextLabel)
        container.addSubview(myDetailsTextLabel)
        contentView.addSubview(deleteCell)
        contentView.addSubview(editCell)
        
        container.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        container.heightAnchor.constraint(equalToConstant: 40).isActive = true
        container.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        
        self.myTextLabel.textAlignment = .center
        self.myDetailsTextLabel.textAlignment = .center
        
        self.myTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.myTextLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        self.myTextLabel.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        self.myTextLabel.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        self.myTextLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.myTextLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightRegular)
        
        self.myDetailsTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.myDetailsTextLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        self.myDetailsTextLabel.topAnchor.constraint(equalTo: self.myTextLabel.bottomAnchor, constant: 5).isActive = true
        self.myDetailsTextLabel.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        self.myDetailsTextLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        self.myDetailsTextLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightThin)
        
        self.deleteCell.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        self.deleteCell.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant:15).isActive = true
        
        self.editCell.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        self.editCell.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant:-15).isActive = true
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
}
