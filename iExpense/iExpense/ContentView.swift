//
//  ContentView.swift
//  iExpense
//
//  Created by Anup Deshpande on 11/1/20.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable{
    let id = UUID()
    let name: String
    let type: String
    let amount: Int
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem](){
        didSet{
            let encoder = JSONEncoder()
            
            if let encoded = try? encoder.encode(items){
                UserDefaults.standard.setValue(encoded, forKey: "Items")
            }
        }
    }
    
    init(){
        if let items = UserDefaults.standard.data(forKey: "Items"){
            let decoder = JSONDecoder()
            
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items){
                self.items = decoded
                return
            }
        }
        
        self.items = []
    }
}

struct ContentView: View {
    
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView{
            List{
                ForEach(expenses.items){ item in
                    HStack{
                        VStack(alignment: .leading){
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        
                        Spacer()
                        
                        Text("$\(item.amount)")
                    }
                }
                .onDelete(perform: removeItems  )
            }
            
            .navigationBarTitle("iExpense")
            .navigationBarItems(leading: EditButton(),
                                trailing: Button(action: {
                                    showingAddExpense = true
                                }, label: {
                                    Image(systemName: "plus")
                                }))
        }
        .sheet(isPresented: $showingAddExpense){
            AddView(expenses: self.expenses)
        }
    }
    
    func removeItems(at offset: IndexSet){
        expenses.items.remove(atOffsets: offset)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
