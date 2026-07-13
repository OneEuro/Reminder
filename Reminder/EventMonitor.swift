//
//  EventMonitor.swift
//  Reminder
//
//  Created by Владимир Малышев on 03.07.2023.
//
import Cocoa

/// A class to monitor global events and execute a handler when the specified events occur.
public class EventMonitor {
    private var monitor: Any?
    private let mask: NSEvent.EventTypeMask
    private let handler: (NSEvent?) -> Void
    private let lock = NSLock() // Ensures thread safety for the monitor property

    /// Initializes a new `EventMonitor` instance.
    /// - Parameters:
    ///   - mask: The event types to monitor.
    ///   - handler: The closure to execute when the specified events occur.
    public init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent?) -> Void) {
        self.mask = mask
        self.handler = handler
    }

    deinit {
        stop()
    }

    /// Starts monitoring for global events.
    public func start() {
        lock.lock()
        defer { lock.unlock() }

        guard monitor == nil else {
            print("EventMonitor is already running.")
            return
        }

        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
        if monitor == nil {
            assertionFailure("Failed to start global event monitoring.")
        }
    }

    /// Stops monitoring for global events.
    public func stop() {
        lock.lock()
        defer { lock.unlock() }

        if let monitor = monitor {
            NSEvent.removeMonitor(monitor)
            self.monitor = nil
        }
    }
}
