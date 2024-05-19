//
//  SimpleTranslateApp.swift
//  SimpleTranslate
//
//  Created by Stahsf on 2024/5/18.
//

import SwiftUI

@main
struct SimpleTranslateApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // 创建状态栏项
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "character.bubble.fill", accessibilityDescription: "input")
            button.action = #selector(togglePopover(_:))
        }
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = statusItem?.button {
            let popover = NSPopover()
            popover.contentViewController = NSHostingController(rootView: ContentView())
            popover.behavior = .transient
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .maxY)
        }
    }
}
