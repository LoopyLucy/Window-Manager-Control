//
//  AppDelegate.swift
//  Window Manager Control
//
//  Created by Erin Fitton on 14/02/2023.
//
import Foundation
import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var window: NSWindow!
    private var statusItem: NSStatusItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        /*window = NSWindow(
            contentRect: NSRect( x: 0, y: 0, width: 480, height: 270),
            styleMask: [.miniaturizable, .closable, .titled, .resizable],
            backing: .buffered,
            defer: false
        )
        window.center()
        window.title = "Window Manager Control"
        window.makeKeyAndOrderFront(nil)*/
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "1.circle", accessibilityDescription: "1")
        }
        
        setupMenus()
    }
    
    func setupMenus() {
        let menu = NSMenu()

        let start = NSMenuItem(title: "Start Yabai", action: #selector(bStart), keyEquivalent: "s")
        menu.addItem(start)
        
        let stop = NSMenuItem(title: "Stop Yabai", action: #selector(bStop), keyEquivalent: "q")
        menu.addItem(stop)
        
        let reset = NSMenuItem(title: "Reset Yabai", action: #selector(bReset), keyEquivalent: "r")
        menu.addItem(reset)
        
        menu.addItem(NSMenuItem.separator())
        
        let open = NSMenuItem(title: "Open Settings", action: #selector(bOpen), keyEquivalent: ",")
        menu.addItem(open)
        
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "Quit Controller", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }
    
    @discardableResult
    func safeShell(_ command: String) throws -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["--login", "-c", command]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh") //<--updated
        task.standardInput = nil

        try task.run() //<--updated
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
    
    @objc func bReset() {
        do { try safeShell("brew services restart yabai") } catch { print("\(error)") }
    }
    
    @objc func bStop() {
        do { try safeShell("brew services stop yabai") } catch { print("\(error)") }
    }
    
    @objc func bStart() {
        do { try safeShell("brew services start yabai") } catch { print("\(error)") }
    }
    
    @objc func bOpen() {
        do { try safeShell("open -t ~/.config/yabai/yabairc") } catch { print("\(error)") }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

}

