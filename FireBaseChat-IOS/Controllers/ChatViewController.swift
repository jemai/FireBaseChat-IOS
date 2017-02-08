//
//  ChatViewController.swift
//  ChatAppFireBase
//
//  Created by Abdelhak Jemaii on 05/12/2016.
//  Copyright © 2016 Abdelhak Jemaii. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import MobileCoreServices
import AVKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

struct MediaTypes {
    static let Text = "TEXT"
    static let Video = "VIDEO"
    static let Photo = "PHOTO"
}

class ChatViewController: JSQMessagesViewController  {
    
    // MARK: - Variables

    var roomId = ""
    var messageRef = FIRDatabase.database().reference()
    
    var messages = [JSQMessage]()
    //
    var avatarDict = [String : JSQMessagesAvatarImage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageRef = messageRef.child("rooms").child(roomId).child("messages")
        setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setups
    func setup(){
        setupLayout()
        setupNavigationBar()
        initChatViewController()
    }
    //
    func setupLayout(){
        
    }
    //
    func setupNavigationBar(){
        let logOutBtn = UIBarButtonItem(title: "Log Out", style: .done, target: self, action:#selector(self.logOut))
        self.navigationItem.leftBarButtonItem  = logOutBtn
    }
    
    func initChatViewController(){
        let currentUser = FIRAuth.auth()?.currentUser
        self.senderId = currentUser?.uid
        self.senderDisplayName = "Joe"
        
        if currentUser?.isAnonymous == true {
            self.senderDisplayName = "Anonymious"
        }else {
            self.senderDisplayName = "\(currentUser!.displayName!)"
        }
        observeMessages()
    }
    
    func observeUsers(id : String) {
        FIRDatabase.database().reference().child("users").child(id).observe(.value, with: { (snap) in
            if let dict = snap.value as? [String: AnyObject] {
                debugPrint("user dict is \(dict)")
                
                if let avatarUrl = dict["photoUrl"] as? String{
                    self.setupAvatar(url : avatarUrl, senderId : id)
                    
                }else {
                    self.setupAvatar(url : "", senderId : id)
                    
                }
            }
        })
    }
    func setupAvatar(url : String , senderId : String){
        if !url.isEmpty {
            let url = URL(string: url)
            let data = try? Data(contentsOf: url!)
            if let imageData = data  {
                let img = UIImage(data: imageData)
                let userImg = JSQMessagesAvatarImageFactory.avatarImage(with: img, diameter: 30)
                avatarDict[senderId] = userImg
            }
            
        }else {
            avatarDict[senderId] = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named : "ic_details_account_profile"), diameter: 30)
        }
        collectionView.reloadData()
    }
    
    // MARK: - Actions
    func logOut(){
        LoginManager.shared.logOut()
    }
    
    func observeMessages(){
        
        messageRef.observe(.childAdded, with: { (snap) in
            if let dict = snap.value as? [String : AnyObject]{
                let mediaTYpe = dict["MediaType"] as! String
                let senderId = dict["senderId"] as? String
                let senderName = dict["senderDisplayName"] as! String
                
                self.observeUsers(id: senderId!)
                
                debugPrint("the fucking dict is \(dict)")
                
                
                switch mediaTYpe {
                    
                case MediaTypes.Text:
                    if let text = dict["text"] as? String {
                        self.messages.append(JSQMessage(senderId: senderId, displayName: senderName, text: text))
                    }
                case MediaTypes.Photo:
                    let photo = JSQPhotoMediaItem(image: nil)
                    let fileUrl = dict["fileUrl"]  as! String
                    let url = URL(string: fileUrl)

                    debugPrint("the fucking cached image image is  \(ImageManager.photoCache.object(forKey: fileUrl as NSString)) and the cache \(ImageManager.photoCache.countLimit)")
                    if let imageCached = ImageManager.photoCache.object(forKey: fileUrl as NSString){
                        photo?.image = imageCached
                    }else {
                        
                        DispatchQueue.global().async {
                            let data = try? Data(contentsOf: url!)
                            if let imageData = data  {
                                DispatchQueue.main.async {
                                    let image = UIImage(data: imageData)
                                    photo?.image = image
                                    ImageManager.photoCache.setObject(image!, forKey: fileUrl as NSString)
                                    //
                                    self.collectionView.reloadData()
                                }
                            }
                        }
                    }
                    
                    
                    //checking if it's incoming message or outgoing
                    
                    
                    if self.senderId == senderId {
                        photo?.appliesMediaViewMaskAsOutgoing = true
                    }else {
                        photo?.appliesMediaViewMaskAsOutgoing = false
                    }
                    self.messages.append(JSQMessage(senderId: senderId, displayName: senderName, media: photo))
                    
                case MediaTypes.Video:
                    let fileUrl = dict["fileUrl"] as! String
                    
                    let video = URL(string: fileUrl)
                    let videoItem = JSQVideoMediaItem(fileURL: video, isReadyToPlay: true)
                    //checking if it's incoming message or outgoing
                    if self.senderId == senderId {
                        videoItem?.appliesMediaViewMaskAsOutgoing = true
                    }else {
                        videoItem?.appliesMediaViewMaskAsOutgoing = false
                    }
                    self.messages.append(JSQMessage(senderId: senderId, displayName: senderName, media: videoItem))
                    
                default :
                    debugPrint("")
                    
                }
                
                //
                self.collectionView.reloadData()
            }
        })
    }
    
    // MARK: - Messages Vc Actions
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        //        messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text))
        //        collectionView.reloadData()
        let newMessage = messageRef.childByAutoId()
        let messageData = ["text" : text, "senderId" : senderId , "senderDisplayName": senderDisplayName , "MediaType" : "TEXT"]
        newMessage.setValue(messageData)
        self.finishSendingMessage()
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        
        let sheet = UIAlertController(title: "Media Message", message: "Slect a media type", preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel) { (alert : UIAlertAction) in
            
        }
        let photoLib = UIAlertAction(title: "Photo Library", style: .default) { (alert : UIAlertAction) in
            
            self.getMediaFrom(type : kUTTypeImage)
        }
        let videoLib = UIAlertAction(title: "Video Library", style: .default) { (alert : UIAlertAction) in
            self.getMediaFrom(type : kUTTypeMovie)
        }
        sheet.addAction(cancel)
        sheet.addAction(photoLib)
        sheet.addAction(videoLib)
        
        self.present(sheet, animated: true, completion: nil)
    }
    
    func getMediaFrom(type : CFString){
        
        debugPrint("media type \(type)")
        
        let mediaPicker = UIImagePickerController()
        mediaPicker.delegate = self
        mediaPicker.mediaTypes = [type as String]
        self.present(mediaPicker, animated: true, completion: nil)
    }
    
    // MARK: - JSQ Cllection delegates & data source
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        
        if message.senderId == self.senderId {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: .blue)
        }else{
            return bubbleFactory?.incomingMessagesBubbleImage(with: .gray)
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.item]
        
        return avatarDict[message.senderId]
        
        // return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named : "ic_details_account_profile"), diameter: 30)
    }
    
    // MARK: - PLay video in a conversation
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        debugPrint("didTapMessageBubbleAt \(indexPath)")
        let message = messages[indexPath.item]
        if message.isMediaMessage {
            if let mediaItem = message.media as? JSQVideoMediaItem {
                let player = AVPlayer(url: mediaItem.fileURL)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Function to send media photos and videos
    
    func sendMedia(picture : UIImage?, video: URL?){
        debugPrint("picture \(picture)")
        if let picture = picture {
            let filePath = "\(FIRAuth.auth()!.currentUser!.uid)/\(NSDate.timeIntervalSinceReferenceDate)"
            
            let data = UIImageJPEGRepresentation(picture, 0.1)
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpg"
            
            FIRStorage.storage().reference().child(filePath).put(data!, metadata: metadata) { (metadata, error) in
                if error != nil {
                    debugPrint("there is an error uploading file \(error?.localizedDescription)")
                    return
                }
                let fileUrl = metadata!.downloadURLs?[0].absoluteString
                let newMessage = self.messageRef.childByAutoId()
                let messageData = ["fileUrl" : fileUrl, "senderId" : self.senderId , "senderDisplayName":  self.senderDisplayName , "MediaType" : "PHOTO"]
                newMessage.setValue(messageData)
                
            }
            debugPrint("filePath \(filePath)")
            return
        }
        if let video = video {
            let filePath = "\(FIRAuth.auth()!.currentUser!.uid)/\(NSDate.timeIntervalSinceReferenceDate)"
            
            let data = try? Data(contentsOf: video)
            let metadata = FIRStorageMetadata()
            metadata.contentType = "video/mp4"
            
            FIRStorage.storage().reference().child(filePath).put(data!, metadata: metadata) { (metadata, error) in
                if error != nil {
                    debugPrint("there is an error uploading file \(error?.localizedDescription)")
                    return
                }
                let fileUrl = metadata!.downloadURLs?[0].absoluteString
                let newMessage = self.messageRef.childByAutoId()
                let messageData = ["fileUrl" : fileUrl, "senderId" : self.senderId , "senderDisplayName":  self.senderDisplayName , "MediaType" : "VIDEO"]
                newMessage.setValue(messageData)
                
            }
            debugPrint("filePath \(filePath)")
            return
            
        }
    }
}
