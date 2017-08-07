//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Ahmed Elgendy on 30/07/2017.
//  Copyright © 2017 Viantex Bilişim. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    var keyboardOnScreen = false

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var newUserButton: UIButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUIEnabled(true)
    }
    override func viewDidLoad() {
        configureKeyboard()
        configureUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            self.presentAlert(title: "Login Error", message: "Username or Password Empty.", actionTitle: "ok")
        } else {
            setUIEnabled(false)
            Indicator.shared.showIndicator(view: view)
            let params = ["username":usernameTextField.text!,"password":passwordTextField.text!] as [String:AnyObject]
            
            Client.shared().letsLogin(params){
                (result,errorString) in
                performUIUpdatesOnMain{
                    if result{
                        Indicator.shared.hideIndicator(view: self.view)
                        self.completeLogin()
                    }else{
                        self.setUIEnabled(true)
                        Indicator.shared.hideIndicator(view: self.view)
                        self.presentAlert(title: "Login Error", message: errorString!, actionTitle: "ok")
                    }
                }

            }
        }
    }
    
    @IBAction func newUser(_ sender: Any){
        Client.shared().openURL(Client.Constants.RegisterURL){
            (success) in
            
        }

    }
    
    @IBAction func userDidTapView(_ sender: AnyObject) {
        resignIfFirstResponder(usernameTextField)
        resignIfFirstResponder(passwordTextField)
    }
    
    private func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    func completeLogin(){
        let controller = storyboard!.instantiateViewController(withIdentifier: "TabBarVCNav")
        present(controller, animated: false, completion: nil)
    }
}

// LoginViewController (Configure UI)
extension LoginViewController{
    
    func setUIEnabled(_ enabled: Bool) {
        usernameTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginBtn.isEnabled = enabled
        debugTextLabel.text = ""
        debugTextLabel.isEnabled = enabled
        newUserButton.isEnabled = enabled
        // adjust login button alpha
        if enabled {
            loginBtn.alpha = 1.0
        } else {
            loginBtn.alpha = 0.5
        }
    }
    
    func configureUI(){
        configureTextField(usernameTextField)
        configureTextField(passwordTextField)
    }
    
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
            debugTextLabel.text = errorString
        }
    }
    
}

// MARK: TextDelegates

extension LoginViewController: UITextFieldDelegate{

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func configureTextField(_ textField:UITextField){
        textField.delegate = self
    }
    
    
}

// MARK: Show/Hide Keyboard
private extension LoginViewController{
    
    func configureKeyboard(){
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if !keyboardOnScreen{
            view.frame.origin.y -= (keyboardHeight(notification)*50/100)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if keyboardOnScreen {
            view.frame.origin.y += (keyboardHeight(notification)*50/100)
        }
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        keyboardOnScreen = true
    }
    
    @objc func keyboardDidHide(_ notification: Notification) {
        keyboardOnScreen = false
    }
    
    private func keyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
}

// MARK: - LoginViewController (Notifications)

private extension LoginViewController {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}


