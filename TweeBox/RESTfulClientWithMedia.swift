//
//  RESTfulClientWithMedia.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/31.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import TwitterKit

class RESTfulClientWithMedia {
    
    var imageData: Data
    
    private var type: String {
        return imageData.MIMEType
    }
    
    
    init(imageData: Data) {
        self.imageData = imageData
    }

    
    func getData(_ handler: @escaping (String?) -> Void) {
        
        if let userID = Twitter.sharedInstance().sessionStore.session()?.userID {
            
            let client = TWTRAPIClient(userID: userID)
            
            print(">>> type >> \(type)")
            
            client.uploadMedia(imageData, contentType: type, completion: { (mediaID, error) in
                
                guard error == nil else {
                    print(">>> client error >> \(error.debugDescription)")
                    return
                }
                
                if let mediaID = mediaID {
                    handler(mediaID)
                } else {
                    handler(nil)
                }
            })
        }

    }
}
