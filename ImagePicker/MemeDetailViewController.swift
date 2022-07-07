//
//  MemeDetailViewController.swift
//  ImagePicker
//
//  Created by Waylon Kumpe on 7/7/22.
//  Copyright © 2022 Waylon Kumpe. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
//    MARK: Image View
    @IBOutlet weak var viewImage: UIImageView!
    
//    MARK: Meme Image Index Position
    var memedImageIndex = Int()
    
    //    MARK: Memes Collection
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewImage.image = memes[memedImageIndex].memedImage
    }
}
