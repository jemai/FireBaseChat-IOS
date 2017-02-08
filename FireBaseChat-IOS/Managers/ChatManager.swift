//
//  ChatManager.swift
//  ChatAppFireBase
//
//  Created by Abdelhak Jemaii on 31/01/2017.
//  Copyright © 2017 Abdelhak Jemaii. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth


class ChatManager {
    
    // MARK: - Variables
    static let shared : ChatManager = ChatManager()
    var chatrooms = [String](){
        didSet{
            startListener()
        }
    }
    
    let usersRef = FIRDatabase.database().reference().child("users")
    let roomsRef = FIRDatabase.database().reference().child("rooms")
    var roomId = ""
    
    func startChat(selectedUser : User , completion: @escaping (_ result: String) -> Void) {
        let currentUser = FIRAuth.auth()?.currentUser
        
        if let id = currentUser?.uid {
            usersRef.child(id).observeSingleEvent(of: .value, with: { (snap) in
                
                let user = snap.value as! [String : AnyObject]
                if let rooms = user["chatRooms"] as? [String : AnyObject]{
                    if let room = rooms[selectedUser.id] as? String {
                        self.roomId = room
                        completion(room)
                        return
                    }
                }
                    let newRoom = self.roomsRef.childByAutoId()
                    let roomData = ["id" : newRoom.key]
                    newRoom.setValue(roomData)
                    //
                self.usersRef.child(id).child("chatRooms/\(selectedUser.id)").setValue(newRoom.key)
                self.usersRef.child(selectedUser.id).child("chatRooms/\(id)").setValue(newRoom.key)
                
                completion(newRoom.key)
                
            })
        }
    }
    
    func startListener(){

        for room in chatrooms {
                roomsRef.child(room).child("messages").observe(.childAdded, with: { (snap) in
                    debugPrint("startListener new message \(snap.value)")
                })
        }
    }
}
