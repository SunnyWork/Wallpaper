//
//  SoundManager.swift
//  ColourMemory
//
//  Created by jiao qing on 27/7/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation


//http://soundbible.com/tags-splash.html

class SoundManager {

  static let shared = SoundManager()
  
  var note : AVAudioPlayer?

  private init() {}


  func playWin() {
    playSound(name: "wining")
  }
  
  func playFinish() {
    playSound(name: "champions")
  }
  
//  func playStart() {
//    playSound(name: "champions")
//  }
//  
  func playKeep() {
    playSound(name: "keep")
  }
  
  func stop() {
    note?.stop()
  }
  
  private func playSound(name: String) {
    guard let noteURL = Bundle.main.url(forResource: name, withExtension: "mp3") else {
      return
    }
    
    do {
      try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
      try AVAudioSession.sharedInstance().setActive(true)
      
      note = try AVAudioPlayer(contentsOf: noteURL)
      note?.currentTime = 0
      note?.play()
    } catch {
    }
  }

}
