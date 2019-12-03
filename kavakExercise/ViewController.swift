//
//  ViewController.swift
//  kavakExercise
//
//  Created by Andrés Abraham Bonilla Gómez on 12/2/19.
//  Copyright © 2019 Andrés Abraham Bonilla Gómez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let apiManagement = api(url: "https://raw.githubusercontent.com/rrafols/mobile_test/master/data.json")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiManagement.downloadData { (status, info) in
            if status != 200
            {
                print("algo salio mal")
            }
            else
            {
                self.cleanData(data: info)
            }
        }
    }

    func cleanData(data:[String:Any])
    {
        if let info = data["Brastlewark"] as? [[String:Any]]
        {
            apiManagement.cleanGnomes(data: info) { (gnomes) in
                print(gnomes)
            }
        }
    }

}

