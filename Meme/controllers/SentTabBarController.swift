//
//  SentTabBarController.swift
//  Meme
//
//  Created by Manpreet Singh on 31/12/18.
//  Copyright © 2018 Manpreet Singh. All rights reserved.
//

import Foundation
import UIKit

class SentTabBarController: UITabBarController {
    @IBAction func unwindToSentTabBarControllers(segue: UIStoryboardSegue) {
        if selectedViewController is UINavigationController {
            (selectedViewController as! UINavigationController).popToRootViewController(animated: false)
        }
    }
}
