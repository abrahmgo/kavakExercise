//
//  filter.swift
//  kavakExercise
//
//  Created by Andrés Abraham Bonilla Gómez on 12/3/19.
//  Copyright © 2019 Andrés Abraham Bonilla Gómez. All rights reserved.
//

import UIKit

class filter: UIView {

    @IBOutlet var container: UIView!
    @IBOutlet weak var hairDropDown: UIView!

    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        custom()
    }

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        custom()
    }

    private func custom()
    {
        Bundle.main.loadNibNamed("filter", owner: self, options: nil)
        container.frame = self.bounds
        container.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
        addSubview(container)
    }


}
