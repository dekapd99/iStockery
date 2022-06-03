//
//  ContentView.swift
//  iStockery
//
//  Created by Deka Primatio on 03/06/22.
//

import FirebaseFirestore
import FirebaseFirestoreSwift // import firestore
import SwiftUI

struct ContentView: View {
    
    // get data dari entitas inventories dengan default sort createdAt dan descending button = aktif
    @FirestoreQuery(collectionPath: "inventories", predicates: [.order(by: SortType.createdAt.rawValue, descending: true)]) private var items: [StockItem]
    
    // konek dengan StockListViewModel yang berisikan fungsi CRUD
    @StateObject private var vm = StockListViewModel()

    
    var body: some View {
        VStack{
            
            // menampilkan error ketika data type tidak dalam format yang sesuai pada StockItem.swift
            if let error = $items.error {
                Text(error.localizedDescription)
            }
            
            // menampilkan data kalo ada stoknya
            if items.count > 0{
                // declare item name di closure parameter
                List{
                    sortBySectionView
                    listItemsSectionView
                }
                .listStyle(.insetGrouped)
            }
        }
        
        // Toggle Edit Mode
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("+"){ vm.addItem() }.font(.title) // tombol add
            }
            
            ToolbarItem(placement: .navigationBarLeading) { EditButton() }
        }
        // setiap klik sort by akan menampilkan perubahan sort itemnya
        .onChange(of: vm.selectedSortType) { _ in onSortTypeChanged()}
        .onChange(of: vm.isDescending) { _ in onSortTypeChanged()}
        .navigationTitle("Stock of Product")
    }
    
    private var listItemsSectionView: some View {
        Section {
            ForEach(items) { item in
                VStack {
                    // getter dan setter method
                    // perubahan pada nama
                    TextField("Name", text: Binding<String>(
                        // get data name
                        get: { item.name },
                        // invoke ke dalam fungsi menghentikan update secara realtime firebase sampai "dipencet enter"
                        set: { vm.editedName = $0 }),
                              onEditingChanged: { vm.onEditingItemNameChanged(item: item, isEditing: $0)}
                    )
                    .disableAutocorrection(true)
                    .font(.headline)
                    
                    // perubahan pada stock quantity
                    Stepper("Quantity: \(item.quantity)",
                        value: Binding<Int>(
                            // get data quantity
                            get: { item.quantity },
                            // invoke ke dalam fungsi
                            set: { vm.updateItem(item, data: ["quantity": $0]) }),
                        in: 0...1000)
                }
            }
            
            // delete item dari indexset
            .onDelete { vm.onDelete(items: items, indexset: $0) }
        }
    }
    
    private var sortBySectionView: some View {
        // section sendiri untuk tombol sort by
        Section {
            DisclosureGroup("Sort by") {
                // invoke ke dalam fungsi sort
                Picker("Sort by", selection: $vm.selectedSortType) {
                    // sort dari setiap item yang ada
                    ForEach(SortType.allCases, id: \.rawValue) { sortType in
                        Text(sortType.text).tag(sortType)
                    }
                }.pickerStyle(.segmented) // segmented control style
                
                // descending toggle
                Toggle("Is Descending", isOn: $vm.isDescending)
            }
        }
    }
    
    // pergantian fungsi sort ascending / descending
    private func onSortTypeChanged(){
        $items.predicates = vm.predicates
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
