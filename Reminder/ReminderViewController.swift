import Cocoa
import DrumrollTimePicker

class ReminderViewController: NSViewController {

    // MARK: - Properties

    private let quitButton = NSButton()
    private let titleLabel = NSTextField(labelWithString: "Reminder")
    private let timePicker = DrumrollTimePicker()
    private let startButton = NSButton()
    private let stopButton = NSButton()
    private let countdownLabel = NSTextField()

    private var timerConfiguration = TimerConfiguration()

    // MARK: - Lifecycle

    override func loadView() {
        self.view = NSView(frame: NSRect(x: 0, y: 0, width: 480, height: 270))
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
    }

    // MARK: - Setup

    private func setupUI() {
        let white: [NSAttributedString.Key: Any] = [.foregroundColor: NSColor.white]

        quitButton.translatesAutoresizingMaskIntoConstraints = false
        quitButton.attributedTitle = NSAttributedString(string: "Выход", attributes: white)
        quitButton.bezelStyle = .rounded
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
        countdownLabel.isBordered = true
        countdownLabel.alignment = .center
        countdownLabel.font = .monospacedDigitSystemFont(ofSize: 16, weight: .medium)
        countdownLabel.stringValue = "00:00"
        countdownLabel.textColor = .white
        self.view.addSubview(countdownLabel)

        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.attributedTitle = NSAttributedString(string: "Start", attributes: white)
        startButton.bezelStyle = .rounded
        startButton.action = #selector(startTimer)
        startButton.target = self
        self.view.addSubview(startButton)

        stopButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.attributedTitle = NSAttributedString(string: "Stop", attributes: white)
        stopButton.bezelStyle = .rounded
        stopButton.action = #selector(stopTimer)
        stopButton.target = self
        self.view.addSubview(stopButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            quitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20),
            quitButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 48),
            quitButton.widthAnchor.constraint(equalToConstant: 75),

            titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 53),
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 20),

            timePicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            timePicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            timePicker.widthAnchor.constraint(equalToConstant: 260),
            timePicker.heightAnchor.constraint(equalToConstant: 190),

            countdownLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            countdownLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 40),
            countdownLabel.widthAnchor.constraint(equalToConstant: 70),

            startButton.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 24),
            startButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 64),

            stopButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 12),
            stopButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stopButton.widthAnchor.constraint(equalToConstant: 63),
            stopButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20),
        ])
    }

    // MARK: - Actions

    @objc private func startTimer() {
        guard let selected = timePicker.selectedTime else { return }
        let totalSeconds = TimeInterval(selected.hour * 3600 + selected.minute * 60 + selected.second)
        guard totalSeconds > 0 else { return }
        self.timerConfiguration.updateTimeInterval(with: totalSeconds)
        self.timerConfiguration.createTimer()
    }

    @objc private func stopTimer() {
        self.timerConfiguration.invalidateTimers()
    }

    @objc private func closeProgram() {
        NSApp.terminate(nil)
    }

    // MARK: - Countdown

    func updateCountdownLabel(remainingTime: TimeInterval) {
        let minutes = Int(remainingTime) / 60
        let seconds = Int(remainingTime) % 60
        self.countdownLabel.stringValue = String(format: "%02d:%02d", minutes, seconds)
    }
}
