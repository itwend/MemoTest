//
//  NavigationController.swift
//  MemoTest
//
//  Created by Andrew on 11/28/17.
//  Copyright © 2017 Andrew Gerbovtsan. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
}

extension UINavigationController {
    
    func setupNavigationBar() {
        navigationBar.tintColor = UIColor.rgbStringToUIColor("0 0 0")
        navigationBar.barTintColor = UIColor.rgbStringToUIColor("255 255 255")
        navigationBar.isTranslucent = false
        let font = UIFont(name: "Avenir-Light-Bold", size: 18.0) ?? UIFont.systemFont(ofSize: 18.0)
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.rgbStringToUIColor("0 0 0"), NSAttributedStringKey.backgroundColor:UIColor.init(white: 1, alpha: 0.9), NSAttributedStringKey.font: font]
    }
}
