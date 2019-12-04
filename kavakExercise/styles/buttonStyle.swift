//
//  buttonStyle.swift
//  kavakExercise
//
//  Created by Andrés Bonilla on 12/4/19.
//  Copyright © 2019 Andrés Abraham Bonilla Gómez. All rights reserved.
//

import UIKit

class buttonStyle: UIButton {

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
        self.layer.cornerRadius = 28
        self.titleLabel?.font = .systemFont(ofSize: 22)
        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.textAlignment = .center
        self.backgroundColor = UIColor(hexString: "#ADCACC")
    }
}
