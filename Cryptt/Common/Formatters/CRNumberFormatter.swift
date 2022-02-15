//
//  CRNumberFormatter.swift
//  Cryptt
//
//  Created by Oleh Zahoriansky on 15.02.2022.
//

import Foundation

class CRNumberFormatter {
    private static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        return formatter
    }()
    
    private static let percentsFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.multiplier = 1.0
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.positivePrefix = formatter.plusSign
        return formatter
    }()
    
    public static func formatCurrency(_ value: Double?) -> String {
        guard let value = value else {
            return ""
        }

        return currencyFormatter.string(from: NSNumber(value: value)) ?? ""
    }
    
    public static func formatPercents(_ value: Double?) -> String {
        guard let value = value else {
            return ""
        }

        return percentsFormatter.string(from: NSNumber(value: value)) ?? ""
    }
    
    private init() { }
}
