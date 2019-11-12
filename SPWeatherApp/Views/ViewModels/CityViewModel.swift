//
//  CityViewModel.swift
//  SPWeatherApp
//
//  Created by Aaron Tang on 9/11/19.
//  Copyright © 2019 Aaron Tang. All rights reserved.
//

import Foundation

class CityViewModel{
    var weather : Weather =  Weather()
    
    func fetchWeather(_ location: String ,_ num_of_days : Int, _ completion: @escaping (_ success: Bool, _ response: Weather, _ error: NSError?) -> Void) {
        
        let partialURL: String = "weather.ashx"
        
        let parameters: [String : AnyObject] = [APIConstants.API_KEY: Authentication.sharedInstance.API_KEY as AnyObject ,
                                                APIConstants.searchParam : location as AnyObject,
                                                APIConstants.numOfDays : num_of_days as AnyObject,
                                                APIConstants.format : Authentication.sharedInstance.format as AnyObject
        ]
        let requestData: [String: Any] = [APIServices.KEY_PARTIAL_URL: partialURL,
                                          APIServices.KEY_PARAMETERS: parameters]
        
        
        let weather : Weather = Weather()
        
        APIServices().get(requestData) { (success, response, error) -> Void in
            
            if success {
                //  let resultArray = response as! NSArray
                let resultObject = response

                if let value = resultObject as? [String:AnyObject]{
                    if let resultArray = value["data"]! as? NSDictionary{
                        
                        print(resultArray);
                        
                        if let resultDic = resultArray["current_condition"] as? NSArray{
                            print(resultDic[0])
                            
                            if resultDic.count > 0 {
                                let weatherObject : NSDictionary = resultDic[0] as! NSDictionary
                                self.weather = Weather(dictionary: weatherObject)!
                            }

                        }
                    }
                }
                
                print(weather)
               // print(locations.count)
                completion (success,self.weather , error)
            } else {
                completion (false, self.weather , error)
            }
        }
    }
}

