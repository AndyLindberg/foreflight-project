//
//  UIColor.swift
//  ForeFlightProject
//
//  Created by Andy Lindberg on 5/15/22.
//

import Foundation
import UIKit

extension UIColor {
        
    convenience init(hexString: String) {
        let color = UIColor.colorWithHexString(hexString, alpha: 1)
        self.init(cgColor: color.cgColor)
    }

    static func colorWithHexString (_ hex:String, alpha:CGFloat) -> UIColor
    {
        var cString:String =  hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        
        // String should be 6 or 8 characters
        if (cString.count < 6) { return UIColor.gray }
        
        // strip 0X if it appears
        let index = cString.index(cString.startIndex, offsetBy: 2)
        if (cString.hasPrefix("0X")) { cString = String(cString[index...]) }
        
        let index2 = cString.index(cString.startIndex, offsetBy: 1)
        if (cString.hasPrefix("#")) { cString = String(cString[index2...]) }
        
        if (cString.count != 6) { return UIColor.gray }
        
        // Separate into r, g, b substrings
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        
        // Scan values
        var r:UInt64 = 0, g:UInt64 = 0, b:UInt64 = 0;
        Scanner(string: rString).scanHexInt64(&r)
        Scanner(string: gString).scanHexInt64(&g)
        Scanner(string: bString).scanHexInt64(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }

    static func color (red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor (red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }
    
    static func color (red: CGFloat, green: CGFloat, blue: CGFloat, a:CGFloat) -> UIColor {
        return UIColor (red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: a)
    }
    
    static func color (withWhite w:CGFloat) -> UIColor {
        return UIColor.init (white: w/255.0, alpha: 1.0)
    }
    
    class var customGreyColor1:UIColor {
        get {
            return colorWithHexString("0x141414", alpha: 1.0)
        }
    }
    
    class var customGreyColor2:UIColor {
        get {
            return colorWithHexString("0x323232", alpha: 1.0)
        }
    }
    
}
