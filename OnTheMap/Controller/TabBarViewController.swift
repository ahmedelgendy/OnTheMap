//
//  TabBarViewController.swift
//  OnTheMap
//
//  Created by Ahmed Elgendy on 03/08/2017.
//  Copyright © 2017 Viantex Bilişim. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    let pinImage = "icon_pin"
    let refreshImage = "icon_refresh"

    //20014510 
    override func viewDidLoad() {
        super.viewDidLoad()
        drawNavBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initData()
    }
    
    func initData(){
        for i in 0...1{
            Indicator.shared.showIndicator(view: viewControllers?[i].view)
        }
        Client.shared().getStudents(){
            (result, error) in
            
            for i in 0...1{
                Indicator.shared.hideIndicator(view: self.viewControllers?[i].view)
            }
            
            if error != nil{
                performUIUpdatesOnMain {
                    self.presentAlert(title: "Data Error", message: "Can not getting data", actionTitle: "Ok")
                }
            }else{
                performUIUpdatesOnMain {
                    (self.viewControllers?[0] as! MapViewController).makeAnnotations()
                    (self.viewControllers?[1] as! TableViewController).reload()
                }
            }
        }
    }
    
    func refreshData(){
        initData()
    }
    
    func showLocationSender() {
        
        if Client.isLocationPosted {
            overritenAlert()
        }else {
            navToSendLocation()
        }
        
    }
    
    func navToSendLocation(){
        let NavController = self.storyboard?.instantiateViewController(withIdentifier: "LocationSenderNavController")
        present(NavController!, animated: true)
    }
    
    func logout() {
        Client().logout()
        dismiss(animated: true, completion: nil)
    }

    
}


// Configure Layout
extension TabBarViewController{
    
    func drawNavBar(){
        navigationItem.title = "OnTheMap"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logout))
        let pinItem =  UIBarButtonItem(image: UIImage(named:pinImage), style: UIBarButtonItemStyle.plain, target: self, action: #selector(showLocationSender))
        let refreshItem = UIBarButtonItem(image: UIImage(named:refreshImage), style: UIBarButtonItemStyle.plain, target: self, action: #selector(refreshData))
        navigationItem.rightBarButtonItems = [pinItem, refreshItem]
    }
    
    func overritenAlert() {
        
        let message = "User \(User.firstName + User.lastName) had posted his location, do you like overrite it?"
        
        let alertControllerStyle = UIAlertControllerStyle.alert
        let alertView = UIAlertController(title: nil, message: message, preferredStyle: alertControllerStyle)
        
        let alertActionStyle = UIAlertActionStyle.default
        
        let alertActionOK = UIAlertAction(title: "cancel", style: alertActionStyle, handler: nil)
        
        let alertActionOverrite = UIAlertAction(title: "overriten", style: alertActionStyle, handler: {
            (alert: UIAlertAction!) in
            self.navToSendLocation()
        })
        
        alertView.addAction(alertActionOK)
        alertView.addAction(alertActionOverrite)
        
        performUIUpdatesOnMain {
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
}
