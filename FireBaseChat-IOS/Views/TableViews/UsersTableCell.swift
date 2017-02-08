//
//  UsersTableCell.swift
//  ChatAppFireBase
//
//  Created by Abdelhak Jemaii on 31/01/2017.
//  Copyright © 2017 Abdelhak Jemaii. All rights reserved.
//

import UIKit

class UsersTableCell: UITableViewCell {
    // MARK: - Variables & outlets
    var userName : UILabel = {
        var lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    //
    var user : User?
    //
    var userImg : UIImageView = {
        var imv = UIImageView()
        imv.contentMode = .scaleAspectFit
        imv.translatesAutoresizingMaskIntoConstraints = false
        return imv
    }()
    //Overrides
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //
        self.selectionStyle = .none
        initLayout()
    }
    //
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Initializers
    func initLayout(){
        self.contentView.addSubview(userImg)
        userImg.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor ,constant : 8).isActive = true
        userImg.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.8).isActive = true
        userImg.widthAnchor.constraint(equalTo: self.contentView.widthAnchor , multiplier: 0.2).isActive = true
        userImg.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        //
        
        self.contentView.addSubview(userName)
        userName.leadingAnchor.constraint(equalTo: self.userImg.trailingAnchor ,constant : 8).isActive = true
        userName.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant : 8).isActive = true
        userName.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        userName.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant : 8).isActive = true
        //
        self.contentView.backgroundColor = UIColor.white
    }
    
    func initCell(user : User){
        if !user.photoUrl.isEmpty {
            let url = URL(string: user.photoUrl)
            let data = try? Data(contentsOf: url!)
            if let imageData = data  {
                let img = UIImage(data: imageData)
                self.userImg.image = img
            }
        }
        
        self.userName.text = user.displayName
        self.user  = user
    }

    
    
}
