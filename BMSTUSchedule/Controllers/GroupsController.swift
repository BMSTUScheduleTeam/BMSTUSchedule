//
//  GroupsController.swift
//  BMSTUSchedule
//
//  Created by Artem Belkov on 27/10/2016.
//  Copyright © 2016 techpark-iOS. All rights reserved.
//

import UIKit

class GroupsController: UITableViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var groups: [Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Menu button
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Remove empty cells
        tableView.tableFooterView = UIView()
        
        // Load groups
        Manager.firebaseManager.getGroups { (groups: [Group]) in
            
            // Set groups
            self.groups = groups
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupCell
        cell.selectionStyle = .none
        
        let group = self.groups[indexPath.row]
        
        // Save current group
        if let currentGroup = Manager.manager.currentGroup {
            if group == currentGroup {
                // Select cell
            }
        }
        
        // Set group info
        cell.nameLabel.text = group.name
        cell.courseLabel.text = String(format:"%d курс", group.course)

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Set new current group
        let group = self.groups[indexPath.row]
        Manager.manager.currentGroup = group
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

        // Deselect cell
    }
    

    // MARK: - Memory
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
