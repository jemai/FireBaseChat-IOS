//
//  LoginView.swift
//  ChatAppFireBase
//
//  Created by Abdelhak Jemaii on 05/12/2016.
//  Copyright © 2016 Abdelhak Jemaii. All rights reserved.
//

import UIKit

class LoginView: UIView {

    // MARK: - Variables
    var backgroundImage : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "LoginBackGroundAsset")
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    //
    var backgroundLayer : UIView = {
        let view = UIView()
        view.backgroundColor = Constants.AppBaseColor
        view.alpha = 0.8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    //
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Settings
    func setup(){
        self.translatesAutoresizingMaskIntoConstraints = false
        setupLayout()
    }
    
    func setupLayout(){
        self.addSubview(backgroundImage)
        backgroundImage.bindFrameToSuperviewBounds()
        //
        self.addSubview(backgroundLayer)
        backgroundLayer.bindFrameToSuperviewBounds()
        //
    }
}

