//
//  StudentData.swift
//  OnTheMap
//
//  Created by Ahmed Elgendy on 08/08/2017.
//  Copyright © 2017 Viantex Bilişim. All rights reserved.
//

import Foundation

class StudentData {
    var students = [Student]()
    static let shared = StudentData()
    private init() {}
}
