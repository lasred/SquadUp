//
//  RatingStarContainerView.swift
//  SquadUp-iOS
//
//  Created by Shaheen Sharifian on 1/25/16.
//  Copyright © 2016 Shaheen Sharifian. All rights reserved.
//

import UIKit

class RatingStarContainerView: UIView {

    override func awakeFromNib() {
        layer.cornerRadius = 6.0
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).CGColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 8.0
        layer.shadowOffset = CGSizeMake(0, 2.0)
    }


}
