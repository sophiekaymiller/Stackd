//
//  Uploadable.swift
//  Filestack
//
//  Created by Mihály Papp on 30/07/2018.
//  Copyright © 2018 Filestack. All rights reserved.
//

import UIKit
import AVFoundation

protocol Uploadable: class {
  var isEditable: Bool {get}
  var associatedImage: UIImage {get}
  var typeIcon: UIImage {get}
  var additionalInfo: String? {get}
}

extension UIImage: Uploadable {
  var isEditable: Bool {
    return true
  }
  
  var associatedImage: UIImage {
    return self
  }
  
  var typeIcon: UIImage {
    return UIImage.fromFilestackBundle("icon-image").withRenderingMode(.alwaysTemplate)
  }
  
  var additionalInfo: String? {
    return nil
  }
}

extension AVAsset: Uploadable {
  var isEditable: Bool {
    return false
  }
  
  var associatedImage: UIImage {
    let beginning = CMTime(seconds: 0, preferredTimescale: 1)
    do {
      let cgImage = try AVAssetImageGenerator(asset: self).copyCGImage(at: beginning, actualTime: nil)
      return UIImage(cgImage: cgImage)
    } catch _ {
      return UIImage() //TODO: return placeholder
    }
  }
  
  var typeIcon: UIImage {
    return UIImage.fromFilestackBundle("icon-file-video")
      .withRenderingMode(.alwaysTemplate)
  }
  
  var additionalInfo: String? {
    return DurationFormatter().string(from: duration.seconds)
  }
}
