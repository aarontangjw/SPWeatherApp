//
//  searchViewModel.swift
//  SPWeatherApp
//
//  Created by Aaron Tang on 9/11/19.
//  Copyright © 2019 Aaron Tang. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class searchViewModel {
    var locations : [Location] = []
    var userLocations: [NSManagedObject] = []
    
    
    func searchLocation(_ typedLocation: String , _ completion: @escaping (_ success: Bool, _ response: [Location], _ error: NSError?) -> Void) {
        
        let partialURL: String = "search.ashx"
        
        let parameters: [String : AnyObject] = [APIConstants.API_KEY: Authentication.sharedInstance.API_KEY as AnyObject ,
                                                APIConstants.searchParam : typedLocation as AnyObject,
                                                APIConstants.format : Authentication.sharedInstance.format as AnyObject
                                                ]
        let requestData: [String: Any] = [APIServices.KEY_PARTIAL_URL: partialURL,
                                          APIServices.KEY_PARAMETERS: parameters]
        
        
        var locations : [Location] = []

        APIServices().get(requestData) { (success, response, error) -> Void in
            
            if success {
                 let resultObject = response

                 if let value = resultObject as? [String:AnyObject]{
                    if let errorMsg = value["data"] as? NSDictionary{
                        completion (false, locations, error)
                    }else if let resultArray = value["search_api"]! as? NSDictionary{
                        print(resultArray);
                         if let resultDic = resultArray["result"] as? NSArray{

                             for resultArray in resultDic as [AnyObject] {
                                var location : Location = Location()
                                print(resultArray)

                                let areaArray = resultArray[LocationConstant.areaName] as! NSArray
                                let areaDic = areaArray[0] as! NSDictionary
                               location.areaName  = areaDic["value"] as! String


                                let countryArray = resultArray[LocationConstant.country] as! NSArray
                                let countryDic = countryArray[0] as! NSDictionary
                                location.country = countryDic["value"] as! String

                                let regionArray = resultArray[LocationConstant.region] as! NSArray
                                let regionDic = regionArray[0] as! NSDictionary
                                location.region = regionDic["value"] as! String

                                let weatherURLArray = resultArray[LocationConstant.weatherUrl] as! NSArray
                                let weatherURLDic = weatherURLArray[0] as! NSDictionary
                                location.weatherUrl = weatherURLDic["value"] as! String

                                location.latitude = resultArray[LocationConstant.latitude] as! String
                                location.longitude = resultArray[LocationConstant.longitude] as! String
                                location.population = resultArray[LocationConstant.population] as! String

                                locations.append(location)
                            }
                        }
                    }
                }
                self.locations = locations
                
                print(locations)
                print(locations.count)
                completion (success,locations, error)
            } else {
                completion (false, locations, error)
            }
        }
    }
    
    func getUserLocations() throws  {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext

        let getRequest = NSFetchRequest<NSManagedObject>(entityName: "UserLocation")

        getRequest.fetchOffset = 0
        getRequest.fetchLimit = 10
        getRequest.sortDescriptors = [NSSortDescriptor(key: "viewDateTime", ascending: false)]
        
        do {
            self.userLocations = try managedContext.fetch(getRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        for userLocation in self.userLocations  {
            let location : Location = Location()
            
            location.areaName =  (userLocation.value(forKeyPath: "areaName") as? String)!
            location.country  = (userLocation.value(forKeyPath: "country") as? String)!
            location.region   = (userLocation.value(forKeyPath: "region") as? String)!
            location.latitude = (userLocation.value(forKeyPath: "latitude") as? String)!
            location.longitude      = (userLocation.value(forKeyPath: "longitude") as? String)!
            location.weatherUrl     = (userLocation.value(forKeyPath: "weatherUrl") as? String)!
            location.viewDateTime   = (userLocation.value(forKeyPath: "viewDateTime") as? Date)!
            
            self.locations.append(location)
        }
        self.locations.sort(by: {$0.viewDateTime.compare($1.viewDateTime) == .orderedAscending})
    }
    
    func insertLocation(location : Location) throws {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }

        let managedContext =
            appDelegate.persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: DBConstants.userLocation, in: managedContext)!
        let userLocation = NSManagedObject(entity: entity, insertInto: managedContext)
        
        userLocation.setValue(location.areaName, forKeyPath: LocationConstant.areaName)
        userLocation.setValue(location.country, forKeyPath: LocationConstant.country)
        userLocation.setValue(location.latitude, forKeyPath: LocationConstant.latitude)
        userLocation.setValue(location.longitude, forKeyPath: LocationConstant.longitude)
        userLocation.setValue(location.weatherUrl, forKeyPath: LocationConstant.weatherUrl)
        userLocation.setValue(location.region, forKeyPath: LocationConstant.region)

        do {
            try managedContext.save()

        } catch let error as NSError {
            print("Could not save. \(error)")
        }
    }
}

