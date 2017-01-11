//
//  Album.swift
//  ECC
//
//  Created by Kayla Jensen on 12/22/16.
//  Copyright © 2016 kaylajensencoding. All rights reserved.
//

import Foundation
import Firebase

struct Album {
    var name : String?
    var description : String?
    var id : String?
    var firebaseReference : FIRDatabaseReference?
}

extension Album {
    init?(dictionary: [String : Any]) {
        guard let name = dictionary["name"] as? String,
            let description = dictionary["description"] as? String,
            let id = dictionary["id"] as? String
        else {
            return nil
        }
        
        self.name = name
        self.description = description
        self.id = id
        self.firebaseReference = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: Any]
        self.name = snapshotValue["name"] as? String
        self.description = snapshotValue["description"] as? String
        self.id = snapshotValue["id"] as? String
        self.firebaseReference = snapshot.ref
    }
    
    func toDictionary() -> Any {
        return [
            "name" : self.name!,
            "description" : self.description!,
            "id" : self.id!
        ]
    }
}
