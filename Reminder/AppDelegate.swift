import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    let popover = NSPopover()

    var eventMonitor: EventMonitor?

    var reminderVC: ReminderViewController?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupStatusBarButton()
        setupPopover()
        setupEventMonitor()
    }

    private func setupStatusBarButton() {
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBar")
            button.action = #selector(togglePopover(_:))
        }
    }

    private func setupPopover() {
        let vc = ReminderViewController()
        reminderVC = vc
        popover.contentViewController = vc
    }

    private func setupEventMonitor() {
        eventMonitor = EventMonitor(mask: [.leftMouseDown]) { [weak self] event in
            if let strongSelf = self, strongSelf.popover.isShown {
                strongSelf.closePopover(sender: event)
            }
        }
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
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            eventMonitor?.start()
        }
    }

    func closePopover(sender: Any?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
}
