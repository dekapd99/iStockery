//
//  inventoryItem.swift
//  iStockery
//
//  Created by Deka Primatio on 03/06/22.
//

import Foundation
import FirebaseFirestoreSwift

struct InventoryItem: Identifiable, Codable {
    
    @DocumentID var id: String?
    
    @ServerTimestamp var createdAt: Date?
    @ServerTimestamp var updatedAt: Date?
    
    var name: String
    var quantity: Int
}
