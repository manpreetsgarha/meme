//
//  MemeDetailViewController.swift
//  Meme
//
//  Created by Manpreet Singh on 29/11/18.
//  Copyright © 2018 Manpreet Singh. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    var meme: Meme?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        imageView.image = meme?.memedImage
    }
}
