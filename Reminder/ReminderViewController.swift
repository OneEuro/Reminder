import Cocoa
import DrumrollTimePicker

class ReminderViewController: NSViewController {

    // MARK: - Properties

    private let quitButton = DimmingButton()
    private let titleLabel = NSTextField(labelWithString: "Reminder")
    private let timePicker = DrumrollTimePicker()
    private let startButton = DimmingButton()
    private let stopButton = DimmingButton()
    private let countdownLabel = NSTextField()

    private var timerConfiguration = TimerConfiguration()

    private var previewTimer: Timer?

    private var stopButtonTrailing: NSLayoutConstraint?
    private var stopButtonCenter: NSLayoutConstraint?
    private var startButtonLeading: NSLayoutConstraint?
    private var startButtonCenter: NSLayoutConstraint?

    // MARK: - Lifecycle

    override func loadView() {
        self.view = NSView(frame: NSRect(x: 0, y: 0, width: 480, height: 340))
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.black.cgColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.timerConfiguration.reminderViewController = self
        setupUI()
        setupConstraints()
        SettingsManager.shared.register(self.timePicker)
        NotificationItem.createRequestAuthorization()
        restoreLastTime()
        startPreviewTimer()
    }

    private func restoreLastTime() {
        let defaults = UserDefaults.standard
        let hour = defaults.integer(forKey: "lastSelectedHour")
        let minute = defaults.integer(forKey: "lastSelectedMinute")
        let second = defaults.integer(forKey: "lastSelectedSecond")
        if hour > 0 || minute > 0 || second > 0 {
            self.timePicker.setTime(hour: hour, minute: minute, second: second, animated: false)
        } else {
            self.timePicker.setTime(hour: 0, minute: 0, second: 0, animated: false)
        }
    }

    private func saveLastTime() {
        guard let selected = self.timePicker.selectedTime else { return }
        let defaults = UserDefaults.standard
        defaults.set(selected.hour, forKey: "lastSelectedHour")
        defaults.set(selected.minute, forKey: "lastSelectedMinute")
        defaults.set(selected.second, forKey: "lastSelectedSecond")
    }

    private func startPreviewTimer() {
        self.previewTimer?.invalidate()
        self.previewTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updatePreviewLabel()
        }
    }

    private func updatePreviewLabel() {
        guard self.countdownLabel.isHidden else { return }
        guard let selected = self.timePicker.selectedTime else {
            self.countdownLabel.stringValue = "00:00"
            return
        }
        if selected.hour > 0 {
            self.countdownLabel.stringValue = String(format: "%d:%02d:%02d", selected.hour, selected.minute, selected.second)
        } else {
            self.countdownLabel.stringValue = String(format: "%02d:%02d", selected.minute, selected.second)
        }
    }

    // MARK: - Setup

    private func setupUI() {
        quitButton.translatesAutoresizingMaskIntoConstraints = false
        quitButton.isBordered = false
        quitButton.wantsLayer = true
        quitButton.title = ""
        quitButton.layer?.backgroundColor = NSColor(red: 0.78, green: 0.18, blue: 0.16, alpha: 1.0).cgColor
        quitButton.layer?.cornerRadius = 6
        quitButton.action = #selector(closeProgram)
        quitButton.target = self
        self.view.addSubview(quitButton)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 13)
        titleLabel.textColor = .white
        self.view.addSubview(titleLabel)

        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.showsSeconds = true
        timePicker.itemSpacing = 16
        timePicker.selectionBarOffsetY = 6
        self.view.addSubview(timePicker)

        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        countdownLabel.isEditable = false
        countdownLabel.isBordered = false
        countdownLabel.isBezeled = false
        countdownLabel.drawsBackground = false
        countdownLabel.backgroundColor = .clear
        countdownLabel.alignment = .center
        countdownLabel.font = .monospacedDigitSystemFont(ofSize: 64, weight: .thin)
        countdownLabel.stringValue = "00:00"
        countdownLabel.textColor = .white
        countdownLabel.isHidden = true
        self.view.addSubview(countdownLabel)

        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.isBordered = false
        startButton.wantsLayer = true
        startButton.layer?.backgroundColor = NSColor.systemGreen.withAlphaComponent(0.15).cgColor
        startButton.layer?.cornerRadius = 22
        startButton.attributedTitle = NSAttributedString(string: "Start", attributes: [
            .foregroundColor: NSColor.systemGreen,
            .font: NSFont.systemFont(ofSize: 13),
        ])
        startButton.action = #selector(startTimer)
        startButton.target = self
        self.view.addSubview(startButton)

        stopButton.isHidden = true

        stopButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.isBordered = false
        stopButton.wantsLayer = true
        stopButton.layer?.backgroundColor = NSColor.systemRed.withAlphaComponent(0.15).cgColor
        stopButton.layer?.cornerRadius = 22
        stopButton.attributedTitle = NSAttributedString(string: "Stop", attributes: [
            .foregroundColor: NSColor.systemRed,
            .font: NSFont.systemFont(ofSize: 13),
        ])
        stopButton.isEnabled = false
        stopButton.action = #selector(stopTimer)
        stopButton.target = self
        self.view.addSubview(stopButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            quitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12),
            quitButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 12),
            quitButton.widthAnchor.constraint(equalToConstant: 12),
            quitButton.heightAnchor.constraint(equalToConstant: 12),

            titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12),
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),

            timePicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            timePicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            timePicker.widthAnchor.constraint(equalToConstant: 260),
            timePicker.heightAnchor.constraint(equalToConstant: 170),

            countdownLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            countdownLabel.centerYAnchor.constraint(equalTo: self.timePicker.centerYAnchor),

            stopButton.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 8),
            stopButton.widthAnchor.constraint(equalToConstant: 44),
            stopButton.heightAnchor.constraint(equalToConstant: 44),
            stopButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20),

            startButton.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 8),
            startButton.widthAnchor.constraint(equalToConstant: 44),
            startButton.heightAnchor.constraint(equalToConstant: 44),
        ])
        self.stopButtonTrailing = stopButton.trailingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -10)
        self.stopButtonCenter = stopButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        self.stopButtonTrailing?.isActive = true

        self.startButtonLeading = startButton.leadingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 10)
        self.startButtonCenter = startButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        self.startButtonCenter?.isActive = true
    }

    // MARK: - Picker / Countdown toggle

    func showPicker() {
        self.timePicker.isHidden = false
        self.countdownLabel.isHidden = true
        self.stopButton.isHidden = true
        self.startButton.isHidden = false
        if let trailing = self.stopButtonTrailing, let center = self.stopButtonCenter {
            NSLayoutConstraint.deactivate([center, self.startButtonLeading].compactMap { $0 })
            NSLayoutConstraint.activate([trailing, self.startButtonCenter].compactMap { $0 })
        }
    }

    func showCountdown() {
        self.timePicker.isHidden = true
        self.countdownLabel.isHidden = false
        self.startButton.isHidden = true
        self.stopButton.isHidden = false
        self.stopButton.isEnabled = true
        if let trailing = self.stopButtonTrailing, let center = self.stopButtonCenter {
            NSLayoutConstraint.deactivate([trailing, self.startButtonCenter].compactMap { $0 })
            NSLayoutConstraint.activate([center, self.startButtonLeading].compactMap { $0 })
        }
    }

    // MARK: - Actions

    @objc private func startTimer() {
        guard let selected = timePicker.selectedTime else { return }
        let totalSeconds = TimeInterval(selected.hour * 3600 + selected.minute * 60 + selected.second)
        guard totalSeconds > 0 else { return }
        saveLastTime()
        self.countdownLabel.stringValue = self.timerConfiguration.remainingTimeString(from: totalSeconds)
        showCountdown()
        self.timerConfiguration.updateTimeInterval(with: totalSeconds)
        self.timerConfiguration.createTimer()
    }

    @objc private func stopTimer() {
        self.timerConfiguration.invalidateTimers()
        showPicker()
    }

    @objc private func closeProgram() {
        NSApp.terminate(nil)
    }

    // MARK: - Countdown

    func updateCountdownLabel(remainingTime: TimeInterval) {
        let totalSeconds = Int(remainingTime)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        if hours > 0 {
            self.countdownLabel.stringValue = String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            self.countdownLabel.stringValue = String(format: "%02d:%02d", minutes, seconds)
        }
        if totalSeconds <= 0 {
            showPicker()
        }
    }
}

final class DimmingButton: NSButton {

    override func mouseDown(with event: NSEvent) {
        self.layer?.opacity = 0.4
        super.mouseDown(with: event)
        self.layer?.opacity = 1.0
    }
}
