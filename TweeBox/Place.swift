//
//  Place.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/5.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Place {
    
    var attributes: PlaceAttributes
    var boundingBox: Coordinates
    var country: String
    var countryCode: String
    var fullName: String
    var id: String
    var name: String
    var placeType: String
    var url: URL?
    
    init(with json: JSON) {
        
        attributes  = PlaceAttributes(with: json["attributes"])
        boundingBox = Coordinates(with: json["bounding_box"])
        country     = json["country"].stringValue
        countryCode = json["country_code"].stringValue
        fullName    = json["full_name"].stringValue
        id          = json["id"].stringValue
        name        = json["name"].stringValue
        placeType   = json["place_type"].stringValue
        url         = json["url"].stringValue.url
    }
}

struct PlaceAttributes {
    
    var streetAddress: String?
    var locality: String?
    // the city the place is in
    var region: String?
    // the administrative region the place is in
    var iso3: String?
    // the country code
    var postalCode: String?
    // in the preferred local format for the place
    var phone: String?
    // in the preferred local format for the place, include long distance code
    var twitter: String?
    // twitter screen-name, without @
    var url: URL?
    // official/canonical URL for place
    //            public var appID: String?
    // An ID or comma separated list of IDs representing the place in the applications place database.
    
    init(with json: JSON) {
        
        streetAddress = json["street_address"].string
        locality = json["locality"].string
        region = json["region"].string
        iso3 = json["iso3"].string
        postalCode = json["postal_code"].string
        phone = json["phone"].string
        twitter = json["twitter"].string
        url = json["url"].stringValue.url
        //            appID = json["app:id"].string
    }
}
