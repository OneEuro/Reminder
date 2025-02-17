//
//  ReminderViewController.swift
//  Reminder
//
//  Created by Владимир Малышев on 03.07.2023.
//

import Cocoa
 
import Cocoa

class ReminderViewController: NSViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var timeIntervalTextField: NSTextField!
    @IBOutlet weak var countdownLabel: NSTextField!
    @IBOutlet weak var timePicker: NSDatePicker!

    // MARK: - Properties

    private var timerConfiguration = TimerConfiguration()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotificationAuthorization()
        timerConfiguration.reminderViewController = self
    }

    // MARK: - Setup

    /// Requests authorization for notifications.
    private func setupNotificationAuthorization() {
        NotificationItem.createRequestAuthorization()
    }

    // MARK: - IBActions

    @IBAction func setReminder(_ sender: NSButton) {
        guard let timeInterval = TimeInterval(timeIntervalTextField.stringValue) else {
            showAlert(message: "Invalid time interval. Please enter a valid number.")
            return
        }

        let selectedTimeInterval = timePicker.dateValue.timeIntervalSinceNow
        guard selectedTimeInterval > 0 else {
            showAlert(message: "Please select a future time.")
            return
        }

        timerConfiguration.updateTimeInterval(with: timeInterval)
        timerConfiguration.createTimer()
    }

    @IBAction func stopTimer(_ sender: NSButton) {
        timerConfiguration.invalidateTimers()
    }

    @IBAction func closeProgram(_ sender: Any) {
        NSApp.terminate(sender)
    }

    // MARK: - Helper Methods

    /// Updates the countdown label with the remaining time.
    func updateCountdownLabel(remainingTime: TimeInterval) {
        let minutes = Int(remainingTime) / 60
        let seconds = Int(remainingTime) % 60
        countdownLabel.stringValue = String(format: "%02d:%02d", minutes, seconds)
    }

    /// Displays an alert with the given message.
    private func showAlert(message: String) {
        let alert = NSAlert()
        alert.messageText = message
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}
