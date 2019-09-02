//
//  CommonButton.swift
//  DAR_Demo
//
//  Created by Dariga Akhmetova on 8/12/19.
//  Copyright © 2019 Dariga Akhmetova. All rights reserved.
//

import UIKit

class CommonButton: UIButton {
    
    var borderWidth = 2.0
    
    var titleText: String? {
        didSet {
            self.setTitle(titleText, for: .normal)
            self.setTitleColor(.white, for: .normal)
        }
    }
    
    override init(frame: CGRect){
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
        self.clipsToBounds = true
        self.backgroundColor = CustomColor.violetLight
        self.layer.cornerRadius = 10
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: (self.titleLabel?.font.pointSize)!)
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = CustomColor.violetDark
        }
    }
}
