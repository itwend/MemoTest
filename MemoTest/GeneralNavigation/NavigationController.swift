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
    
    func setupNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        view.backgroundColor = UIColor.clear
        let font = UIFont(name: "Avenir-Light-Bold", size: 18.0) ?? UIFont.systemFont(ofSize: 25.0)
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.rgbStringToUIColor("240 240 240"), NSAttributedString.Key.backgroundColor:UIColor.clear, NSAttributedString.Key.font: font]
    }
    
}
