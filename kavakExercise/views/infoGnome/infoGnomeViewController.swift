//
//  infoGnomeViewController.swift
//  kavakExercise
//
//  Created by Andrés Bonilla on 12/3/19.
//  Copyright © 2019 Andrés Abraham Bonilla Gómez. All rights reserved.
//

import UIKit

class infoGnomeViewController: UIViewController, segmentControlDelegate {

    
    @IBOutlet var selector: segmentControl!
    
    var infoGnome : gnome?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        // Do any additional setup after loading the view.
    }
    
    func initView()
    {
        selector.delegate = self
        selector.setButtonTitles(buttonTitles: ["Info","Friends","Jobs"])
        selector.backgroundColor = .clear
        if infoGnome != nil
        {
            print(infoGnome!)
        }
    }
    
    func changeToIndex(index: Int) {
        print(index)
    }
    

}
