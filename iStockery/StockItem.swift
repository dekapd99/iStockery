//
//  StockItem.swift
//  iStockery
//
//  Created by Deka Primatio on 03/06/22.
//

import Foundation
import FirebaseFirestoreSwift // Mengaktifkan library Firebase Firestore untuk Swift

// Deklarasi Attribute dari Firestore Collection & Dari Aplikasi
struct StockItem: Identifiable, Codable {
    
    // Deklarasi Atribute Baru untuk Aplikasi
    @DocumentID var id: String? // Generate Unique ID ketika tidak tidak memiliki ID
    @ServerTimestamp var createdAt: Date? // Inject Data ke Server setiap ada Data Baru
    @ServerTimestamp var updatedAt: Date? // Inject Data ke Server setiap ada Data Baru
    
    // Deklarasi Attribute yang digunakan dari Firestore Collection
    let name: String
    let quantity: Int
}
