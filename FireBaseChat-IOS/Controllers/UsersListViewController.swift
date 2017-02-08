//
//  UsersListViewController.swift
//  ChatAppFireBase
//
//  Created by Abdelhak Jemaii on 30/01/2017.
//  Copyright © 2017 Abdelhak Jemaii. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class UsersListViewController: UIViewController , UITableViewDataSource , UITableViewDelegate{
    
    // MARK: - Variables and outlets
    var usersTable : UITableView = {
        let tab = UITableView()
        tab.translatesAutoresizingMaskIntoConstraints = false
        return tab
    }()
    //
    var usersSource = [String : [String : AnyObject]]()
    let usersRef = FIRDatabase.database().reference().child("users")
    var data = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        initViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Initializers
    func initViewController(){
        initTableView()
        initLayout()
        initDataSource()
    }
    //
    func initTableView(){
        usersTable.dataSource = self
        usersTable.delegate = self
        usersTable.register(UsersTableCell.self, forCellReuseIdentifier: "UsersTableCell")
    }
    //
    func initDataSource(){
        
        usersRef.observe(.value, with: { (snap) in
            self.usersSource = snap.value as! [String : [String : AnyObject]]
            debugPrint(self.usersSource)
            
            if self.data.count > 0 {
                self.data.removeAll()
            }
            
            for user in self.usersSource {
                let newUser = User(dict: user.value)
                if newUser.id !=  FIRAuth.auth()?.currentUser?.uid {
                    self.data.append(newUser)
                }
            }
            self.usersTable.reloadData()
        })
    }
    //
    func initLayout()  {
        self.view.addSubview(usersTable)
        usersTable.bindFrameToSuperviewBounds()
    }
    //MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ChatManager.shared.startChat (selectedUser : data[indexPath.item]){ (roomId) in
            debugPrint("the room id is  \(roomId)")
            let chat = ChatViewController()
            chat.roomId = roomId
            self.navigationController?.pushViewController(chat, animated: true)
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    //MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UsersTableCell = tableView.dequeueReusableCell(withIdentifier: "UsersTableCell", for: indexPath) as! UsersTableCell
        cell.initCell(user: data[indexPath.item])
        return cell
    }
}


class User {
    
    // MARK: - Variables
    var displayName = ""
    var photoUrl = ""
    var id = ""
    
    // MARK: - Init
    init(name : String , photo  : String , id : String) {
        self.displayName = name
        self.id = id
        self.photoUrl = photo
    }
    //
    init(dict : [String : AnyObject]) {
        self.displayName = dict["displayName"] as! String
        self.id = dict["id"] as! String
        if let url = dict["photoUrl"] as? String {
            self.photoUrl = url
        }else {
            self.photoUrl = "http://images.indianexpress.com/2015/10/smile-main.jpg"
        }

    }
}





