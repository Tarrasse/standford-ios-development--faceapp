//
//  FacialExpression.swift
//  Face app
//
//  Created by Mahmoud El-Tarrasse on 8/3/17.
//  Copyright © 2017 Mahmoud El-Tarrasse. All rights reserved.
//

import Foundation

// UI-independent representation of a facial expression
struct FacialExpression
{
    enum Eyes: Int {
        case Open
        case Closed
        case Squinting
    }
    
    
    enum Mouth: Int {
        case Frown
        case Smirk
        case Neutral
        case Grin
        case Smile
        
        func sadderMouth() -> Mouth {
            return Mouth(rawValue: rawValue - 1) ?? .Frown
        }
        func happierMouth() -> Mouth {
            return Mouth(rawValue: rawValue + 1) ?? .Smile
        }
    }
    
    var eyes: Eyes
    var mouth: Mouth
}
