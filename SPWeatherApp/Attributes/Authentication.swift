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
    
    var authToken           : String
    var userId              : String
    var username            : String
    var contentType         : String
    var API_KEY             : String
    var format              : String
    
    
    init() {
        self.authToken      = ""
        self.userId         = ""
        self.username       = ""
        self.contentType    = "application/json"
        self.API_KEY        = "00c3bcbc4ac348e49d2131029190811"
        self.format         = "json"
        
    }
}
