//
//  friendsTableViewController.swift
//  kavakExercise
//
//  Created by Andrés Bonilla on 12/3/19.
//  Copyright © 2019 Andrés Abraham Bonilla Gómez. All rights reserved.
//

import UIKit

class friendsTableViewController: UITableViewController {

    var infoGnome : gnome?
    var friends = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func initView()
    {
        if infoGnome!.friends.count != 0
        {
            friends = infoGnome!.friends
        }
        else
        {
            friends = ["Alone"]
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friends.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = friends[indexPath.row]
        // Configure the cell...

        return cell
    }
    
}
