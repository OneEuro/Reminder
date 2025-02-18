//
//  AppDelegate.swift
//  Reminder
//
//  Created by Владимир Малышев on 03.07.2023.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    // MARK: - Properties

    /// The status item (icon) in the system's status bar.
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    /// The popover that displays the reminder interface.
    let popover = NSPopover()

    /// Monitors global events to close the popover when clicking outside of it.
    var eventMonitor: EventMonitor?

    /// The view controller for the reminder interface.
    var reminderVC: ReminderViewController?

    // MARK: - Application Lifecycle

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupStatusBarButton()
        setupPopover()
        setupEventMonitor()
    }

    // MARK: - Setup Methods

    /// Configures the status bar button with an icon and an action.
    private func setupStatusBarButton() {
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBar") // Set the status bar icon
            button.action = #selector(togglePopover(_:)) // Set the action to toggle the popover
        }
    }

    /// Configures the popover with the reminder view controller.
    private func setupPopover() {
        popover.contentViewController = ReminderViewController.freshController()
    }

    /// Configures the event monitor to close the popover when clicking outside of it.
    private func setupEventMonitor() {
        eventMonitor = EventMonitor(mask: [.leftMouseDown]) { [weak self] event in
            if let strongSelf = self, strongSelf.popover.isShown {
                strongSelf.closePopover(sender: event)
            }
        }
    }

    // MARK: - Popover Actions

    /// Toggles the visibility of the popover.
    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }

    /// Displays the popover anchored to the status bar button.
    func showPopover(sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            eventMonitor?.start()
        }
    }

    /// Closes the popover.
    func closePopover(sender: Any?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
}

// MARK: - Extensions

extension NSNib.Name {
    /// The nib name for the `ReminderViewController`.
    static let reminderViewController = NSNib.Name("ReminderViewController")
}

extension ReminderViewController {
    /// Creates and returns a fresh instance of `ReminderViewController` from the storyboard.
    static func freshController() -> ReminderViewController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("ReminderViewController")
        
        guard let viewController = storyboard.instantiateController(withIdentifier: identifier) as? ReminderViewController else {
            fatalError("Unable to find ReminderViewController in Main.storyboard. Please check the storyboard.")
        }
        
        return viewController
    }
}


