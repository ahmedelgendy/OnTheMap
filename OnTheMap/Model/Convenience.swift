//
//  Convenience.swift
//  OnTheMap
//
//  Created by Ahmed Elgendy on 03/08/2017.
//  Copyright © 2017 Viantex Bilişim. All rights reserved.
//

import Foundation


extension Client{
    
    func getStudents(_ completion: @escaping (_ result: AnyObject?, _ error: NSError?)->Void){
        
        let params = ["limit":100 as AnyObject, "order" : "updatedAt"] as [String : AnyObject]
        
        _ = taskForGetMethod(Client.Methods.StudentLocations, params){
            (result, error) in
            if let studentsArray = result?["results"] as? [[String:AnyObject]] {
                Student.studentsFromResult(studentsArray)
                completion(studentsArray as AnyObject, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func postStudentLocation(completion: @escaping (_ success: Bool, _ error: String)->Void){
        let user = User()
        _ = taskForPostMethod(Client.Methods.StudentLocations, body: user.dictionary as [String:AnyObject], {
            (response,error) in
            if error != nil {
                completion(false, "could not post location")
                return
            }
            print("postStudentLocation", response!)

            guard let objectId = response?["objectId"] as? String else{
                return
            }
            
            Client.objectId = objectId
            Client.isLocationPosted = true
            completion(true,"")
        })
    }
}
