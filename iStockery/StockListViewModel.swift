//
//  StockListViewModel.swift
//  iStockery
//
//  Created by Deka Primatio on 03/06/22.
//

import SwiftUI
import FirebaseFirestore        // Mengaktifkan library Firebase Firestore
import FirebaseFirestoreSwift   // Mengaktifkan library Firebase Firestore untuk Swift

// Berisikan Fungsi CRUD
class StockListViewModel: ObservableObject{
    
    // Get collection data dari nama entitas "inventories" di Firebase
    private let db = Firestore.firestore().collection("inventories") // Bisa diganti sesuai keinginan
    
    @Published var selectedSortType = SortType.createdAt // Default: Sort by createdAt
    @Published var isDescending = true // Default: Sort secara Descending
    @Published var editedName = "" // Default: Edit Nama Item
    
    // Komputasi Predicate Sorting
    var predicates: [QueryPredicate] { [.order(by: selectedSortType.rawValue, descending: isDescending)] }
    
    // Fungsi Menambahkan Item Baru
    func addItem(){
        let item = StockItem(name: "New Item", quantity: 1) // Default: Form Item Baru
        _ = try? db.addDocument(from: item) // Tambahkan Item Baru ke Database Server
    }
    
    // Fungsi Update Item
    func updateItem(_ item: StockItem, data: [String: Any]){
        guard let id = item.id else { return } // Get ID dari Item yang diubah
        var _data = data // Copy data ke mutable var data
        _data["updatedAt"] = FieldValue.serverTimestamp() // Simpan Modifikasi Data Item ke serverTimestamp
        db.document(id).updateData(_data) // Perbarui Data Item Tersebut di Database Server
    }
    
    // Fungsi Delete Item
    func onDelete(items: [StockItem], indexset: IndexSet) {
        // Delete berdasarkan ID-nya (Di cari melalui Index didalam IndexSet)
        for index in indexset {
            guard let id = items[index].id else{ continue } // Get ID dari Item by Index Position
            db.document(id).delete() // Hapus Data Item dari Database Server berdasarkan ID-nya
        }
    }
    
    // Fungsi untuk menghilangkan jumping sort ketika sedang mengedit nama item
    func onEditingItemNameChanged(item: StockItem, isEditing: Bool){
        if !isEditing { // Ketika sudah selesai mengedit, simpan nama Item atau tidak ada yang tersimpan
            if item.name != editedName {
                updateItem(item, data: ["name": editedName]) // Perbarui Data Item Tersebut di Database Server
            }
            editedName = "" // Tidak ada data baru yang disimpan
        } else { // Ketika sedang mengedit, maka biarkan (jangan simpan ke Database Server)
            editedName = item.name
        }
    }
}
