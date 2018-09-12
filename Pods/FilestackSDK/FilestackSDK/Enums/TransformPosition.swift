//
//  TransformPosition.swift
//  FilestackSDK
//
//  Created by Ruben Nine on 7/12/17.
//  Copyright © 2017 Filestack. All rights reserved.
//

import Foundation


/**
    Represents an image transform position type.
 */
public typealias TransformPosition = FSTransformPosition


public extension TransformPosition {

    internal static func all() -> [TransformPosition] {

        return [.top, .middle, .bottom, .left, .center, .right]
    }

    internal func toArray() -> [String] {

        let ops: [String] = type(of: self).all().compactMap {
          guard contains($0) else {
            return nil
          }
          return $0.stringValue()
        }

        return ops
    }

    private func stringValue() -> String? {

        switch self {
        case .top:

            return "top"

        case .middle:

            return "middle"

        case .bottom:

            return "bottom"

        case .left:

            return "left"

        case .center:

            return "center"

        case .right:

            return "right"

        default:
            
            return nil
        }
    }
}
