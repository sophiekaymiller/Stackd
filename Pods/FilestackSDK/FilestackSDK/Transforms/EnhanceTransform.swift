//
//  EnhanceTransform.swift
//  FilestackSDK
//
//  Created by Mihály Papp on 15/06/2018.
//  Copyright © 2018 Filestack. All rights reserved.
//

import Foundation

/**
 Smartly analyzes a photo and performs color correction and other enhancements to improve the overall quality of the image.
 */
@objc(FSEnhanceTransform) public class EnhanceTransform: Transform {
  
  /**
   Initializes a `EnhanceTransform` object.
   */
  public init() {
    super.init(name: "enhance")
  }
}
