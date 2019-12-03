//
//  infoTableViewController.swift
//  kavakExercise
//
//  Created by Andrés Bonilla on 12/3/19.
//  Copyright © 2019 Andrés Abraham Bonilla Gómez. All rights reserved.
//

import UIKit

class infoTableViewController: UITableViewController {

    var infoGnome : gnome?
    private var info = [String]()
    private var titles = ["Name","Height","Weight","Age","Hair"]
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    func initView()
    {
        info.append(infoGnome!.name)
        info.append(String(infoGnome!.height))
        info.append(String(infoGnome!.weight))
        info.append(String(infoGnome!.age))
        info.append(infoGnome!.hairColor)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return info.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = titles[indexPath.row]+":" + " " + info[indexPath.row]
        return cell
    }
    
}
