//
//  Photo.swift
//  ECC
//
//  Created by Kayla Jensen on 12/22/16.
//  Copyright © 2016 kaylajensencoding. All rights reserved.
//

import Foundation
import Firebase

struct Photo {
    var label : String?
    var id : String?
    var url : String?
    var albumId : String?
    var firebaseReference : FIRDatabaseReference?
}

extension Photo {
    init?(dictionary: [String : Any]) {
        self.url = dictionary["url"] as? String
        self.id = dictionary["id"] as? String
        self.label = dictionary["label"] as? String
        self.albumId = dictionary["albumId"] as? String
        self.firebaseReference = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: Any]
        self.label = snapshotValue["label"] as? String
        self.id = snapshotValue["id"] as? String
        self.url = snapshotValue["url"] as? String
        self.albumId = snapshotValue["albumId"] as? String
        self.firebaseReference = snapshot.ref
    }
    
    func toDictionary() -> Any {
        return [
            "label" : self.label!,
            "id" : self.id!,
            "url" : self.url!,
            "albumId" : self.albumId!
        ]
    }

}
