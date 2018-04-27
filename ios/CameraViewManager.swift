//
//  CameraViewManager.swift
//  reactSwiftCamera
//
//  Created by Carlos Valarezo Loaiza on 4/26/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

import Foundation

@objc(CameraViewManager)
class CameraViewManager : RCTViewManager {
  
  override func view() -> UIView {
    return CameraView();
  }
  
}

