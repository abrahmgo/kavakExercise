//
//  professionsTableViewController.swift
//  kavakExercise
//
//  Created by Andrés Bonilla on 12/3/19.
//  Copyright © 2019 Andrés Abraham Bonilla Gómez. All rights reserved.
//

import UIKit

class professionsTableViewController: UITableViewController {

    var infoGnome : gnome?
    var professions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    func initView()
    {
        if infoGnome!.professions.count != 0
        {
            professions = infoGnome!.professions
        }
        else
        {
            professions = ["Unemployed"]
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return professions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! professionTableViewCell
        cell.title.text = professions[indexPath.row].trimmingCharacters(in: .whitespaces)
        cell.showImage.image = UIImage(named: professions[indexPath.row].trimmingCharacters(in: .whitespaces))
        // Configure the cell...

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62.0
    }
}
