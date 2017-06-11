//
//  DSGradientProgressView.swift
//  DSGradientProgressView
//
//  Created by Abhinav on 2/16/17.
//  Copyright © 2017 Dhol Studio. All rights reserved.
//

import UIKit

@IBDesignable
public class DSGradientProgressView: UIView, CAAnimationDelegate {
  
  public var barColor: UIColor = UIColor(hue: (29.0/360.0), saturation: 1.0, brightness: 1.0, alpha: 1.0) {
    didSet {
      initialize()
    }
  }

  override public class var layerClass: AnyClass {
    get {
      return CAGradientLayer.self
    }
  }
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    self.initialize()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func initialize() {
    
    let layer = self.layer as! CAGradientLayer
    
    // Use a horizontal gradient
    layer.startPoint = CGPoint(x: 0.0, y: 0.5)
    layer.endPoint = CGPoint(x: 1.0, y: 0.5)
    
    var colors: [CGColor] = []

    for alpha in stride(from: 0, through: 40, by: 2) {
      
      let color = barColor.withAlphaComponent(CGFloat(Double(alpha)/100.0))
      
      colors.append(color.cgColor)
    }
    
    for alpha in stride(from: 40, through: 90, by: 10) {
      
      let color = barColor.withAlphaComponent(CGFloat(Double(alpha)/100.0))
      
      colors.append(color.cgColor)
    }
    
    for alpha in stride(from: 90, through: 100, by: 10) {
      
      let color = barColor.withAlphaComponent(CGFloat(Double(alpha)/100.0))
      
      colors.append(color.cgColor)
      colors.append(color.cgColor) // adding twice
    }
    
    for alpha in stride(from: 100, through: 0, by: -20) {
      
      let color = barColor.withAlphaComponent(CGFloat(Double(alpha)/100.0))
      
      colors.append(color.cgColor)
    }
    
    layer.colors = colors
  }
  
  private func performAnimation() {
    
    // Move the last color in the array to the front
    // shifting all the other colors.
    let layer = self.layer as! CAGradientLayer
    
    guard let color = layer.colors?.popLast() else {
      print("FATAL ERR: GradientProgressView : Layer should contain colors!")
      return
    }
    
    layer.colors?.insert(color, at: 0)
    
    let shiftedColors = layer.colors!
    
    let animation = CABasicAnimation(keyPath: "colors")
    animation.toValue = shiftedColors
    animation.duration = 0.03
    animation.isRemovedOnCompletion = true
    animation.fillMode = kCAFillModeForwards
    animation.delegate = self
    layer.add(animation, forKey: "animateGradient")
  }
  
  public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    performAnimation()
  }
  
  public func start() {
    performAnimation()
  }
  
  
}
