//
//  Constants.swift
//  ECC
//
//  Created by Kayla Jensen on 12/20/16.
//  Copyright © 2016 kaylajensencoding. All rights reserved.
//

import Foundation
import UIKit

public var LIGHT_BLUE = UIColor(red: 101.0/255.0, green: 166.0/255.0, blue: 166.0/255.0, alpha: 1.0)
public var PINK_COLOR = UIColor(red: 255/255, green: 51/255, blue: 160/255, alpha: 1.0)
public var LIGHT_PINK_COLOR = UIColor(red: 255/255, green: 172/255, blue: 219/255, alpha: 1.0)
public var OPACITY : CGFloat = 0.8
public var OVERLAY_OPACITY : CGFloat = 0.4
public var isAdmin = false

public func isiPad() -> Bool {
    var isIPad = false
    isIPad = UIDevice.current.userInterfaceIdiom == .pad
    return isIPad
}

// Bakery Coordinates
public var bakeryLat = "35.196018"
public var bakeryLon = "-80.784934"

public var tagLineString = "Providing the Charlotte area's best \ncakes and desserts."
public var phoneInfoString = "Please call the bakery at\n(704)258-1209 to place any orders!"
public var emailString = "ecc@gmail.com"
public var monFriHours = "Monday - Friday: 12:00PM - 6:00PM"
public var satHours = "Saturday: Closed"
public var sunHours = "Sunday: Closed"
public var addressString = "4332 Commonwealth Avenue\nCharlotte, North Carolina"
public var phoneString = "(704)258-1209"

public var screenHeight = UIScreen.main.bounds.size.height


