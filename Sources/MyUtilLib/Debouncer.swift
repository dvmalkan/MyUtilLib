//
//  Debouncer.swift
//  MyUtilLib
//
//  Created by Deepak Malkan on 12/23/24.
//
import Foundation

// Adapted from: https://betterprogramming.pub/implement-a-debouncer-in-swift-3b5c775f90b8
public class Debouncer {
    private let timeInterval: TimeInterval
    private var timer: Timer?
    
    public typealias Handler = () -> Void
    public var handler: Handler?
    
    public init (timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    public func renewInterval () {
        timer?.invalidate ()
        timer = Timer.scheduledTimer (timeInterval: timeInterval, target: self, selector: #selector (self.timeIntervalDidFinish(_:)), userInfo: nil, repeats: false)
    }
    
    @objc private func timeIntervalDidFinish (_ timer: Timer) {
        guard timer.isValid else { return }
        handler? ()
        handler = nil
    }
    
}
