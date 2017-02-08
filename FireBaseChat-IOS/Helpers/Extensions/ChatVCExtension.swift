//
//  ChatVCExtension.swift
//  ChatAppFireBase
//
//  Created by Abdelhak Jemaii on 05/12/2016.
//  Copyright © 2016 Abdelhak Jemaii. All rights reserved.
//
import UIKit
import JSQMessagesViewController

extension ChatViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        debugPrint("did finish picking")
        debugPrint(info)
        
        if let picture = info[UIImagePickerControllerOriginalImage] as? UIImage {
            sendMedia(picture: picture, video: nil)

        }else if let video = info[UIImagePickerControllerMediaURL] as? URL {
            sendMedia(picture: nil, video: video)
        }
        
        self.dismiss(animated: true, completion: nil)
        collectionView.reloadData()
    }
}
