//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Ahmed Elgendy on 02/08/2017.
//  Copyright © 2017 Viantex Bilişim. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
