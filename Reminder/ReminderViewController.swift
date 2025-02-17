//
//  ReminderViewController.swift
//  Reminder
//
//  Created by Владимир Малышев on 03.07.2023.
//

import Cocoa
 
class ReminderViewController: NSViewController {
    @IBOutlet weak var timeIntervalTextField: NSTextField!
    @IBOutlet weak var countdownLabel: NSTextField!
//    var pickerView: NSView = {
//        let pickerView = DateTimePickerView(frame: NSRect(x: 10, y: 50, width: 100, height: 100))
//        return pickerView
//    }()
    
    @IBOutlet weak var timerPickerLabel: NSTextField!
    @IBOutlet weak var timePicker: NSDatePicker!
    var timerConfiguration = TimerConfiguration()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationItem.createRequestAuthorization()
        timerConfiguration.reminderViewController = self
        
//        view.addSubview(pickerView)
    }

    @IBAction func setReminder(_ sender: NSButton) {
        timerConfiguration.updateTimeInterval(with: timeIntervalTextField.stringValue)
        timerConfiguration.createTimer()
        timerConfiguration.createCountdownTimer()
        
        let minutes = timePicker.dateValue.timeIntervalSinceNow
        print(minutes)
        let seconds = timePicker.timeInterval
//        let hour = minutes / 60.0
//        timerPickerLabel.stringValue = String(format: "%02d:%02d:%02d", minutes, seconds, hour)

    }
    
    @IBAction func stopTimer(_ sender: NSButton) {
        timerConfiguration.timer?.invalidate()
        timerConfiguration.countdownTimer?.invalidate()
        timerConfiguration.timer = nil
        timerConfiguration.countdownTimer = nil
    }
    
    @IBAction func closeProgram(_ sender: Any) {
        NSApp.terminate(sender)
    }
    func updateCountdownLabel(remainingTime:TimeInterval) {
        let minutes = Int(remainingTime) / 60
        let seconds = Int(remainingTime) % 60
        countdownLabel.stringValue = String(format: "%02d:%02d", minutes, seconds)
    }
    
    func createPickerView() {
       
    }
    
    
}
    
