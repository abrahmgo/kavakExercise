//
//  activityIndicator.swift
//  kavakExercise
//
//  Created by Andrés Bonilla on 12/4/19.
//  Copyright © 2019 Andrés Abraham Bonilla Gómez. All rights reserved.
//

import UIKit

class activityIndicator: UIActivityIndicatorView {
    
    
    //let loadingView = UIView(frame: (UIApplication.shared.delegate?.window??.bounds)!)
    let imageView = UIImageView()
    let sizeView = UIViewController()
    
    init(frame: CGRect, image: UIImage) {
        super.init(frame: frame)
    
        imageView.frame = bounds
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.center = CGPoint(x: sizeView.view.frame.width/2+100, y: sizeView.view.frame.height/2)
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(imageView)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    override func startAnimating()
    {
        isHidden = false
        rotate()
    }
    
    override func stopAnimating()
    {
        isHidden = true
        removeRotation()
    }
    
    private func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 1)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.imageView.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    private func removeRotation() {
        self.imageView.layer.removeAnimation(forKey: "rotationAnimation")
    }
}
