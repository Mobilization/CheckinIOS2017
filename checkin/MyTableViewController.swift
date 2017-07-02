//
//  MyTableViewController.swift
//  checkin
//
//  Created by Mariusz Saramak on 01/07/2017.
//  Copyright © 2017 Mariusz Saramak. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class MyTableViewController: UITableViewController {

    @IBOutlet weak var searchField: UITextField!
    @IBAction func filterEditTextChanged(_ sender: UITextField) {
        userFilteredList = userList.filter {
            let searchText = normalizeString(str: (sender.text ?? " "))
            return normalizeString(str: $0.name).contains(searchText) ||
            $0.email.contains(searchText)
        }
        tableView?.reloadData()
    }
    
    private func normalizeString(str : String) -> String{
        return str.localizedLowercase.folding(options: .diacriticInsensitive, locale: .current).replacingOccurrences(of: "ł", with: "l")
    }
    
    class User {
        var name : String = ""
        var email : String = ""
        var checkin : Bool = false
        var id : Int = 0
        
    }
    
    var userList: [User] = []
    var userFilteredList: [User] = []
    var ref : DatabaseReference?
    var handle : DatabaseHandle?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                let checkin = restDict["checked"] as? Bool
                let id = restDict["number"] as! String
                let user = User()
                user.name = (last?.appending(" ").appending(name!))!
                user.email = email ?? ""
                user.checkin = checkin!
                let idI = Int(id);
                user.id = idI!
                self.userList.append(user)
                
                
            }
            self.userFilteredList = self.userList.filter { $0 != nil }
            self.tableView.reloadData()
            
        })
    }
    
    
  
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userFilteredList.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let userCell = cell as? MyTableUIViewCell {
            userCell.user = userFilteredList[indexPath.row]
        }
        
        return cell
    }
    
    

}
