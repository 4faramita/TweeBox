//
//  Place.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/5.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class Place: NSManagedObject {
    
//    public var attributes: PlaceAttributes
//    public var boundingBox: Coordinates
//    public var country: String
//    public var countryCode: String
//    public var fullName: String
//    public var id: String
//    public var name: String
//    public var placeType: String
//    public var url: URL?
    
    init(with json: JSON) {
        
        attributes  = PlaceAttributes(with: json["attributes"])
        boundingBox = Coordinates(with: json["bounding_box"])
        country     = json["country"].stringValue
        countryCode = json["country_code"].stringValue
        fullName    = json["full_name"].stringValue
        id          = json["id"].stringValue
        name        = json["name"].stringValue
        placeType   = json["place_type"].stringValue
        url         = json["url"].stringValue
    }
}
