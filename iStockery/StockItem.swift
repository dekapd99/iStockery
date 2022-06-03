//
//  StockItem.swift
//  iStockery
//
//  Created by Deka Primatio on 03/06/22.
//

import Foundation
import FirebaseFirestoreSwift // import firestore

struct StockItem: Identifiable, Codable {
    
    // special property wrapper
    @DocumentID var id: String? // setiap kali id bernilai nill firebase akan generate unique standar document id buat kita
    @ServerTimestamp var createdAt: Date? // firebase akan inject data setiap data sync dengan server
    @ServerTimestamp var updatedAt: Date? // firebase akan inject data setiap data sync dengan server
    
    let name: String
    let quantity: Int
}
