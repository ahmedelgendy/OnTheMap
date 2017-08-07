//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Ahmed Elgendy on 30/07/2017.
//  Copyright © 2017 Viantex Bilişim. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    
    @IBOutlet weak var StudentsTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func reload() {
        self.StudentsTableView.reloadData()
    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let student = Client.students[(indexPath as IndexPath).row]
        let cellReuseIdentifier = "TableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        cell?.textLabel?.text = student.firstName + " " + student.lastName
        cell?.detailTextLabel?.text = student.mediaURL
        cell?.imageView?.image = UIImage(named: "icon_pin")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let student = Client.students[(indexPath as IndexPath).row]

        Client.shared().openURL(student.mediaURL){
            (success) in
            print("success: \(String(describing: success))")
            if !success!{
                self.presentAlert(title: "Error", message: "Cant open URL", actionTitle: "cancel")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Client.students.count
    }
}
