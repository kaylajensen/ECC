//
//  Constants.swift
//  OTB
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

// Olde Towne Bakery Coordinates
public var bakeryLat = "41.494346"
public var bakeryLon = "-90.527613"

public var tagLineString = "Providing the Charlotte area's best \ncakes and pastries."
public var phoneInfoString = "Please call the bakery at\n(704) 258-1209 to place any orders!"
public var emailString = "ecc@gmail.com"
public var pricingString = "Cake sizes range from 4 inch to 18 inch round starting at $7.95 to $81.95 Plus extra charges based on flavor and decoration. (this doesn't include birthday tier or wedding cake prices)\nOur sheet cakes come in 8x12, 12x16, and 16x25 and start at $24.95 Based on size flavor and decoration.\nOur famous sugar cookies come in two sizes,\n*Stencil (about 3-4 inches) that can have writing or stenciled designs at $9.00 a dozen or\n*Rainbow (about 2-3 inches) that can only have colors sprayed at $7.50 a dozen"
public var monFriHours = "Monday - Friday: 12:00PM - 6:00PM"
public var satHours = "Saturday: Closed"
public var sunHours = "Sunday: Closed"
public var addressString = "4332 Commonwealth Avenue\nCharlotte, North Carolina"
public var phoneString = "(704) 258-1209"

public var screenHeight = UIScreen.main.bounds.size.height


