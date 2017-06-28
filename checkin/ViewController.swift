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
        self.userFilteredList = self.userList.filter {$0.contains(filterText ?? "")}
        self.userTableView.reloadData()
    }
    @IBOutlet weak var searchTextField: UITextField!
    
    
    
    var userList: [String] = []
    var userFilteredList: [String] = []
    var ref : DatabaseReference?
    var handle : DatabaseHandle?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return userFilteredList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = userFilteredList[indexPath.row]
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ref = Database.database().reference();
        let childRef =  ref?.child("/");
        
        handle = childRef?.observe(.value, with: { (snapshot) in
            print("children \(snapshot.childrenCount)")
            let enumerator = snapshot.children
            self.userList.removeAll()
            while let rest = enumerator.nextObject() as? DataSnapshot {
                guard let restDict = rest.value as? [String: Any] else { continue }
                let name = restDict["first"] as? String
                let last = restDict["last"] as? String
                let email = restDict["email"] as? String
                let itemDisplay = name?.appending(" ").appending(last!).appending(" ").appending(email!);
                self.userList.append(itemDisplay!)
                
                
            }
            self.userFilteredList = self.userList.filter { $0 is String }
            self.userTableView.reloadData()
            
        })
    }

  

}

