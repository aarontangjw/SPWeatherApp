//
//  Constants.swift
//  SPWeatherApp
//
//  Created by Aaron Tang on 9/11/19.
//  Copyright © 2019 Aaron Tang. All rights reserved.
//

import Foundation

struct Constants {
    
}

struct APIConstants {
    static let API_KEY          =   "key"
    static let format           =   "format"
    static let numOfDays        =   "num_of_days"
    static let searchParam      =   "q"
    static let xauthorization   =   "X-Authorization"
    static let contentType      =   "contentType"
    
}


struct DBConstants {
    static let userLocation = "UserLocation"
}

struct GeneralConstants {
    static let noNetworkViewIdentifier = "NoNetworkView"
    static let noLoginViewIdentifier   = "NoLoginView"
}

struct ErrorConstant {
    static let tag = 91
}

struct MessageStrings{
    
    static let errorTitle = "Error"
    static let networkErrorTitle = "Network Error"
    
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
