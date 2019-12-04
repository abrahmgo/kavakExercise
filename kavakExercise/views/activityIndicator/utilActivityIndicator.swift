//
//  utilActivityIndicator.swift
//  kavakExercise
//
//  Created by Andrés Bonilla on 12/4/19.
//  Copyright © 2019 Andrés Abraham Bonilla Gómez. All rights reserved.
//

import Foundation
import UIKit

class utilActivityIndicator {
    static let shared = utilActivityIndicator()
    private init(){}
    
    var presentLoader = false
    var loader: activityIndicator?
    
    func showLoader(view: UIView){
        if !presentLoader
        {
            let spinner = UIImage(named: "spinner")
            loader = activityIndicator(frame: CGRect(x: -100, y: 0, width: (spinner?.size.width)!/2, height: (spinner?.size.height)!/2), image: spinner!)
            view.addSubview(loader!)
            view.alpha = 0.5
            presentLoader = true
            view.isUserInteractionEnabled = false
            lockView(view: view)
        }
    }
    
    func checkLoader(view: UIView)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if self.presentLoader
            {
                self.presentLoader = false
                self.unlockView(view: view)
            }
        }
    }
    
    func hideLoader(view: UIView){
        if presentLoader
        {
            presentLoader = false
            unlockView(view: view)
        }
    }
    
    func lockView(view: UIView)
    {
        for views in view.subviews
        {
            if let button = views as? UIButton
            {
                button.isUserInteractionEnabled = false
            }
        }
        loader?.startAnimating()
    }
    
    func unlockView(view: UIView)
    {
        for views in view.subviews
        {
            if let button = views as? UIButton
            {
                button.isUserInteractionEnabled = true
            }
        }
        view.alpha = 1
        view.isUserInteractionEnabled = true
        loader?.stopAnimating()
        loader?.removeFromSuperview()
    }
}

