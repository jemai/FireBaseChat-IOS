//
//  BaseController.swift
//  ChatAppFireBase
//
//  Created by Abdelhak Jemaii on 05/12/2016.
//  Copyright © 2016 Abdelhak Jemaii. All rights reserved.
//

import UIKit

class BaseController: UIViewController {

    // MARK: - Variables
    let appDelegate : AppDelegate = {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initViewController(){

    }
    
    func popViewController(){
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    //
    func logOut(){
        self.appDelegate.logOut()
    }
}
