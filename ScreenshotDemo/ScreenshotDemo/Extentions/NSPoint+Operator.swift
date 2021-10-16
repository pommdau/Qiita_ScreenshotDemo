//
//  NSPoint+Operator.swift
//  ScreenshotDemo
//
//  Created by ForAppleStoreAccount on 2021/10/16.
//

import Foundation

// MARK: - CGPoint

func + (l: CGPoint, r: CGPoint) -> CGPoint {
    return CGPoint(x: l.x + r.x, y: l.y + r.y)
}

func - (l: CGPoint, r: CGPoint) -> CGPoint {
    return CGPoint(x: l.x - r.x, y: l.y - r.y)
}

func * (l: CGFloat, r: CGPoint) -> CGPoint {
    return CGPoint(x: l * r.x, y: l * r.y)
}

func / (l: CGPoint, r: CGFloat) -> CGPoint {
    if r == 0.0 { return CGPoint.zero }
    return CGPoint(x: l.x / r, y: l.y / r)
}

// MARK: - CGRect

func * (l: CGFloat, r: CGRect) -> CGRect {
    return CGRect(x: l * r.origin.x, y: l * r.origin.y, width: l * r.width, height: l * r.height)
}

// MARK: - CGSize

func + (l: CGSize, r: CGSize) -> CGSize {
    return CGSize(width: l.width + r.width, height: l.height + r.height)
}

func * (l: CGFloat, r: CGSize) -> CGSize {
    return CGSize(width: l * r.width, height: l * r.height)
}
