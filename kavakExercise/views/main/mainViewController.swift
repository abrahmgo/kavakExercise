//
//  mainViewController.swift
//  kavakExercise
//
//  Created by Andrés Bonilla on 12/4/19.
//  Copyright © 2019 Andrés Abraham Bonilla Gómez. All rights reserved.
//

import UIKit

class mainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func showCitizens(_ sender: Any) {
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "citizens") as! ViewController
        self.navigationController?.pushViewController(VC1, animated: true)
    }
    
}
