//
//  CGImage+Background.swift
//  ScreenshotDemo
//
//  Created by ForAppleStoreAccount on 2021/10/16.
//

import AppKit
import CoreGraphics

extension NSScreen {
    static var totalRect: CGRect {
        return screens.reduce(CGRect.zero) { (result, screen) -> CGRect in
            return result.union(screen.frame)
        }
    }
}

extension CGImage {
    static func background(_ frame: CGRect, _ windowID: CGWindowID) -> CGImage? {
        let windowOptions: CGWindowListOption = [.optionOnScreenOnly, .optionOnScreenBelowWindow]
        let imageOptions: CGWindowImageOption = [.nominalResolution]
        guard let image = CGWindowListCreateImage(CGRect.null, windowOptions, windowID, imageOptions) else {
            return nil
        }
        let totalRect = NSScreen.totalRect
        let origin = CGPoint(x: frame.minX - totalRect.minX,
                             y: totalRect.maxY - frame.maxY)
        return image.cropping(to: NSRect(origin: origin, size: frame.size))
    }
}
