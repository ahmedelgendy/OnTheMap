//
//  Storage.swift
//  OnTheMap
//
//  Created by Ahmed Elgendy on 07/08/2017.
//  Copyright © 2017 Viantex Bilişim. All rights reserved.
//

import Foundation

struct User {
    static var uniqueKey:String = ""
    static var firstName:String = ""
    static var lastName:String = ""
    static var mapString:String = ""
    static var mediaURL:String = ""
    static var latitude:Double = 0.0
    static var longitude:Double = 0.0
    
    var dictionary: [String: Any] {
        return [
            "uniqueKey" : User.uniqueKey,
            "firstName" : User.firstName,
            "lastName" : User.lastName,
            "mapString": User.mapString,
            "mediaURL": User.mediaURL,
            "latitude": User.latitude,
            "longitude": User.longitude
        ]
    }
}
