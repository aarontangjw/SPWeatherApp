//
//  Authentication.swift
//  SPWeatherApp
//
//  Created by Aaron Tang on 9/11/19.
//  Copyright © 2019 Aaron Tang. All rights reserved.
//

import Foundation

class Authentication{
    static var sharedInstance = Authentication()

    var contentType         : String
    var API_KEY             : String
    var format              : String
    
    init() {
        self.contentType    = "application/json"
        self.format         = "json"
        
        //To replace with user's API Secret Key for WorldWeatherOnline.
        self.API_KEY        = "00c3bcbc4ac348e49d2131029190811"
        
    }
}
