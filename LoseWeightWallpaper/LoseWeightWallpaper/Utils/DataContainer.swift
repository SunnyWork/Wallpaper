//
//  DataContainer.swift
//  LoseWeightWallpaper
//
//  Created by Qing Jiao on 13/6/17.
//  Copyright © 2017 Qing Jiao. All rights reserved.
//

import Foundation

class DataContainer {
  static let shared = DataContainer()
  private init() {}
  
  var targetWeight: Int? {
    set {
      if let target = newValue {
        UserDefaults.standard.set(target, forKey: "targetWeight")
      }
    }
    get {
      if let v = UserDefaults.standard.object(forKey: "targetWeight") as? Int {
        return v
      }
      return nil
    }
  }
  
  var initWeight: Int? {
    set {
      if let target = newValue {
        UserDefaults.standard.set(target, forKey: "initWeight")
      }
    }
    get {
      if let v = UserDefaults.standard.object(forKey: "initWeight") as? Int {
        return v
      }
      return nil
    }
  }
  
  var currentWeight: Int? {
    set {
      if let target = newValue {
        UserDefaults.standard.set(target, forKey: "currentWeight")
      }
    }
    get {
      if let v = UserDefaults.standard.object(forKey: "currentWeight") as? Int {
        return v
      }
      return nil
    }
  }
  
  var reason: String? {
    set {
      if let target = newValue {
        UserDefaults.standard.set(target, forKey: "reason")
      }
    }
    get {
      if let v = UserDefaults.standard.object(forKey: "reason") as? String {
        return v
      }
      return nil
    }
  }
  
}
