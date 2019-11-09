//
//  UserLocation.swift
//  SPWeatherApp
//
//  Created by Aaron Tang on 9/11/19.
//  Copyright © 2019 Aaron Tang. All rights reserved.
//

import Foundation
import CoreData

@objc(UserLocation)
public class UserLocation: NSManagedObject {

}

extension UserLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserLocation> {
        return NSFetchRequest<UserLocation>(entityName: "UserLocation")
    }

    @NSManaged public var areaName: String?
    @NSManaged public var country: String?
    @NSManaged public var region: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var weatherUrl: String?

}
