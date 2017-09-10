//
//  PlaceAttributes.swift
//  TweeBox
//
//  Created by 4faramita on 2017/9/10.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData


class PlaceAttributes: NSManagedObject {
    
    //    public var streetAddress: String?
    //    public var locality: String?
    // the city the place is in
    //    public var region: String?
    // the administrative region the place is in
    //    public var iso3: String?
    // the country code
    //    public var postalCode: String?
    // in the preferred local format for the place
    //    public var phone: String?
    // in the preferred local format for the place, include long distance code
    //    public var twitter: String?
    // twitter screen-name, without @
    //    public var url: URL?
    // official/canonical URL for place
    //        public var appID: String?
    // An ID or comma separated list of IDs representing the place in the applications place database.
    
    init(with json: JSON) {
        
        streetAddress = json["street_address"].string
        locality = json["locality"].string
        region = json["region"].string
        iso3 = json["iso3"].string
        postalCode = json["postal_code"].string
        phone = json["phone"].string
        twitter = json["twitter"].string
        url = json["url"].stringValue
        //            appID = json["app:id"].string
    }
}
