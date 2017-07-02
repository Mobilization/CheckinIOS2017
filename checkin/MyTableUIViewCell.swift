//
//  MyTableUIViewCell.swift
//  checkin
//
//  Created by Mariusz Saramak on 30/06/2017.
//  Copyright © 2017 Mariusz Saramak. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MyTableUIViewCell: UITableViewCell {

    @IBAction func checkinChanged(_ sender: UISwitch) {
        let ref = Database.database().reference()
        let key = "/\(user!.id)"
        if let childRef = ref.child(key) as? DatabaseReference {
            childRef.updateChildValues(["checked": sender.isOn])
        }

    }

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var checkin: UISwitch!
    
    var user : MyTableViewController.User? {
        didSet{
            updateUI()
        }
    }
    
    private func updateUI(){
        self.name?.text = user?.name
        self.email?.text = user?.email
        self.checkin?.isOn = user?.checkin ?? false
    }
}
