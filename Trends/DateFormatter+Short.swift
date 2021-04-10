//
//  DateFormatter+Short.swift
//  Trends
//
//  Created by Kyle Johnson on 4/10/21.
//

import Foundation

extension DateFormatter {
    static var short: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    static var shortTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    static var shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
}
