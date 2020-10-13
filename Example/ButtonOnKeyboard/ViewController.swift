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
    @IBOutlet private weak var buttonHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        button.bk_defaultButtonHeight = buttonHeightConstraint.constant  // Stores the default size of the button.
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        var visibleHeight: CGFloat = 0
         
        if let userInfo = notification.userInfo {
            if let windowFrame = UIApplication.shared.keyWindow?.frame,
                let keyboardRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                visibleHeight = windowFrame.intersection(keyboardRect).height
            }
        }
        
        button.bk_onKeyboard(keyboardHeight: visibleHeight)
    }
     
    @objc func keyboardWillHide(_ notification: Notification) {
        button.bk_onKeyboard(keyboardHeight: 0)
    }
}

