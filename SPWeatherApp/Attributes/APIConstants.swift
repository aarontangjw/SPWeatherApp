//
//  Constants.swift
//  SPWeatherApp
//
//  Created by Aaron Tang on 9/11/19.
//  Copyright © 2019 Aaron Tang. All rights reserved.
//

import Foundation

struct APIConstants {
    static let API_KEY          =   "key"
    static let format           =   "format"
    static let numOfDays        =   "num_of_days"
    static let searchParam      =   "q"
    static let contentType      =   "contentType"
    
}

struct DBConstants {
    static let userLocation = "UserLocation"
}

struct ErrorConstant {
    static let tag = 91
}

struct LocationConstant {
    
    static let areaName    = "areaName"
    static let country     = "country"
    static let region      = "region"
    static let latitude    = "latitude"
    static let longitude   = "longitude"
    static let population  = "population"
    static let weatherUrl  = "weatherUrl"
    static let viewDateTime  = "viewDateTime"
}
