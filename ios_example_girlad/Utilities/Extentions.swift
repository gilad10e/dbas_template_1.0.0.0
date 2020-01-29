//
//  Extentions.swift
//  ios_example_girlad
//
//  Created by Apple on 17/01/2020.
//  Copyright © 2020 DontBeAStranger. All rights reserved.
//

import Foundation
import UIKit

extension UITextField{
    
    
      @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
      }
      
      func addDoneButtonOnKeyboard()
      {
          let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
          doneToolbar.barStyle = .default
          
          let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
          let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
          
          let items = [flexSpace, done]
          doneToolbar.items = items
          doneToolbar.sizeToFit()
          
          self.inputAccessoryView = doneToolbar
      }
      
    @objc func doneButtonAction()
      {
          self.resignFirstResponder()
      }
    
    func styleTextField(){
        self.addDoneButtonOnKeyboard()
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width , height: 2)
        bottomLine.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        self.borderStyle = .none
        self.layer.addSublayer(bottomLine)
        
    }
    
}

extension String {
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
}

extension UIImageView {

    func makeRounded() {
        self.layer.masksToBounds = true
        let imageOrientation = self.image!.imageOrientation.rawValue
        if imageOrientation == 3{
            self.layer.cornerRadius = 75
        }
        if imageOrientation == 1 || imageOrientation == 0 {
            self.layer.cornerRadius = self.bounds.width / 2
        }
    }
}

extension UIViewController {
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
    if recognizer.state == .recognized {
        navigationController?.popViewController(animated: true)
        }
    }
    
    func makeReturnWithLeftSwipe(){
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        view.addGestureRecognizer(edgePan)
    }
    
}
