//
//  UIAlertController+Helpers.swift
//  MemoTest
//
//  Created by Andrew on 11/29/17.
//  Copyright © 2017 Andrew Gerbovtsan. All rights reserved.
//

import UIKit

enum AlertControllerTextFieldType: Int {
    case standart
    case sound = 301
}

extension UIAlertController {
    
    class func showSimple(_ target: AnyObject?, title: String?, message: String?) {
        let alert = UIAlertController(title:title, message:message, preferredStyle: .alert)
        alert.view.tintColor  = UIColor.rgbStringToUIColor("128 0 0")
        alert.addAction(UIAlertAction(title:"OK", style: .default, handler:{
            action in
        }))
        if let viewController = target as? UIViewController {
            viewController.present(alert, animated:true, completion:nil)
        }
        else {
            if let viewController = UIViewController.getVisibleViewController(nil) {
                viewController.present(alert, animated:true, completion:nil)
            }
        }
    }
    
//    class func showSimpleOn(vc: UIViewController,_ target: AnyObject?, title: String?, message: String?) {
//
//        let alert = UIAlertController(title:title, message:message, preferredStyle: .alert)
//        alert.view.tintColor  = UIColor.rgbStringToUIColor("128 0 0")
//        alert.addAction(UIAlertAction(title:"OK", style: .default, handler:{
//            action in
//        }))
//        vc.present(alert, animated:true, completion:nil)
//    }
    
    class func showSimpleWithAutodismiss(_ target: AnyObject?, title: String?, message: String?) {
        let alert = UIAlertController(title:title, message:message, preferredStyle: .alert)
        alert.view.tintColor  = UIColor.rgbStringToUIColor("128 0 0")
        let delay = 1 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) { () -> Void in
            alert.dismiss(animated: true, completion: nil)
        }
        if let viewController = target as? UIViewController {
            viewController.present(alert, animated:true, completion:nil)
        }
        else {
            if let viewController = UIViewController.getVisibleViewController(nil) {
                viewController.present(alert, animated:true, completion:nil)
            }
        }
    }
    
    class func showSimple (_ target:AnyObject?, title:String?, message:String, buttonAction:(() -> Void)?) {
        let alert = UIAlertController(title:title, message:message, preferredStyle: .alert)
        alert.view.tintColor  = UIColor.rgbStringToUIColor("128 0 0")
        alert.addAction(UIAlertAction(title:"OK", style: .default, handler:{
            action in
            buttonAction?()
        }))
        if let viewController = target as? UIViewController {
            viewController.present(alert, animated:true, completion:nil)
        }
        else {
            if let viewController = UIViewController.getVisibleViewController(nil) {
                viewController.present(alert, animated:true, completion:nil)
            }
        }
    }
    
    class func showSimple (_ target:AnyObject?, title:String?, message:String, firstButtonTitle:String, firstButtonAction: (() -> Void)?, secondButtonTitle:String, secondButtonAction:(() -> Void)?) {
        let alert = UIAlertController(title:title, message:message, preferredStyle: .alert)
        alert.view.tintColor  = UIColor.rgbStringToUIColor("128 0 0")
        alert.addAction(UIAlertAction(title:firstButtonTitle, style: .default, handler:{
            action in
            firstButtonAction?()
        }))
        alert.addAction(UIAlertAction(title:secondButtonTitle, style: .default, handler:{
            action in
            secondButtonAction?()
        }))
        if let viewController = target as? UIViewController {
            viewController.present(alert, animated:true, completion:nil)
        }
        else {
            if let viewController = UIViewController.getVisibleViewController(nil) {
                viewController.present(alert, animated:true, completion:nil)
            }
        }
    }
    
    class func showWithTextField(_ text: String, placeholder: String?, keyboardType: UIKeyboardType?, isSecureTextEntry: Bool, target:AnyObject?, title:String?, message:String, submitButtonTitle:String, submitButtonAction: ((_ value: String?) -> Void)? ) {
        
        let alert = UIAlertController(title:title, message:message, preferredStyle: .alert)
        alert.view.tintColor  = UIColor.rgbStringToUIColor("128 0 0")
        alert.addTextField { ( textField) -> Void in
            textField.placeholder = placeholder ?? ""
            textField.autocorrectionType = .no
            textField.isSecureTextEntry = isSecureTextEntry
            textField.keyboardType = keyboardType ?? .default
            textField.keyboardAppearance = .dark
            textField.tag = textField.keyboardType == .default ? AlertControllerTextFieldType.sound.rawValue : AlertControllerTextFieldType.standart.rawValue
            textField.text = text
            textField.addTarget(self, action: #selector(alertControllerTextFieldDidChange(_:)), for: .editingChanged)
        }
        
        let submitAction = UIAlertAction(title:submitButtonTitle, style: .default, handler:{
            action in
            submitButtonAction?(alert.textFields?.first?.text)
        })
        submitAction.isEnabled = text.count > 0
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(submitAction)
        
        
        if let viewController = target as? UIViewController {
            viewController.present(alert, animated:true, completion:nil)
        }
        else {
            if let viewController = UIViewController.getVisibleViewController(nil) {
                viewController.present(alert, animated:true, completion:nil)
            }
        }
    }
    
    @objc fileprivate class func alertControllerTextFieldDidChange(_ sender: UITextField) {
        if  let alertController = UIViewController.getVisibleViewController(nil) as? UIAlertController {
            if let textField = alertController.textFields?.first, let text = textField.text {
                let requestAction = alertController.actions.last
                switch textField.tag {
                case AlertControllerTextFieldType.sound.rawValue:
                    requestAction?.isEnabled = text.isValidSoundNameLength
                default:
                    requestAction?.isEnabled = text.trimmingCharacters(in: .whitespaces).count > 0
                }
            }
        }
    }
    
}
