//
//  ScreenshotPanel.swift
//  ScreenshotDemo
//
//  Created by ForAppleStoreAccount on 2021/10/16.
//

import Cocoa

protocol ScreenshotPanelDelegate: AnyObject {
    func screenshotPanelDidCancel(_ screenshotPanel: ScreenshotPanel)
    func screenshotPanel(_ screenshotPanel: ScreenshotPanel, didSelectRect selectedRect: NSRect)
}


class ScreenshotPanel: NSPanel {

    // MARK: - Properties
    
    weak var screenshotPanelDelegate: ScreenshotPanelDelegate?
    
    var name = ""
    private var monitors = [Any?]()
        
    // MARK: - Properties: Point
    
    var startPoint: NSPoint?
    var endPoint: NSPoint? {
        didSet {
            screenshotView.frame = selectedRect
        }
    }
    
    // メイン画面の左下を原点としたときの座標
    private var pointInScreen: NSPoint {
        return NSEvent.mouseLocation
    }
    
    // パネルの画面の左下を原点としたときの座標
    private var pointInPanel: NSPoint {
        return NSEvent.mouseLocation - self.frame.origin
    }
    
    private var containsCursorInScreen: Bool {
        return self.frame.contains(pointInScreen)
    }
    
    var selectedRect: NSRect {
        guard let startPoint = startPoint,
              let endPoint = endPoint,
              containsCursorInScreen
        else {
            return .zero
        }
        
        let x = min(startPoint.x, endPoint.x)
        let y = min(startPoint.y, endPoint.y)
        let width = abs(endPoint.x - startPoint.x)
        let height = abs(endPoint.y - startPoint.y)

        return NSRect(x: x, y: y, width: width, height: height)
    }
    
    // MARK: - Properties: UI
    
    private var screenshotView: ScreenshotView = {
        let screenshotView = ScreenshotView(CGRect.zero)
        return screenshotView
    }()
    
    private var pointLabel: CursorPointLabel = {
        let label = CursorPointLabel(labelWithString: "")
        return label
    }()
    
    // MARK: - Lifecycle
    
    init(_ frame: NSRect) {
        super.init(contentRect: frame,
                   styleMask: [.borderless, .nonactivatingPanel],
                   backing: .buffered,
                   defer: true)
//        self.level = .popUpMenu
        self.level = .normal
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        self.isOpaque = false
        self.hasShadow = false
        self.backgroundColor = NSColor(white: 0.0, alpha: 0.02)
        self.contentView?.addSubview(screenshotView)
        self.contentView?.addSubview(pointLabel)
        configurePointLabel()
        setupMonitors()
    }
    
    // MARK: - Overrides
    
    override func close() {
        teardownMonitors()
        NSCursor.arrow.set()
        super.close()
    }
    
    // MARK: - Monitors
    
    private func setupMonitors() {
        
        monitors.append(NSEvent.addLocalMonitorForEvents(matching: .leftMouseDown, handler: { (event) -> NSEvent? in
            self.startPoint = self.pointInPanel
            self.endPoint = nil
            self.configurePointLabel()
            NSCursor.crosshair.set()
            return event
        }))
        
        monitors.append(NSEvent.addLocalMonitorForEvents(matching: .leftMouseDragged, handler: { (event) -> NSEvent? in
            self.endPoint = self.pointInPanel
            self.configurePointLabel()
            NSCursor.crosshair.set()
            return event
        }))
        
        monitors.append(NSEvent.addLocalMonitorForEvents(matching: .leftMouseUp, handler: { (event) -> NSEvent? in
            self.endPoint = self.pointInPanel
            if self.selectedRect == .zero {
                self.screenshotPanelDelegate?.screenshotPanelDidCancel(self)
            } else {
                self.screenshotPanelDelegate?.screenshotPanel(self, didSelectRect: self.selectedRect)
            }
            
            self.startPoint = nil
            self.endPoint = nil
            self.configurePointLabel()
            NSCursor.arrow.set()
            return event
        }))
        
        monitors.append(NSEvent.addLocalMonitorForEvents(matching: .mouseMoved, handler: { (event) -> NSEvent? in
            self.configurePointLabel()
            NSCursor.crosshair.set()
            return event
        }))
    }
    
    private func teardownMonitors() {
        for monitor in monitors {
            NSEvent.removeMonitor(monitor!)
        }
        monitors.removeAll()
    }
    
    // MARK: - Helpers
    
    private func printPoint() {
        print("\(name): \(pointInPanel)\n")
    }
        
    private func configurePointLabel() {
        
        if containsCursorInScreen {
            pointLabel.isHidden = false
        } else {
            pointLabel.isHidden = true
            return
        }
        
        pointLabel.configure(withPoint: pointInPanel)
        let bufferX: CGFloat = 5
        let bufferY = pointLabel.frame.height
        pointLabel.frame.origin = CGPoint(x: pointInPanel.x + bufferX,
                                          y: pointInPanel.y - bufferY)
    }
}
