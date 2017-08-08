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
    let createdAt:String!
    let updatedAt:String!
    //var ACL:Acl
    
   // static var students = [Student]()

    
    init(dictionary : [String:AnyObject]) {
        objectId = dictionary[Client.ResponseKeys.objectId] as? String ?? ""
        uniqueKey = dictionary[Client.ResponseKeys.uniqueKey] as? String ?? ""
        firstName = dictionary[Client.ResponseKeys.firstName] as? String ?? ""
        lastName = dictionary[Client.ResponseKeys.lastName] as? String ?? ""
        mapString = dictionary[Client.ResponseKeys.mapString] as? String ?? ""
        mediaURL = dictionary[Client.ResponseKeys.mediaURL] as? String ?? ""
        latitude = dictionary[Client.ResponseKeys.latitude] as? Double ?? 0.0
        longitude = dictionary[Client.ResponseKeys.longitude] as? Double ?? 0.0
        createdAt = dictionary[Client.ResponseKeys.createdAt] as? String ?? ""
        updatedAt = dictionary[Client.ResponseKeys.updatedAt] as? String ?? ""
    }
    
    static func studentsFromResult(_ result: [[String:AnyObject]]){
        for item in result{
            StudentData.shared.students.append(Student(dictionary: item))
        }
    }
    
}
