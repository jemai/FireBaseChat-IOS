//
//  LoginViewController.swift
//  ChatAppFireBase
//
//  Created by Abdelhak Jemaii on 05/12/2016.
//  Copyright © 2016 Abdelhak Jemaii. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth

class LoginViewController: BaseController , GIDSignInUIDelegate ,GIDSignInDelegate{
    
    // MARK: - Variables
    var backGroundView  : LoginView = {
        let view = LoginView()
        view.backgroundColor = UIColor.gray
        return view
        
    }() 
    //
    var loginLab : UILabel = {
       
        let lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.text = "Login using your Google Account"
        lab.font = UIFont.boldSystemFont(ofSize: 16)
        lab.textColor = UIColor.white
        lab.textAlignment = .center
        return lab
    }()
    var googleSign : UIButton = {
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named : "GooglePlusAsset"), for: .normal)
        return btn
    }()
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - initializers
    func setup(){
        setupLayout()
        setupButtonTargets()
        setupGoogleId()
    }
    
    //
    func setupLayout(){
        self.view.addSubview(backGroundView)
        backGroundView.bindFrameToSuperviewBounds()
        //
        self.view.addSubview(loginLab)
        loginLab.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7).isActive = true
        loginLab.heightAnchor.constraint(equalToConstant: 200).isActive = true
        loginLab.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loginLab.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -44).isActive = true

        self.view.addSubview(googleSign)
        googleSign.widthAnchor.constraint(equalToConstant: 44).isActive = true
        googleSign.heightAnchor.constraint(equalToConstant: 44).isActive = true
        googleSign.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        googleSign.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 44).isActive = true
        //
    }
    //
    func setupGoogleId(){
        GIDSignIn.sharedInstance().clientID = Constants.GoogleId
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
    // MARK: - Init Actions
    func setupButtonTargets(){
        self.googleSign.addTarget(self, action: #selector(self.loginWithGoogleAction), for: .touchUpInside)
    }
    //
    func loginWithGoogleAction(){
        GIDSignIn.sharedInstance().signIn()
    }
    
    // MARK: - Protocole implementations
    //Google auth 
    // The sign-in flow has finished and was successful if |error| is |nil|.
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!){
        if error != nil {
            debugPrint(error.localizedDescription)
            return
        }
        LoginManager.shared.loginWithGoogle(auth : user.authentication)

        debugPrint("user details \(user.authentication)")

    }
}
