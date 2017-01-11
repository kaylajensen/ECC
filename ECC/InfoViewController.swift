//
//  InfoViewController.swift
//  OTB
//
//  Created by Kayla Jensen on 12/21/16.
//  Copyright © 2016 kaylajensencoding. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = LIGHT_BLUE

        let text = readFromDocumentsFile(fileName: "citation")
        let label = UILabel(frame: self.view.frame)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = text
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightThin)
        view.addSubview(label)
    }
    
    func readFromDocumentsFile(fileName:String) -> String {
        
        var text : String!
        if let path = Bundle.main.path(forResource: fileName, ofType: "txt") {
            do {
                text = try String(contentsOfFile: path, encoding: .utf8)
                print(text)
            } catch {
                print("Failed to read text from \(fileName)")
                text = ""
            }
        } else {
            print("Failed to load file from app bundle \(fileName)")
            text = ""
        }
        
        return text
    }

}
