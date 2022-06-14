//
//  ContentView.swift
//  iStockery
//
//  Created by Deka Primatio on 03/06/22.
//

import FirebaseFirestore
import FirebaseFirestoreSwift // import firestore
import SwiftUI

// Tampilan Halaman Beranda
struct ContentView: View {
    // Get data dari entitas inventories
    // Default Sort Terbaru (createdAt | descending)
    // Sesuaikan dengan Line 16 di StockListViewModel.swift
    @FirestoreQuery(collectionPath: "inventories", predicates: [.order(by: SortType.createdAt.rawValue, descending: true)]) private var items: [StockItem]
    
    // StateObject
    @StateObject private var vm = StockListViewModel()
    
    var body: some View {
        VStack{
            // Tampilkan error jika tipe data tidak sesuai pada StockItem.swift
            if let error = $items.error {
                Text(error.localizedDescription)
            }
            
            // Tampilkan Item ketika ada Stoknya (Stok Item > 0)
            if items.count > 0{
                // Parameter Enclosure: untuk view List
                List{ // List berisikan Section & Hasil Sort Section
                    listItemsSectionView    // Tampilkan Section Item Satuan
                    sortBySectionView       // Sorted Section Item
                }
                .listStyle(.insetGrouped)
            }
        }
        .toolbar{ // Tombol Toggle Edit Mode
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("+"){ vm.addItem() }.font(.title)
            }
            ToolbarItem(placement: .navigationBarLeading) { EditButton() }
        }
        // Setiap klik "Sort By" -> Tampilkan Hasil Sort-nya
        .onChange(of: vm.selectedSortType) { _ in onSortTypeChanged()}
        .onChange(of: vm.isDescending) { _ in onSortTypeChanged()}
        .navigationTitle("Stok Barang")
    }
    
    // Tampilan Section Item
    private var listItemsSectionView: some View {
        Section {
            // ForEach -> Untuk Setiap Item
            ForEach(items) { item in
                VStack {
                    // Forms: Nama Barang (Getter & Setter)
                    TextField("Nama Barang", text: Binding<String>(
                        get: { item.name }, // Getter Nama Item dari Server
                        // Setter untuk Stop Update Secara Realtime Sampai Tombol "Enter" ditekan
                        set: { vm.editedName = $0 }),
                              onEditingChanged: { vm.onEditingItemNameChanged(item: item, isEditing: $0)}
                    )
                    .disableAutocorrection(true) // No Auto Correct
                    .font(.headline)
                    
                    // Forms: Jumlah Barang (Getter & Setter)
                    Stepper("Jumlah: \(item.quantity)",
                        value: Binding<Int>(
                            get: { item.quantity }, // Getter Quantity Item dari Server
                            // Setter untuk Update jika ada Perubahan ke Server
                            set: { vm.updateItem(item, data: ["quantity": $0]) }),
                        in: 0...1000)
                }
            }
            // Tombol Delete dengan Fungsi-nya dari ViewModel
            .onDelete { vm.onDelete(items: items, indexset: $0) }
        }
    }
    
    // Tampilan Sort By
    private var sortBySectionView: some View {
        Section {
            // Group untuk Tombol Sort By
            DisclosureGroup("Sort by") {
                // Sort Item sesuai dengan Tipe Sort yang dipilih
                Picker("Sort by", selection: $vm.selectedSortType) {
                    ForEach(SortType.allCases, id: \.rawValue) { sortType in
                        Text(sortType.text).tag(sortType)
                    }
                }.pickerStyle(.segmented)
                // Tombol Descending dengan Fungsi-nya dari ViewModel
                Toggle("Is Descending", isOn: $vm.isDescending)
            }
        }
    }
    
    // Perubahan pergantian tipe Sort terhadap Items
    private func onSortTypeChanged() {
        $items.predicates = vm.predicates
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
