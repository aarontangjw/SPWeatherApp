//
//  APIServices.swift
//  SPWeatherApp
//
//  Created by Aaron Tang on 9/11/19.
//  Copyright © 2019 Aaron Tang. All rights reserved.
//

import Foundation

class APIServices: NSObject {
    
    static let KEY_FULL_URL             = "FullURL"
    static let KEY_PARTIAL_URL          = "PartialURL"
    static let KEY_PARAMETERS           = "Parameters"
    static var BASE_URL: String         = ""
    static var BASE_URL_IMAGE: String   = ""
    
    static var BASE_URL_IDENTIFIER: String = "BASE_URL"
    static var BASE_URL_IMAGE_IDENTIFIER: String = "BASE_URL_IMAGE"

    //Calling the worldweatheronline API
    override init() {
        APIServices.BASE_URL = "http://api.worldweatheronline.com/premium/v1/"
        APIServices.BASE_URL_IMAGE = ""
    }
    
    /*https://learnappmaking.com/urlsession-swift-networking-how-to/
    https://medium.com/@alfianlosari/building-simple-async-api-request-with-swift-5-
    result-type-alfian-losari-e92f4e9ab412*/
    
    enum HTTPCodes: NSInteger {
        case success                = 200
        case unauthorized           = 401
        case serviceUnavailable     = 503
    }
    
    //HTTP JSON Requests
    func get(_ data: [AnyHashable: Any], onCompletion: @escaping (_ success: Bool, _ response: AnyObject, _ error: NSError) -> Void) {
        
        var fullURL = ""
        var partialURL = ""
        let parameters  = data[APIServices.KEY_PARAMETERS] as! [String : AnyObject]
        partialURL = data[APIServices.KEY_PARTIAL_URL] as! String
        fullURL     = "\(APIServices.BASE_URL)\(partialURL)"
        
        /*var requestHeaders : [String: String] = [:]
        requestHeaders = [
            APIConstants.contentType       :   contantType,
        ]*/
        
        /*let url = URL(string: "https://exampleapi.com/data.json")!
        URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                 // Handle Error
                 return
             }
             guard let response = response else {
                 // Handle Empty Response
                 return
             }
             guard let data = data else {
                 // Handle Empty Data
                 return
             }
             // Handle Decode Data into Model
        }*/

        let error = NSError(domain: "Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "message"])
        
        guard let componentsUrl = NSURLComponents(string: fullURL) else {
            onCompletion (false, error, error)
            return
        }
        
        
        componentsUrl.queryItems = [
            URLQueryItem(name: APIConstants.API_KEY, value:  parameters[APIConstants.API_KEY] as? String) ,
            URLQueryItem(name: APIConstants.searchParam , value: parameters[APIConstants.searchParam] as? String),
            URLQueryItem(name: APIConstants.format, value:  parameters[APIConstants.format] as? String),
            
        ]
        
        let request = URLRequest(url: componentsUrl.url!)
        let task =   URLSession.shared.dataTask(with: request as URLRequest){ data, response, error  in
            guard error == nil else {
                onCompletion(false, error as AnyObject, error! as NSError)
                return
            }

            if let response = response as? HTTPURLResponse {
                print("statusCode: \(response.statusCode)")
                
                let statusCode : NSInteger = response.statusCode
                print("http.code: \(statusCode)")
                
                //To check status of JSON Get requests
                switch statusCode{
                case HTTPCodes.success.rawValue:
                    print("Success")
                    let error: NSError = NSError(domain: "No Error", code: statusCode, userInfo: nil)
                    
                    do{
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: [])
                        print(jsonResponse) //Response result
                        
                        onCompletion(true, jsonResponse as AnyObject , error)
                    } catch let parsingError {
                        print("Error", parsingError)
                    }
                                        
                case HTTPCodes.unauthorized.rawValue :
                    let error: NSError = NSError(domain: "Authorization Error", code: statusCode, userInfo: nil)
                    print("Authorization Failure: \(error)")
                    onCompletion(false,error,error)
                    
                default:
                    print("Failure")
                    let error : NSError = NSError(domain: "Error", code: statusCode, userInfo: nil)
                     onCompletion(false,error,error)
                }
            }            
        }
        task.resume()
    }
}
