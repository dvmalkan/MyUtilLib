//
//  Measure.swift
//  MyUtilLib
//
//  Created by Deepak Malkan on 11/5/24.
//
import Foundation

public func measure (title: String?, call: () -> Void) {
    let startTime = DispatchTime.now ()
    
    call ()
    
    let endTime = DispatchTime.now ()
    if let title = title {
        debugPrint("Measurement of **\(title)** ")
    }
    
    // Difference in nano seconds (UInt64)
    let nanoTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
    let timeInterval = Double(nanoTime) / 1_000_000_000
    debugPrint ("Time taken : \(timeInterval) seconds")
}

@available(iOS 13.0.0, *)
public func measureAsync (title: String?, call: () async -> Void) async {
    let startTime = DispatchTime.now ()
    
    await call ()
    
    let endTime = DispatchTime.now ()
    if let title = title {
        debugPrint("Measurement of **\(title)** ")
    }
    
    // Difference in nano seconds (UInt64)
    let nanoTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
    let timeInterval = Double(nanoTime) / 1_000_000_000
    debugPrint ("Time taken : \(timeInterval) seconds")
}
