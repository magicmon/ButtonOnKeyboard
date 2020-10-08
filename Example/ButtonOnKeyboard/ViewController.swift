//
//  ViewController.swift
//  ButtonOnKeyboard
//
//  Created by magicmon on 10/07/2020.
//  Copyright (c) 2020 magicmon. All rights reserved.
//

import UIKit
import ButtonOnKeyboard

class ViewController: UIViewController {
    @IBOutlet private weak var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        button.buttonOnKeyboard(defaultButtonHeight: 50)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     @objc
     func keyboardWillShow(_ notification: Notification) {
         if self.view.window == nil {
             return
         }
         
         var visibleHeight: CGFloat = 0
         
         if let userInfo = notification.userInfo {
             if let windowFrame = UIApplication.shared.keyWindow?.frame, let keyboardRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                 visibleHeight = windowFrame.intersection(keyboardRect).height
             }
         }
         
         let keyboardHeight = visibleHeight
        
        
        button.buttonOnKeyboard(defaultButtonHeight: 50, keyboardHeight: keyboardHeight)
     }
     
     @objc
     func keyboardWillHide(_ notification: Notification) {
         if self.view.window == nil {
             return
         }
        button.buttonOnKeyboard(defaultButtonHeight: 50, keyboardHeight: 0)
     }
}

