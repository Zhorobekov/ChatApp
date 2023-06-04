//
//  DateFormatterFactory.swift
//  ChatApp
//
//  Created by Эрмек Жоробеков on 13.03.2023.
//

import Foundation

final class DateFormatterFactory {

    private static var formatters: [String: DateFormatter] = [:]
    
    static func formatter(with format: String) -> DateFormatter {
                
        if let formatter = formatters[format] {
            return formatter
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en")
        formatters[format] = formatter
        
        return formatter
    }
}
