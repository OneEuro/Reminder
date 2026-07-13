import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    let popover = NSPopover()

    var eventMonitor: EventMonitor?

    var reminderVC: ReminderViewController?

    private var settingsWindowController: SettingsWindowController?

    private var contextMenu: NSMenu?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupStatusBarButton()
        setupPopover()
        setupEventMonitor()
        setupRightClickMonitor()
    }

    private func setupStatusBarButton() {
        if let button = self.statusItem.button {
            button.image = NSImage(named: "StatusBar")
            button.action = #selector(togglePopover(_:))
        }
    }

    private func setupPopover() {
        let vc = ReminderViewController()
        self.reminderVC = vc
        self.popover.contentViewController = vc
    }

    private func setupEventMonitor() {
        self.eventMonitor = EventMonitor(mask: [.leftMouseDown]) { [weak self] event in
            if let strongSelf = self, strongSelf.popover.isShown {
                strongSelf.closePopover(sender: event)
            }
        }
    }

    private func setupRightClickMonitor() {
        NSEvent.addLocalMonitorForEvents(matching: .rightMouseDown) { [weak self] event in
            guard let self = self else { return event }
            guard let button = self.statusItem.button, let window = button.window else { return event }
            guard event.window == window else { return event }
            let location = button.convert(event.locationInWindow, from: nil)
            guard button.bounds.contains(location) else { return event }
            self.showContextMenu()
            return nil
        }
    }

    private func showContextMenu() {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Settings...", action: #selector(openSettings), keyEquivalent: ","))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        menu.delegate = self
        self.contextMenu = menu
        self.statusItem.menu = menu
        if let button = self.statusItem.button {
            button.performClick(nil)
        }
    }

    @objc private func openSettings() {
        if self.settingsWindowController == nil {
            self.settingsWindowController = SettingsWindowController()
        }
        self.settingsWindowController?.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc func togglePopover(_ sender: Any?) {
        if self.popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }

    func showPopover(sender: Any?) {
        if let button = self.statusItem.button {
            self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            self.eventMonitor?.start()
        }
    }

    func closePopover(sender: Any?) {
        self.popover.performClose(sender)
        self.eventMonitor?.stop()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
}

// MARK: - NSMenuDelegate

extension AppDelegate: NSMenuDelegate {

    func menuDidClose(_ menu: NSMenu) {
        if menu === self.contextMenu {
            self.statusItem.menu = nil
            self.contextMenu = nil
        }
    }
}
