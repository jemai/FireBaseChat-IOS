//
//  LoginManager.swift
//  ChatAppFireBase
//
//  Created by Abdelhak Jemaii on 05/12/2016.
//  Copyright © 2016 Abdelhak Jemaii. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseDatabase

class LoginManager  {
    
    // MARK: - Variables
    let appDelegate : AppDelegate = {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate
    }()
    
    //shared instance
    static let shared = LoginManager()
    let userRef = FIRDatabase.database().reference().child("users")

    
    
    func loginWithGoogle(auth : GIDAuthentication){
        let credential = FIRGoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        FIRAuth.auth()?.signIn(with: credential, completion: { (user : FIRUser?, error : Error?) in
            if error != nil {
                debugPrint("LoginManager loginWithGoogle error \(error)")
                return
            }else {
                self.userRef.child((user?.uid)!).observe(.value, with: { (snap) in
                    let theUser = User(dict: snap.value as! [String : AnyObject])
                    if theUser.displayName.isEmpty {
                        debugPrint("success LoginManager loginWithGoogle email \(user?.email) displayName \(user?.displayName) photoURL \(user?.photoURL) ")
                        let newUser = FIRDatabase.database().reference().child("users").child((user?.uid)!)
                        newUser.setValue(["displayName":user?.displayName,"id":user?.uid,"photoUrl":"\(user!.photoURL!)"])
                    }
                    
                    let val = snap.value as! [String : AnyObject]
                    if let rooms = val["chatRooms"] as? [String : AnyObject]{
                        for room in rooms {
                            ChatManager.shared.chatrooms.append(room.value as! String)
                        }
                    }

                    
                    self.appDelegate.onSuccessLogin()
                    
                })
            }
        })
    }
    
    func logOut(){
        do {
            try FIRAuth.auth()?.signOut()
        } catch let error {
            debugPrint(error.localizedDescription)
            return
        }
        
        debugPrint("the auth object is \(FIRAuth.auth()?.currentUser)")

        self.appDelegate.logOut()
    }
    func switchToChatView(){
        self.appDelegate.onSuccessLogin()
    } //
}
