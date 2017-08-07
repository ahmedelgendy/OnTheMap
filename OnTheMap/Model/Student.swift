//
//  Student.swift
//  OnTheMap
//
//  Created by Ahmed Elgendy on 30/07/2017.
//  Copyright © 2017 Viantex Bilişim. All rights reserved.
//

import Foundation

struct Student {
    let objectId:String
    let uniqueKey:String
    let firstName:String
    let lastName:String
    let mapString:String
    let mediaURL:String
    let latitude:Double
    let longitude:Double
    let createdAt:AnyObject!
    let updatedAt:AnyObject!
    //var ACL:Acl
    
    init(dictionary : [String:AnyObject]) {
        objectId = dictionary[Client.ResponseKeys.objectId] as! String
        uniqueKey = dictionary[Client.ResponseKeys.uniqueKey] as! String
        firstName = dictionary[Client.ResponseKeys.firstName] as! String
        lastName = dictionary[Client.ResponseKeys.lastName] as! String
        mapString = dictionary[Client.ResponseKeys.mapString] as! String
        mediaURL = dictionary[Client.ResponseKeys.mediaURL] as! String
        latitude = dictionary[Client.ResponseKeys.latitude] as! Double
        longitude = dictionary[Client.ResponseKeys.longitude] as! Double
        createdAt = dictionary[Client.ResponseKeys.createdAt] as AnyObject
        updatedAt = dictionary[Client.ResponseKeys.updatedAt] as AnyObject
    }
    
    static func studentsFromResult(_ result: [[String:AnyObject]]){
        for item in result{
            Client.students.append(Student(dictionary: item))
        }
    }
    
}
