import Cocoa
import UserNotifications

class TimerConfiguration {
    // MARK: - Properties

    private var timer: Timer?
    private var countdownTimer: Timer?
    private var notificationRepeatTimer: Timer?
    private var remainingTime: TimeInterval = 0
    private var timeInterval: TimeInterval = 0
    private var notificationItem: NotificationItem?

    weak var reminderViewController: ReminderViewController?

    // MARK: - Methods

    var isRunning: Bool {
        self.timer != nil || self.countdownTimer != nil || self.notificationRepeatTimer != nil
    }

    func updateTimeInterval(with interval: TimeInterval) {
        guard interval > 0 else {
            print("Invalid time interval. Please provide a positive number.")
            return
        }
        self.timeInterval = interval
        self.remainingTime = self.timeInterval
    }

    func createNotification() {
        self.notificationItem = NotificationItem(
            title: "Reminder",
            body: "It's time!",
            sound: .default,
            categoryIdentifier: "reminderCategory"
        )

        guard let notification = self.notificationItem else {
            print("Failed to initialize notification.")
            return
        }

        notification.configNotificationCenter()
        notification.timerConfig = self
    }

    func createTimer() {
        invalidateTimers()

        self.remainingTime = self.timeInterval

        self.timer = Timer.scheduledTimer(withTimeInterval: self.timeInterval, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.timer = nil
            self.countdownTimer?.invalidate()
            self.countdownTimer = nil
            self.reminderViewController?.showPicker()
            self.createNotification()
            self.startNotificationRepeat()
        }

        createCountdownTimer()
    }

    func createCountdownTimer() {
        self.countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            self.remainingTime -= 1
            self.reminderViewController?.updateCountdownLabel(remainingTime: self.remainingTime)

            if self.remainingTime <= 0 {
                self.countdownTimer?.invalidate()
                self.countdownTimer = nil
            }
        }
    }

    private func startNotificationRepeat() {
        let interval = SettingsManager.shared.notificationRepeatInterval
        guard interval > 0 else { return }
        self.notificationRepeatTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.createNotification()
        }
    }

    private func stopNotificationRepeat() {
        self.notificationRepeatTimer?.invalidate()
        self.notificationRepeatTimer = nil
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
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

    func invalidateTimers() {
        self.timer?.invalidate()
        self.countdownTimer?.invalidate()
        self.timer = nil
        self.countdownTimer = nil
        stopNotificationRepeat()
    }
}
