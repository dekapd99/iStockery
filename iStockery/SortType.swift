//
//  SortType.swift
//  iStockery
//
//  Created by Deka Primatio on 03/06/22.
//

import Foundation

// Data Attribute dari Collection Firestore yang digunakan
enum SortType: String, CaseIterable {
    
    case createdAt
    case updatedAt
    case name
    case quantity
    
    // Return Collection yang sudah tersimpan di Firestore ke Aplikasi
    var text: String {
        switch self {
        case .createdAt: return "Created At"
        case .updatedAt: return "Updated At"
        case .name: return "Name"
        case .quantity: return "Quantity"
        }
    }
    
}
