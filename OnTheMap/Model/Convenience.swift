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
        
        let params = ["limit":100 as AnyObject, "order" : "-updatedAt"] as [String : AnyObject]
        
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
    
    func postStudentLocation(completion: @escaping (_ success: Bool, _ error: String?)->Void){
        
        let user = User()

        
        let url =  URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!
        
        let request = NSMutableURLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue(Client.Constants.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Client.Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try? JSONSerialization.data(withJSONObject: user.dictionary)

        request.httpBody = jsonData
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                completion(false, "There was an error with your request")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                completion(false, "There was an error with your request")
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: {
                (data, error) in
                print("postStudentLocation ", data as Any)
                if error != nil {
                    completion(false, "could not post location")
                    return
                }
                
                guard let objectId = data?["objectId"] as? String else{
                    return
                }
                
                Client.objectId = objectId
                Client.isLocationPosted = true
                completion(true,nil)
            })
            
        }
        task.resume()
        
    }
}
