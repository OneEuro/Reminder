//
//  AppDelegate.swift
//  Reminder
//
//  Created by Владимир Малышев on 03.07.2023.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let popover = NSPopover()
    var eventMonitor: EventMonitor?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBar")
            button.action = #selector(togglePopover(_:))
        }

        popover.contentViewController = ReminderViewController.freshController()

        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let strongSelf = self, strongSelf.popover.isShown {
                strongSelf.closePopover(sender: event)
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }

    func showPopover(sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            eventMonitor?.start()
        }
    }

    func closePopover(sender: Any?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
}

extension NSNib.Name {
    static let reminderViewController = NSNib.Name("ReminderViewController")
}

extension ReminderViewController {
    static func freshController() -> ReminderViewController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("ReminderViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? ReminderViewController else {
            fatalError("Why cant i find ReminderViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}


