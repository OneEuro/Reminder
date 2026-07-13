import Cocoa

class SettingsViewController: NSViewController {

    // MARK: - Properties

    private let infiniteScrollCheckbox = NSButton(checkboxWithTitle: "Infinite scroll", target: nil, action: nil)
    private let invertScrollCheckbox = NSButton(checkboxWithTitle: "Invert scroll direction", target: nil, action: nil)

    // MARK: - Lifecycle

    override func loadView() {
        self.view = NSView(frame: NSRect(x: 0, y: 0, width: 300, height: 150))
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
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            infiniteScrollCheckbox.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24),
            infiniteScrollCheckbox.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),

            invertScrollCheckbox.topAnchor.constraint(equalTo: infiniteScrollCheckbox.bottomAnchor, constant: 12),
            invertScrollCheckbox.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
        ])
    }

    private func loadSettings() {
        self.infiniteScrollCheckbox.state = SettingsManager.shared.isInfiniteScrollEnabled ? .on : .off
        self.invertScrollCheckbox.state = SettingsManager.shared.isScrollDirectionInverted ? .on : .off
    }

    // MARK: - Actions

    @objc private func infiniteScrollChanged() {
        SettingsManager.shared.isInfiniteScrollEnabled = self.infiniteScrollCheckbox.state == .on
    }

    @objc private func invertScrollChanged() {
        SettingsManager.shared.isScrollDirectionInverted = self.invertScrollCheckbox.state == .on
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
