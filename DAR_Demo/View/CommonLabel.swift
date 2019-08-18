//
//  CommonLabel.swift
//  DAR_Demo
//
//  Created by Dariga Akhmetova on 8/18/19.
//  Copyright © 2019 Dariga Akhmetova. All rights reserved.
//

import UIKit

class CommonLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func setup() {
        self.font = CustomFont.marion
        self.textColor = CustomColor.violetDark
    }
}
