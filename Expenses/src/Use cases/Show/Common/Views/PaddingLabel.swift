//
//  PaddingLabel.swift
//  Expenses
//
//  Created by Borja Arias Drake on 28/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import UIKit

class PaddingLabel: UILabel {
    
    var padding = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    
    override var intrinsicContentSize : CGSize {
        
        get {
            let superContentSize = super.intrinsicContentSize
            let width = superContentSize.width + padding.left + padding.right
            let heigth = superContentSize.height + padding.top + padding.bottom
            return CGSize(width: width, height: heigth)
        }
    }
    
    override func drawText(in rect: CGRect) {
        if (self.text?.isEmpty)! {
            super.drawText(in: self.bounds)     
            self.clearColor()
        } else {
            super.drawText(in: UIEdgeInsetsInsetRect(rect, padding))
        }
        
    }
    
    
    // Override -sizeThatFits: for Springs & Struts code
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSizeThatFits = super.sizeThatFits(size)
        let width = superSizeThatFits.width + padding.left + padding.right
        let heigth = superSizeThatFits.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
 
    override func layoutSubviews() {
        if let text = self.text
        {
            if text.isEmpty
            {
                padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                self.clearColor()
            } else {
                padding = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
            }
            
        } else {
            padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.clearColor()
        }
    }
    
    func clearColor() {
        let delegate = UIApplication.shared.delegate as! BSAppDelegate
        let unselectedColor = delegate.themeManager.theme.unselectedCellColor()
        self.backgroundColor = unselectedColor
    }
}
