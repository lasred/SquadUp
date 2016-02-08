//
//  SportViewController.swift
//  SquadUp-iOS
//
//  Created by Shaheen Sharifian on 2/3/16.
//  Copyright © 2016 Shaheen Sharifian. All rights reserved.
//

import UIKit

class SportViewController: UIViewController {

    @IBOutlet weak var sportLabel: UILabel!
    @IBOutlet weak var backgroundImage:UIImageView!
    var passedLabel: String!
    var passedImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        sportLabel.text = passedLabel
        backgroundImage.image = passedImage
    }

}
