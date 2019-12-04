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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    @IBAction func showCitizens(_ sender: Any) {
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "citizens") as! ViewController
        self.navigationController?.pushViewController(VC1, animated: true)
    }
    
    @IBAction func goFavorites(_ sender: Any) {
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "citizens") as! ViewController
        VC1.useFlag = 2
        self.navigationController?.pushViewController(VC1, animated: true)
        
    }
}
