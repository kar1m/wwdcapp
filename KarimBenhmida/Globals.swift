//
//  Globals.swift
//  KarimBenhmida
//
//  Created by Karim Benhmida on 21/04/2015.
//  Copyright (c) 2015 Karim Benhmida. All rights reserved.
//

import Foundation
import UIKit

struct Globals {
    static let screenWidth = UIScreen.mainScreen().bounds.size.width
    static let screenHeight = UIScreen.mainScreen().bounds.size.height
    
    static func colorBetween(color1:UIColor, andColor color2:UIColor, atPercent percent:CGFloat) -> UIColor {
        
        var red1:CGFloat = 0
        var red2:CGFloat = 0
        
        var green1:CGFloat = 0
        var green2:CGFloat = 0
        
        var blue1:CGFloat = 0
        var blue2:CGFloat = 0
        
        var alpha:CGFloat = 0
        
        color1.getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha)
        color2.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha)
        
        let resultRed = red1 + percent * (red2 - red1);
        let resultGreen = green1 + percent * (green2 - green1);
        let resultBlue = blue1 + percent * (blue2 - blue1);
        
        return UIColor(red: resultRed, green: resultGreen, blue: resultBlue, alpha: alpha)
    }
}