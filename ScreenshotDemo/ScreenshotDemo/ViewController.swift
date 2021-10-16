//
//  ViewController.swift
//  ScreenshotDemo
//
//  Created by ForAppleStoreAccount on 2021/10/16.
//

import Cocoa

class ViewController: NSViewController {
    
    // MARK: - Properties
    
    private var monitors = [Any?]()
    private var panels = [ScreenshotPanel]()
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectRect(self)
    }

    override var representedObject: Any? {
        didSet {
        }
    }
    
    // MARK: - Overrides
    
    override func keyDown(with event: NSEvent) {
        super.keyDown(with: event)

//        print("key press: \(event)")
        if event.keyCode == 53 {  // 53: esc
            closePanels()
            teardownMonitors()
        }
    }
    
    // MARK: - Selectors
    
    @IBAction func selectRect(_ sender: Any?) {
        guard panels.isEmpty else {
            return
        }
        
        NSCursor.crosshair.set()
        NSApp.activate(ignoringOtherApps: true)
        for (i, screen) in NSScreen.screens.enumerated() {
            let panel = ScreenshotPanel(screen.frame)
            panel.name = "Screen_\(i)"
            panel.screenshotPanelDelegate = self
            panels.append(panel)
            panel.orderFrontRegardless()
        }
        
        setupMonitors()
    }
    
    private func closePanels() {
        panels.forEach { panel in
            panel.close()
        }
        panels.removeAll()
    }
    
    // MARK: - Helpers
    
    // MARK: - Monitors For Keydown
    
    private func setupMonitors() {
        monitors.append(
            NSEvent.addLocalMonitorForEvents(matching: .keyDown) { (event) -> NSEvent? in
                self.keyDown(with: event)
                return event
            }
        )
    }
    
    private func teardownMonitors() {
        for monitor in monitors {
            NSEvent.removeMonitor(monitor!)
        }
        monitors.removeAll()
    }

}

// MARK: - ScreenshotPanelDelegate

extension ViewController: ScreenshotPanelDelegate {
    
    func screenshotPanelDidCancel(_ screenshotPanel: ScreenshotPanel) {
        // Do nothing
    }
    
    func screenshotPanel(_ screenshotPanel: ScreenshotPanel, didSelectRect selectedRect: NSRect) {
        guard
            let window = screenshotPanel.contentView?.window,
            let cgImage = CGImage.background(window.frame, CGWindowID(window.windowNumber))
        else {
            return
        }
        
        // NSScreen座標系からCGWindow座標系に変換
        let selectedRectInCGImage = NSRect(x: selectedRect.origin.x,
                                           y: screenshotPanel.frame.height - selectedRect.origin.y - selectedRect.height,
                                           width: selectedRect.width,
                                           height: selectedRect.height)
        
        guard let croppedImage = cgImage.cropping(to: selectedRectInCGImage) else {
            return
        }
        
        let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let saveUrl = documentUrl.appendingPathComponent("hoge.jpg")
        let bitmapRep = NSBitmapImageRep(cgImage: croppedImage)
        let jpegData = bitmapRep.representation(using: NSBitmapImageRep.FileType.jpeg, properties: [:])!
        
        do {
            try jpegData.write(to: saveUrl, options: .atomic)
            print(saveUrl)
        } catch {
            print("error: \(error)")
        }
        
        closePanels()
        teardownMonitors()
    }
}
