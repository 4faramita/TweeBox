//
//  Tweet.swift
//  TweeBox
//
//  Created by 4faramita on 2017/7/28.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class Tweet: NSManagedObject {
    
//    public var coordinates: Coordinates?
    
//    public var createdTime: Date?
    
//    public var currenUserRetweet: String?
    // Only surfaces on methods supporting the include_my_retweet parameter, when set to true.
    // Details the Tweet ID of the user’s own retweet (if existent) of this Tweet.
    
//    public var entities: Entity?
    
//    public var favoriteCount: Int?
    
//    public var favorited: Bool
    
//    public var filterLevel: String?
    // Indicates the maximum value of the filter_level parameter which may be used and still stream this Tweet.
    // So a value of medium will be streamed on none, low, and medium streams.
    
//    public var id: String
    
    
//    public var inReplyToScreenName: String?
    
//    public var inReplyToStatusID: String?
    // If the represented Tweet is a reply, this field will contain the integer representation of the original Tweet’s ID.
    
//    public var inReplyToUserID: String?
    // If the represented Tweet is a reply, this field will contain the string representation of the original Tweet’s author ID.
    // This will not necessarily always be the user directly mentioned in the Tweet.
    
    
//    public var lang: String?
    
//    public var place: Place?
    
//    public var possiblySensitive: Bool?
    
//    public var quotedStatusID: String?
    // This field only surfaces when the Tweet is a quote Tweet. This field contains the integer value Tweet ID of the quoted Tweet.
    
//    public var quotedStatus: Tweet?
    // This field only surfaces when the Tweet is a quote Tweet.
    // This attribute contains the Tweet object of the original Tweet that was quoted.
    
    //    public var scopes
    
//    public var retweetCount: Int
    
//    public var retweeted: Bool
    
//    public var retweetedStatus: Tweet?
    
//    public var source: String
    // Utility used to post the Tweet, as an HTML-formatted string.
    // Tweets from the Twitter website have a source value of web.
    
//    public var text: String
    
//    public var truncated: Bool
    /*
     Indicates whether the value of the text parameter was truncated, for example, as a result of a retweet exceeding the 140 character Tweet length.
     Truncated text will end in ellipsis, like this ... Since Twitter now rejects long Tweets vs truncating them, the large majority of Tweets will have this set to false.
     Note that while native retweets may have their toplevel text property shortened, the original text will be available under the retweeted_status object and the truncated parameter will be set to the value of the original status (in most cases, false).
     */
    
//    public var user: TwitterUser
    
//    public var withheldCopyright: Bool?
    // When present and set to “true”, it indicates that this piece of content has been withheld due to a DMCA complaint.
    
//    public var withheldInCountries: [String]?
    // When present, indicates a list of uppercase two-letter country codes this content is withheld from. Twitter supports the following non-country values for this field:
    //  “XX” - Content is withheld in all countries “XY” - Content is withheld due to a DMCA request.
    
//    public var withheldScope: String?
    // When present, indicates whether the content being withheld is the “status” or a “user.”
    
    var tweetEntities: Entity? {
        if let entitiesData = self.entities {
            let entitiesJSON = JSON(data: entitiesData as Data)
            
            var extendedEntitiesJSON = JSON.null
            if let extendedEntitiesData = self.extendedEntities {
                extendedEntitiesJSON = JSON(data: extendedEntitiesData as Data)
            }
            
            let entities = Entity(with: entitiesJSON, and: extendedEntitiesJSON)
            
            return entities
        }
        return nil
    }

    
    class func createTweet(with tweetJSON: JSON, in context: NSManagedObjectContext) -> Tweet {
        
        let tweet = Tweet(context: context)
        
        tweet.coordinates         = ((tweetJSON["coordinates"].null == nil) ? ((try? tweetJSON["coordinates"].rawData()) as NSData?) : nil)
        tweet.createdTime         = TwitterDate(string: tweetJSON["created_at"].stringValue).date! as NSDate
        tweet.currenUserRetweet   = tweetJSON["current_user_retweet"].string
        tweet.entities            = (try? tweetJSON["entities"].rawData()) as NSData?
        tweet.extendedEntities    = (try? tweetJSON["extended_entities"].rawData()) as NSData?
        tweet.favoriteCount       = Int64(tweetJSON["favorite_count"].intValue)
        tweet.favorited           = tweetJSON["favorited"].bool ?? false
        tweet.filterLevel         = tweetJSON["filter_level"].string
        tweet.id                  = tweetJSON["id_str"].stringValue
        tweet.inReplyToScreenName = tweetJSON["in_reply_to_screen_name"].string
        tweet.inReplyToStatusID   = tweetJSON["in_reply_to_status_id_str"].string
        tweet.inReplyToUserID     = tweetJSON["in_reply_to_user_id_str"].string
        tweet.lang                = tweetJSON["lang"].string
        tweet.place               = ((tweetJSON["place"].null == nil) ? ((try? tweetJSON["place"].rawData()) as NSData?) : nil)
        tweet.possiblySensitive   = tweetJSON["possibly_sensitive"].boolValue
        tweet.quotedStatusID      = tweetJSON["quoted_status_id_str"].string
        tweet.quotedStatus        = ((tweetJSON["quoted_status"].null == nil) ? (try? Tweet.matchOrCreateTweet(with: tweetJSON["quoted_status"], in: context)) : nil)
        tweet.retweetCount        = Int64(tweetJSON["retweet_count"].int ?? 0)
        tweet.retweeted           = tweetJSON["retweeted"].bool ?? false
        tweet.retweetedStatus     = ((tweetJSON["retweeted_status"].null == nil) ? (try? Tweet.matchOrCreateTweet(with: tweetJSON["retweeted_status"], in: context)) : nil)
        tweet.source              = tweetJSON["source"].stringValue
        tweet.text                = tweetJSON["text"].stringValue
        tweet.truncated           = tweetJSON["truncated"].bool ?? false
        tweet.user                = try? TwitterUser.matchOrCreateTwitterUser(with: tweetJSON["user"], in: context)
        //        withheldCopyright: tweetJSON["withheld_copyright"].bool
        //        withheldInCountries: nil
        //        withheldScope: tweetJSON["withheld_scope"].string
        
        return tweet
    }
    
    
    class func matchOrCreateTweet(with json: JSON, in context: NSManagedObjectContext) throws -> Tweet {
        let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", json["id_str"].stringValue)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "Tweet.matchTweet == db inconsistency")
                return matches[0]
            }
        } catch {
            throw error
            // may need more effort
        }
        
        return Tweet.createTweet(with: json, in: context)
        // WHY
    }
}
