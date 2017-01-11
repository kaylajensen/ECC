//
//  NetworkManager.swift
//  OTB
//
//  Created by Kayla Jensen on 12/22/16.
//  Copyright © 2016 kaylajensencoding. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class NetworkManager {
    static let shared = NetworkManager()
    
    var userIsLoggedIn = false
    var albums = [Album]()
    var photos = [Photo]()
    var favoritePhotos = [Photo]()
    
    func checkIfUserIsLoggedIn() -> Bool {
        if userIsLoggedIn {
            return true
        } else {
            if FIRAuth.auth()?.currentUser != nil {
                if FIRAuth.auth()?.currentUser?.email == "ecc@gmail.com" {
                    isAdmin = true
                } else {
                    isAdmin = false
                }
                userIsLoggedIn = true
                return true
            } else {
                userIsLoggedIn = false
                return false
            }
        }
    }
    
    func logUserOut() {
        try! FIRAuth.auth()!.signOut()
        userIsLoggedIn = false
    }
    
    func updatePhotoLabel(photoId : String, photoLabel : String) {
        var index = 0
        for photo in photos {
            if photo.id == photoId {
                photos[index].label = photoLabel
                return
            }
            index = index + 1
        }
        print("UPDATED photos : \(photos)")
    }
}
