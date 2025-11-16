import SwiftUI
import SwiftData

struct DishListView: View {

    @Environment(\.modelContext) private var context

    @Query(sort: \Dish.title, order: .forward)
    private var dishes: [Dish]

    @State private var showAddDish = false
    @State private var dishTitle = ""
    @State private var dishCalories = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(dishes) { dish in
                    NavigationLink {
                        EditDishView(dish: dish)
                    } label: {
                        HStack {
                            Text(dish.title)
                            Spacer()
                            Text("\(dish.calories) ккал")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Блюда")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddDish = true
                        dishTitle = ""
                        dishCalories = ""
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddDish) {
                addDishSheet
            }
        }
    }

    // MARK: - Add Dish Form

    private var addDishSheet: some View {
        NavigationStack {
            Form {
                TextField("Название", text: $dishTitle)
                TextField("Калории", text: $dishCalories)
                    .keyboardType(.numberPad)
            }
            .navigationTitle("Новое блюдо")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        showAddDish = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Готово") {
                        addDish()
                        showAddDish = false
                    }
                    .disabled(!canAdd)
                }
            }
        }
    }

    private var canAdd: Bool {
        !dishTitle.trimmingCharacters(in: .whitespaces).isEmpty &&
        Int(dishCalories) != nil
    }

    private func addDish() {
        guard let cal = Int(dishCalories) else { return }
        let dish = Dish(title: dishTitle.trimmingCharacters(in: .whitespaces), calories: cal)
        context.insert(dish)
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            context.delete(dishes[index])
        }
    }
}

#Preview {
    DishListView()
        .modelContainer(for: [Dish.self, EatenMeal.self])
}
