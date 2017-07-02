//
//  ViewController.swift
//  checkin
//
//  Created by Mariusz Saramak on 28/06/2017.
//  Copyright © 2017 Mariusz Saramak. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var userTableView: UITableView!
    private var filterText: String?
    @IBAction func searchChangedEdit(_ sender: UITextField){
        filterText = sender.text
        self.userFilteredList = self.userList.filter {$0.name.contains(filterText ?? "")}
        self.userTableView.reloadData()
    }
    @IBOutlet weak var searchTextField: UITextField!
    
    class User {
        

        var name : String = ""
        var email : String = ""
        var checkin : Bool = false
        
    }
    
    
    var userList: [User] = []
    var userFilteredList: [User] = []
    var ref : DatabaseReference?
    var handle : DatabaseHandle?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return userFilteredList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "mycell")
                                        
        if (cell == nil){
            cell = MyTableUIViewCell(style: .default, reuseIdentifier: "mycell")
        }
        let user = userFilteredList[indexPath.row]
        if let myCell = cell as? MyTableUIViewCell {
            myCell.name?.text = user.name
            myCell.email?.text = user.email
            myCell.mycheckin?.isOn = user.checkin
        }
        return cell!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.userTableView.register(MyTableUIViewCell.self as AnyClass, forCellReuseIdentifier: "mycell")
//        self.userTableView.register(UINib(nibName: "MyTableUIViewCell", bundle: nil), forCellReuseIdentifier: "mycell")
        // Do any additional setup after loading the view, typically from a nib.
        
    }

  

}

