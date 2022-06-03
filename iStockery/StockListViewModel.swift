//
//  StockListViewModel.swift
//  iStockery
//
//  Created by Deka Primatio on 03/06/22.
//

import FirebaseFirestore
import SwiftUI
import FirebaseFirestoreSwift

// Refactor fungsi CRUD yang awalnya dari ContentView
class StockListViewModel: ObservableObject{
    
    // get collection data dari nama entitas di Firebase
    private let db = Firestore.firestore().collection("inventories")
    
    @Published var selectedSortType = SortType.createdAt // default value ketika awal membuka sort by
    @Published var isDescending = true // default value Descending selalu aktif
    @Published var editedName = "" // simpan edited name yang telah diganti
    
    // komputasi predicates untuk sorting
    var predicates: [QueryPredicate] { [.order(by: selectedSortType.rawValue, descending: isDescending)] }
    
    // fungsi tambah item baru
    func addItem(){
        
        // default item baru
        let item = StockItem(name: "New Item", quantity: 1)
        _ = try? db.addDocument(from: item) // generate oleh server
    }
    
    // fungsi update data
    func updateItem(_ item: StockItem, data: [String: Any]){
        guard let id = item.id else { return }
        var _data = data // copy data ke mutable var data
        _data["updatedAt"] = FieldValue.serverTimestamp() // inject data
        db.document(id).updateData(_data) // invoke update data dan passing ke _data
    }
    
    // fungsi delete data
    func onDelete(items: [StockItem], indexset: IndexSet) {
        
        // fungsi for untuk delete berdasarkan index-nya
        for index in indexset {
            guard let id = items[index].id else{ continue }
            db.document(id).delete() // passing delete item berdasarkan id nya
            
        }
    }
    
    // fungsi untuk menghilangkan jumping sort ketika sedang mengedit nama item
    func onEditingItemNameChanged(item: StockItem, isEditing: Bool){
        
        // ketika sedang mengedit nama item, jangan langsung di store ke dalam database
        if !isEditing {
            if item.name != editedName {
                updateItem(item, data: ["name": editedName]) // invoke edit item ke dalam edited name
            }
            editedName = ""
        } else {
            editedName = item.name // ketika user fokus (mengedit) maka nama akan di simpan
        }
    }
}
