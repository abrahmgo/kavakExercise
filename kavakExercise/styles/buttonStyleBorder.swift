//
//  buttonStyleBorder.swift
//  kavakExercise
//
//  Created by Andrés Bonilla on 12/4/19.
//  Copyright © 2019 Andrés Abraham Bonilla Gómez. All rights reserved.
//

import UIKit

class buttonStyleBorder: UIButton {
    
    let border = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func setupButton()
    {
        self.addBottomBorderWithColor2(color: .black, width: 2.0)
    }
    
    func addBottomBorderWithColor2(color: UIColor, width: CGFloat) {
        
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:self.frame.size.height, width:self.frame.size.width, height:width)
        self.layer.addSublayer(border)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        border.frame = CGRect(x:0, y:self.layer.frame.size.height, width: self.layer.frame.size.width, height: 2.0)
    }
}
