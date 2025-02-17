//
//  PickerView.swift
//  Reminder
//
//  Created by Владимир Малышев on 19.03.2024.
//

import Foundation
import Cocoa

// Custom view for picking minutes
class MinutePickerView: NSView {
    // Properties
    var selectedMinute: Int = 0
    let minutesInHour = 60
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here
    }
    
    override func mouseDown(with event: NSEvent) {
        let location = convert(event.locationInWindow, from: nil)
        let minuteIncrement = bounds.height / CGFloat(minutesInHour)
        let selectedMinuteIndex = Int(location.y / minuteIncrement)
        selectedMinute = selectedMinuteIndex
        needsDisplay = true // Trigger redraw
    }
}

// Custom view for picking hours
class HourPickerView: NSView {
    // Properties
    var selectedHour: Int = 0
    let hoursInDay = 24
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here
    }
    
    override func mouseDown(with event: NSEvent) {
        let location = convert(event.locationInWindow, from: nil)
        let hourIncrement = bounds.height / CGFloat(hoursInDay)
        let selectedHourIndex = Int(location.y / hourIncrement)
        selectedHour = selectedHourIndex
        needsDisplay = true // Trigger redraw
    }
}

// Custom view for picking seconds
class SecondPickerView: NSView {
    // Properties
    var selectedSecond: Int = 0
    let secondsInMinute = 60
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here
    }
    
    override func mouseDown(with event: NSEvent) {
        let location = convert(event.locationInWindow, from: nil)
        let secondIncrement = bounds.height / CGFloat(secondsInMinute)
        let selectedSecondIndex = Int(location.y / secondIncrement)
        selectedSecond = selectedSecondIndex
        needsDisplay = true // Trigger redraw
    }
}

// Combining the above three views to form a complete date and time picker
class DateTimePickerView: NSView {
    // Properties
    let minutePickerView = MinutePickerView()
    let hourPickerView = HourPickerView()
    let secondPickerView = SecondPickerView()
    var selectedDateComponents: DateComponents {
        var dateComponents = DateComponents()
        dateComponents.minute = minutePickerView.selectedMinute
        dateComponents.hour = hourPickerView.selectedHour
        dateComponents.second = secondPickerView.selectedSecond
        return dateComponents
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Draw the date and time picker, combining the three picker views
        // Position and layout the picker views
        // For example:
        let margin: CGFloat = 20
        let pickerWidth: CGFloat = 50
        let pickerHeight: CGFloat = 200
        let spacing: CGFloat = 20
        minutePickerView.frame = NSRect(x: margin, y: margin, width: pickerWidth, height: pickerHeight)
        hourPickerView.frame = NSRect(x: margin + pickerWidth + spacing, y: margin, width: pickerWidth, height: pickerHeight)
        secondPickerView.frame = NSRect(x: margin + 2 * (pickerWidth + spacing), y: margin, width: pickerWidth, height: pickerHeight)
        
        // Add picker views to subviews
        addSubview(minutePickerView)
        addSubview(hourPickerView)
        addSubview(secondPickerView)
    }
    
    override func mouseDown(with event: NSEvent) {
        // Forward mouse events to the corresponding picker views
        let location = convert(event.locationInWindow, from: nil)
        if minutePickerView.frame.contains(location) {
            minutePickerView.mouseDown(with: event)
        } else if hourPickerView.frame.contains(location) {
            hourPickerView.mouseDown(with: event)
        } else if secondPickerView.frame.contains(location) {
            secondPickerView.mouseDown(with: event)
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        // Forward mouse drag events to the corresponding picker views
        let location = convert(event.locationInWindow, from: nil)
        if minutePickerView.frame.contains(location) {
            minutePickerView.mouseDragged(with: event)
        } else if hourPickerView.frame.contains(location) {
            hourPickerView.mouseDragged(with: event)
        } else if secondPickerView.frame.contains(location) {
            secondPickerView.mouseDragged(with: event)
        }
    }
}
