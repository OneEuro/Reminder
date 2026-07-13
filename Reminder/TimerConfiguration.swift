//
//  TimerConfiguration.swift
//  Reminder
//
//  Created by Владимир Малышев on 06.07.2023.
//
import Cocoa

class TimerConfiguration: NSObject {
    // MARK: - Properties

    private var timer: Timer?
    private var countdownTimer: Timer?
    private var remainingTime: TimeInterval = 0
    private var timeInterval: TimeInterval = 0
    private var notificationItem: NotificationItem?

    weak var reminderViewController: ReminderViewController?

    // MARK: - Public Methods

    var isRunning: Bool {
        self.timer != nil || self.countdownTimer != nil
    }

    /// Updates the time interval for the timer.
       /// - Parameter interval: The time interval in seconds.
       public func updateTimeInterval(with interval: TimeInterval) {
           guard interval > 0 else {
               print("Invalid time interval. Please provide a positive number.")
               return
           }
           timeInterval = interval
           remainingTime = timeInterval
       }

    /// Creates a notification to remind the user when the timer completes.
    public func createNotification() {
        notificationItem = NotificationItem(
            title: "Reminder",
            body: "It's time!",
            sound: .default,
            categoryIdentifier: "reminderCategory"
        )

        guard let notification = notificationItem else {
            print("Failed to initialize notification.")
            return
        }

        notification.configNotificationCenter()
        notification.timerConfig = self
    }

    /// Creates a timer that triggers a notification when it completes.
    public func createTimer() {
        // Invalidate existing timers
        invalidateTimers()

        // Reset remaining time
        remainingTime = timeInterval

        // Schedule the main timer
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { [weak self] _ in
            self?.createNotification()
        }

        // Schedule the countdown timer
        createCountdownTimer()
    }

    /// Creates a countdown timer to update the UI every second.
    internal func createCountdownTimer() {
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            // Update the remaining time
            self.remainingTime -= 1

            // Update the countdown label
            self.reminderViewController?.updateCountdownLabel(remainingTime: self.remainingTime)

            // Stop the countdown timer if the time is up
            if self.remainingTime <= 0 {
                self.countdownTimer?.invalidate()
                self.countdownTimer = nil
            }
        }
    }

    func remainingTimeString(from totalSeconds: TimeInterval) -> String {
        let total = Int(totalSeconds)
        let hours = total / 3600
        let minutes = (total % 3600) / 60
        let seconds = total % 60
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        }
        return String(format: "%02d:%02d", minutes, seconds)
    }

    /// Invalidates all active timers.
       public func invalidateTimers() {
           timer?.invalidate()
           countdownTimer?.invalidate()
           timer = nil
           countdownTimer = nil
       }
}
