//
//  UIColorExtension.swift
//  ChatAppFireBase
//
//  Created by Abdelhak Jemaii on 05/12/2016.
//  Copyright © 2016 Abdelhak Jemaii. All rights reserved.
//

import UIKit

extension UIView {
    
    
    func addConstrainsWithFormat(_ format : String, views : UIView...){
        
        var viewDictionnary = [String : UIView]()
        
        for (index, view) in views.enumerated(){
            
            view.translatesAutoresizingMaskIntoConstraints = false
            let key = "v\(index)"
            viewDictionnary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionnary))
    }
}

// MARK: - ReusableView
protocol ReusableView: class {}

extension ReusableView where Self: UIView {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

// MARK: - NibLoadableView
protocol NibLoadableView: class { }

extension NibLoadableView where Self: UIView {
    
    static var nibName: String {
        return String(describing: self)
    }
}

// MARK: - Constraint Extentions
extension UIView {
    //Centring and binding a view to its super view
    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
    }
    //Centring and binding a view to another view
    func bindFrameTo(view: UIView){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        self.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
}

// MARK: - Animation Extentions
extension UIView {
    func showViewAnimated(){
        self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.alpha -= 3
        self.isHidden = false
        
        UIView.animate(withDuration: 0.2){
            self.transform = CGAffineTransform.identity
            self.alpha += 3
        }
    }
    
    //hide view animated
    func hideViewAnimated(){
        //
        UIView.animate(withDuration: 0.2 ,
                                   animations: {
                                    self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                                    self.alpha -= 3
            },
                                   completion: { finish in
                                    self.isHidden = true
                                    self.transform = CGAffineTransform.identity
                                    self.alpha += 3

        })
    }
}

// MARK: - Shadow extensions
extension UIView {
    // init view with a dark shadow
    func addBlackShadow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 3
    }
    // init view with a white shadow
    func addWhiteShadow(){
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 3
    }
}



