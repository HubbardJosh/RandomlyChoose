//
//  roundCornerButton.swift
//  RondomlyChoose
//
//  Created by Josh Hubbard on 7/25/17.
//  Copyright © 2017 Josh Hubbard. All rights reserved.
//

import Foundation
import UIKit

class RoundCornerButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.layer.cornerRadius = 5.0
        self.tintColor = UIColor.white
    }
}
