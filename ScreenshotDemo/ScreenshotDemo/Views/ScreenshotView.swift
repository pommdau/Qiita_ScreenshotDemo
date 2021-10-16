//
//  ScreenshotView.swift
//  ScreenshotDemo
//
//  Created by ForAppleStoreAccount on 2021/10/16.
//

import Cocoa

class ScreenshotView: NSView {
    
    init(_ frame: NSRect) {
        super.init(frame: frame)
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.init(white: 0.4, alpha: 0.5).cgColor
        self.layer?.borderColor = NSColor.white.cgColor
        self.layer?.borderWidth = 1
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
