import Cocoa

class SettingsViewController: NSViewController {

    // MARK: - Properties

    private let infiniteScrollCheckbox = NSButton(checkboxWithTitle: "Infinite scroll", target: nil, action: nil)
    private let invertScrollCheckbox = NSButton(checkboxWithTitle: "Invert scroll direction", target: nil, action: nil)

    private let intervalLabel = NSTextField(labelWithString: "Notification repeat interval (sec):")
    private let intervalField = NSTextField()
    private let intervalStepper = NSStepper()

    // MARK: - Lifecycle

    override func loadView() {
        self.view = NSView(frame: NSRect(x: 0, y: 0, width: 320, height: 220))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadSettings()
    }

    // MARK: - Setup

    private func setupUI() {
        infiniteScrollCheckbox.translatesAutoresizingMaskIntoConstraints = false
        infiniteScrollCheckbox.target = self
        infiniteScrollCheckbox.action = #selector(infiniteScrollChanged)
        self.view.addSubview(infiniteScrollCheckbox)

        invertScrollCheckbox.translatesAutoresizingMaskIntoConstraints = false
        invertScrollCheckbox.target = self
        invertScrollCheckbox.action = #selector(invertScrollChanged)
        self.view.addSubview(invertScrollCheckbox)

        intervalLabel.translatesAutoresizingMaskIntoConstraints = false
        intervalLabel.textColor = .labelColor
        intervalLabel.font = .systemFont(ofSize: 13)
        self.view.addSubview(intervalLabel)

        intervalField.translatesAutoresizingMaskIntoConstraints = false
        intervalField.isEditable = true
        intervalField.alignment = .center
        intervalField.formatter = {
            let fmt = NumberFormatter()
            fmt.numberStyle = .decimal
            fmt.minimum = 1
            fmt.maximum = 3600
            return fmt
        }()
        intervalField.action = #selector(intervalFieldChanged)
        intervalField.target = self
        self.view.addSubview(intervalField)

        intervalStepper.translatesAutoresizingMaskIntoConstraints = false
        intervalStepper.minValue = 1
        intervalStepper.maxValue = 3600
        intervalStepper.increment = 1
        intervalStepper.valueWraps = false
        intervalStepper.action = #selector(intervalStepperChanged)
        intervalStepper.target = self
        self.view.addSubview(intervalStepper)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            infiniteScrollCheckbox.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20),
            infiniteScrollCheckbox.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),

            invertScrollCheckbox.topAnchor.constraint(equalTo: infiniteScrollCheckbox.bottomAnchor, constant: 10),
            invertScrollCheckbox.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),

            intervalLabel.topAnchor.constraint(equalTo: invertScrollCheckbox.bottomAnchor, constant: 20),
            intervalLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),

            intervalField.topAnchor.constraint(equalTo: intervalLabel.bottomAnchor, constant: 6),
            intervalField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            intervalField.widthAnchor.constraint(equalToConstant: 60),

            intervalStepper.centerYAnchor.constraint(equalTo: intervalField.centerYAnchor),
            intervalStepper.leadingAnchor.constraint(equalTo: intervalField.trailingAnchor, constant: 6),
        ])
    }

    private func loadSettings() {
        self.infiniteScrollCheckbox.state = SettingsManager.shared.isInfiniteScrollEnabled ? .on : .off
        self.invertScrollCheckbox.state = SettingsManager.shared.isScrollDirectionInverted ? .on : .off
        let interval = SettingsManager.shared.notificationRepeatInterval
        self.intervalField.intValue = Int32(interval)
        self.intervalStepper.intValue = Int32(interval)
    }

    // MARK: - Actions

    @objc private func infiniteScrollChanged() {
        SettingsManager.shared.isInfiniteScrollEnabled = self.infiniteScrollCheckbox.state == .on
    }

    @objc private func invertScrollChanged() {
        SettingsManager.shared.isScrollDirectionInverted = self.invertScrollCheckbox.state == .on
    }

    @objc private func intervalFieldChanged() {
        let value = max(1, self.intervalField.doubleValue)
        self.intervalStepper.doubleValue = value
        SettingsManager.shared.notificationRepeatInterval = value
    }

    @objc private func intervalStepperChanged() {
        let value = self.intervalStepper.doubleValue
        self.intervalField.doubleValue = value
        SettingsManager.shared.notificationRepeatInterval = value
    }
}

final class SettingsWindowController: NSWindowController {

    convenience init() {
        let vc = SettingsViewController()
        let window = NSWindow(contentViewController: vc)
        window.title = "Settings"
        window.styleMask = [.titled, .closable]
        self.init(window: window)
    }
}
