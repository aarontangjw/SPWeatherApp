//
//  APIServices.swift
//  SPWeatherApp
//
//  Created by Aaron Tang on 9/11/19.
//  Copyright © 2019 Aaron Tang. All rights reserved.
//

import Foundation

enum HTTPCodes: NSInteger {
    case success                = 200
    case successCreated         = 201
    case noContent              = 204
    case badRequest             = 400
    case unauthorized           = 401
    case forbidden              = 403
    case notFound               = 404
    case methodNotAllowed       = 405
    case requestTimeout         = 408
    case internalServerError    = 500
    case badGateway             = 502
    case serviceUnavailable     = 503
}

class APIServices: NSObject {
    
    static let KEY_FULL_URL             = "FullURL"
    static let KEY_PARTIAL_URL          = "PartialURL"
    static let KEY_PARAMETERS           = "Parameters"
    static var BASE_URL: String         = ""
    static var BASE_URL_IMAGE: String   = ""
    
    static var BASE_URL_IDENTIFIER: String = "BASE_URL"
    static var BASE_URL_IMAGE_IDENTIFIER: String = "BASE_URL_IMAGE"

    override init() {
        APIServices.BASE_URL = "http://api.worldweatheronline.com/premium/v1/"
        APIServices.BASE_URL_IMAGE = ""
    }
    

    func get(_ data: [AnyHashable: Any], onCompletion: @escaping (_ success: Bool, _ response: AnyObject, _ error: NSError) -> Void) {
        
        var fullURL = ""
        var partialURL = ""
        let parameters  = data[APIServices.KEY_PARAMETERS] as! [String : AnyObject]
        var contantType : String = ""
        
        partialURL = data[APIServices.KEY_PARTIAL_URL] as! String

        contantType = Authentication.sharedInstance.contentType
        fullURL     = "\(APIServices.BASE_URL)\(partialURL)"
        
        var requestHeaders : [String: String] = [:]
        requestHeaders = [
            APIConstants.contentType       :   contantType,
        ]
        // let error : NSError = NSError(domain: "Error", code: statusCode, userInfo: nil)
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
                
                switch statusCode{
                case HTTPCodes.success.rawValue:
                    print("Success")
                    let error: NSError = NSError(domain: "No Error", code: statusCode, userInfo: nil)
                    
                    do{
                        //here dataResponse received from a network request
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
    
    
    
    public func post(_ data: [AnyHashable: Any], _ completion: @escaping (_ success: Bool, _ response: AnyObject, _ error: NSError?) -> Void) {
        let error = NSError(domain: "com.example.error", code: 0, userInfo: [NSLocalizedDescriptionKey: "message"])
        
        var fullURL = ""
        var partialURL = ""
        let parameters  = data[APIServices.KEY_PARAMETERS] as! [String : AnyObject]
        
        var contantType : String = ""
        
        partialURL = data[APIServices.KEY_PARTIAL_URL] as! String
        
        fullURL     = "\(APIServices.BASE_URL)\(partialURL)"
        
        guard let url = URL(string: fullURL) else {
            completion (false, error, error)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task =   URLSession.shared.dataTask(with: request as URLRequest){ data, response, error  in
            
            if let error = error {
                print("error: \(error)")
            } else {
                
                
                if let response = response as? HTTPURLResponse {
                    print("statusCode: \(response.statusCode)")
                    
                    let statusCode : NSInteger = response.statusCode
                    print("http.code: \(statusCode)")
                    
                    switch statusCode{
                    case HTTPCodes.success.rawValue:
                        print("Success")
                        let error: NSError = NSError(domain: "No Error", code: statusCode, userInfo: nil)
                        completion(true, response as AnyObject , error)
                    case HTTPCodes.unauthorized.rawValue :
                        let error: NSError = NSError(domain: "Authorization Error", code: statusCode, userInfo: nil)
                        print("Authorization Failure: \(error)")
                        completion(false,error,error)
                        
                    default:
                        print("Failure")
                        let error : NSError = NSError(domain: "Error", code: statusCode, userInfo: nil)
                        completion(false,error,error)
                    }
                }
            }
        }
        task.resume()
    }
    
}
