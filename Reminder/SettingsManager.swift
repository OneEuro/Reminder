import DrumrollTimePicker
import Foundation

final class SettingsManager {

    static let shared = SettingsManager()

    private let defaults = UserDefaults.standard

    var isInfiniteScrollEnabled: Bool {
        get { defaults.bool(forKey: "isInfiniteScrollEnabled") }
        set {
            defaults.set(newValue, forKey: "isInfiniteScrollEnabled")
            apply()
        }
    }

    var isScrollDirectionInverted: Bool {
        get { defaults.bool(forKey: "isScrollDirectionInverted") }
        set {
            defaults.set(newValue, forKey: "isScrollDirectionInverted")
            apply()
        }
    }

    var notificationRepeatInterval: TimeInterval {
        get { defaults.double(forKey: "notificationRepeatInterval") }
        set { defaults.set(newValue, forKey: "notificationRepeatInterval") }
    }

    private var timePickers: [DrumrollTimePicker] = []

    private init() {
        registerDefaults()
    }

    private func registerDefaults() {
        defaults.register(defaults: [
            "isInfiniteScrollEnabled": false,
            "isScrollDirectionInverted": true,
            "notificationRepeatInterval": 3.0,
        ])
    }

    func register(_ timePicker: DrumrollTimePicker) {
        self.timePickers.append(timePicker)
        apply(to: timePicker)
    }

    func apply() {
        for picker in self.timePickers {
            apply(to: picker)
        }
    }

    func apply(to timePicker: DrumrollTimePicker) {
        timePicker.isInfiniteScrollEnabled = self.isInfiniteScrollEnabled
        timePicker.isScrollDirectionInverted = self.isScrollDirectionInverted
    }
}
