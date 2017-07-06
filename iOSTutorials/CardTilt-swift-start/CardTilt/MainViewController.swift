//
//  MainViewController.swift
//  CardTilt
//
//  Created by Ray Fix on 6/25/14.
//  Updated by Ray Fix on 4/12/15
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    var members: [Member] = []
  
    var preventAnimation = Set<IndexPath>()
    
    // Mark: - Model
  
    func loadModel() {
        let path = Bundle.main.path(forResource: "TeamMembers", ofType: "json")
        members = Member.loadMembersFromFile(path!)
    }
  
  // Mark: - View Lifetime
  
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // appearance and layout customization
        self.tableView.backgroundView = UIImageView(image:UIImage(named:"background"))
        self.tableView.estimatedRowHeight = 280
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        print(haha(2, 3, 4))
        
        // load our model
        loadModel();
    }
    
    func haha(_ a:Int, _ b:Int = 5, _ c:Int) -> Int {
        return a + b + c;
    }
    
    // Mark: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Card", for: indexPath) as! CardTableViewCell
        let member = members[indexPath.row]
        cell.useMember(member)
        return cell
    }
  
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !preventAnimation.contains(indexPath) {
            preventAnimation.insert(indexPath)
            TipInCellAnimator.animate(cell)
        }
    }

}

