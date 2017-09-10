//
//  TwitterUser.swift
//  TweeBox
//
//  Created by 4faramita on 2017/7/28.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class TwitterUser: NSManagedObject {
    
//    public var id: String
    
//    public var location: String?
    
//    public var name: String  // not the @ one, that's the "screen_name"
//    public var screenName: String
    
//    public var url: URL?
    // A URL provided by the user in association with their profile.
    
//    public var createdAt: String
    
//    public var defaultProfile: Bool
    // When true, indicates that the user has not altered the theme or background of their user profile.
//    public var defaultProfileImage: Bool
    
//    public var bio: String?
//    public var entities: Entity
    // Entities which have been parsed out of the url or description fields defined by the user.
    
//    public var verified: Bool
    
//    public var favouritesCount: Int
    
//    public var followRequestSent: Bool?
    // When true, indicates that the authenticating user has issued a follow request to this protected user account
//    public var following: Bool?
//    public var followersCount: Int
//    public var followingCount: Int  // friends_count
    
//    public var geoEnabled: Bool
    // When true, indicates that the user has enabled the possibility of geotagging their Tweets.
    // This field must be true for the current user to attach geographic data when using POST statuses / update .
    
//    public var isTranslator: Bool
    // When true, indicates that the user is a participant in Twitter’s translator community .
    
//    public var lang: String
    
//    public var listedCount: Int
    // The number of public lists that this user is a member of.
    
//    public var notifications: Bool?
    // Indicates whether the authenticated user has chosen to receive this user’s Tweets by SMS.
    
//    public var profileBackgroundColor: String
    // The hexadecimal color chosen by the user for their background.
    
//    public var profileBackgroundImageURLHTTP: URL?  // profile_background_image_url
//    public var profileBackgroundImageURL: URL?  // profile_background_image_url_https
//    public var profileBackgroundTile: Bool
    // When true, indicates that the user’s profile_background_image_url should be tiled when displayed.
//    public var profileBannerURL: URL?
    // By adding a final path element of the URL,
    // it is possible to obtain different image sizes optimized for specific displays.
//    public var profileImageURLHTTP: URL?  // profile_image_url
//    public var profileImageURL: URL?  // profile_image_url_https
//    public var profileUseBackgroundImage: Bool
    
//    public var profile_link_color: String
//    public var profile_sidebar_border_color: String
//    public var profile_sidebar_fill_color: String
//    public var profile_text_color: String
    
//    public var protected: Bool
    
//    public var status: Tweet?
//    public var statusesCount: Int
    // The number of Tweets (including retweets) issued by the user.
    
//    public var timeZone: String?
//    public var utcOffset: Int?
    // The offset from GMT/UTC in seconds.

//    public var withheld_in_countries: String?
//    public var withheld_scope: String?
    
    var userEntities: Entity? {
        if let entitiesData = self.entities {
            let entitiesJSON = JSON(data: entitiesData as Data)
            
            let entities = Entity(with: entitiesJSON, and: JSON.null)
            
            return entities
        }
        return nil
    }

    
    class func createTwitterUser(with userJSON: JSON, in context: NSManagedObjectContext) -> TwitterUser {
        
        let user = TwitterUser(context: context)
        
        user.id                            = userJSON["id_str"].stringValue
        user.location                      = userJSON["location"].string
        user.name                          = userJSON["name"].stringValue
        user.screenName                    = userJSON["screen_name"].stringValue
        user.url                           = userJSON["url"].stringValue
        user.createdAt                     = TwitterDate(string: userJSON["created_at"].stringValue).date! as NSDate
        user.defaultProfile                = userJSON["default_profile"].bool ?? true
        user.defaultProfileImage           = userJSON["default_profile_image"].bool ?? true
        user.bio                           = userJSON["description"].string
        user.entities                      = (try? userJSON["entities"].rawData()) as NSData?
        user.verified                      = userJSON["verified"].bool ?? false
        user.favouritesCount               = Int64(userJSON["favourites_count"].intValue)
        user.followRequestSent             = userJSON["follow_request_sent"].boolValue
        user.following                     = userJSON["following"].boolValue
        user.followersCount                = Int64(userJSON["followers_count"].intValue)
        user.followingCount                = Int64(userJSON["friends_count"].intValue)
        user.geoEnabled                    = userJSON["geo_enabled"].bool ?? false
        user.isTranslator                  = userJSON["is_translator"].bool ?? false
        user.lang                          = userJSON["lang"].stringValue
        user.listedCount                   = Int64(userJSON["listed_count"].intValue)
        user.notifications                 = userJSON["notifications"].boolValue
        user.profileBackgroundColor        = userJSON["profile_background_color"].stringValue
        user.profileBackgroundImageURLHTTP = userJSON["profile_background_image_url"].stringValue
        user.profileBackgroundImageURL     = userJSON["profile_background_image_url_https"].stringValue
        user.profileBackgroundTile         = userJSON["profile_background_tile"].bool ?? false
        user.profileBannerURL              = userJSON["profile_banner_url"].stringValue
        user.profileImageURLHTTP           = userJSON["profile_image_url"].stringValue
        user.profileImageURL               = URL(string: userJSON["profile_image_url_https"].stringValue, quality: .max)?.absoluteString
        user.profileUseBackgroundImage     = userJSON["profile_use_background_image"].bool ?? true
        user.protected                     = userJSON["protected"].bool ?? false
//        user.status                        = try? Tweet.matchOrCreateTweet(with: userJSON["status"], in: context)  // ((userJSON["status"].null == nil) ? (try? Tweet.matchOrCreateTweet(with: userJSON["status"], in: context)) : nil)
        user.statusesCount                 = Int64(userJSON["statuses_count"].intValue)
        user.timeZone                      = userJSON["time_zone"].string
        user.utcOffset                     = Int32(userJSON["utc_offset"].intValue)
        
        return user
    }
    
    class func matchOrCreateTwitterUser(with json: JSON, in context: NSManagedObjectContext) throws -> TwitterUser {
        
        let request: NSFetchRequest<TwitterUser> = TwitterUser.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", json["id_str"].stringValue)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "TwitterUser.matchOrCreateTwitterUser == db inconsistency")
                return matches[0]
            }
        } catch {
            throw error
            // may need more effort
        }
        
        return TwitterUser.createTwitterUser(with: json, in: context)
        // WHY
    }

}
