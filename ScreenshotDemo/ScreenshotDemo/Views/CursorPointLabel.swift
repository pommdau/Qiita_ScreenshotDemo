//
//  CursorPointLabel.swift
//  ScreenshotDemo
//
//  Created by ForAppleStoreAccount on 2021/10/16.
//

import AppKit


class CursorPointLabel: NSTextField {
    
    // MARK: - Properties
        
    private var textAttributes: [NSAttributedString.Key : Any] = {
        var textAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor : NSColor.black,
        ]
        
        let myShadow = NSShadow()
        myShadow.shadowColor = NSColor.white
        myShadow.shadowBlurRadius = 1
        myShadow.shadowOffset = NSSize(width: 1, height: 1)
        textAttributes[.shadow] = myShadow
        
        return textAttributes
    }()
    
    private var cunsomFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "," // 区切り文字を指定
        formatter.groupingSize = 3 // 何桁ごとに区切り文字を入れるか指定
        
        return formatter
    }()

    // MARK: - Public
    
    func configure(withPoint point: CGPoint) {
        self.attributedStringValue = createAttributedStringValue(withPoint: point)
        self.sizeToFit()
    }
    
    // MARK: - Helpers

    private func createAttributedStringValue(withPoint point: CGPoint) -> NSAttributedString {
        return NSAttributedString(string: createPointLabelMessage(point),
                                  attributes: textAttributes)
    }

    private func createPointLabelMessage(_ point: CGPoint) -> String {
        let pointX = NSNumber(integerLiteral: Int(point.x))
        let pointY = NSNumber(integerLiteral: Int(point.y))
        let pointXString = cunsomFormatter.string(from: pointX) ?? "x"
        let pointYString = cunsomFormatter.string(from: pointY) ?? "y"
        
        return "\(pointXString)\n\(pointYString)"
    }
    
}



