//
//  utilidades.swift
//  UBoat LEX
//
//  Created by Jose on 17/12/14.
//  Copyright (c) 2014 Berganza. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGFloat {
    static func random () -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UInt32.max) )
    }
    
    static func random(#min: CGFloat, max: CGFloat) ->CGFloat {
      //  assert(min < max)
        return CGFloat.random() * (max - min) + min
    }}

