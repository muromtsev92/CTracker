//
//  DayView.swift
//  FoodTracker
//
//  Created by Sergei Muromtsev on 16.11.2025.
//


import SwiftUI
import SwiftData

struct DayView: View {

    @Environment(\.modelContext) private var context

    // выбранная дата
    @State private var selectedDate = Calendar.current.startOfDay(for: Date())

    // открыть/закрыть меню
    @State private var showMenu = false

    // список записей (сюда подгрузим через init)
    @Query private var eatenToday: [EatenMeal]

    init() {
        // Фильтр по дате будет обновляться при смене даты
        let today = Calendar.current.startOfDay(for: Date())

        _eatenToday = Query(
            filter: #Predicate<EatenMeal> { meal in
                meal.date == today
            },
            sort: \.time,
            order: .reverse
        )
    }

    var body: some View {
        NavigationStack {
            VStack {

                // MARK: - Date Header
                HStack {
                    Button(action: { changeDay(-1) }) {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                    }

                    Spacer()

                    Text(dateString(selectedDate))
                        .font(.title3)
                        .fontWeight(.semibold)

                    Spacer()

                    Button(action: { changeDay(1) }) {
                        Image(systemName: "chevron.right")
                            .font(.title3)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)

                // MARK: - Total
                HStack {
                    Text("Итого:")
                    Spacer()
                    Text("\(totalCalories) ккал")
                        .font(.title3)
                        .fontWeight(.bold)
                }
                .padding(.horizontal)
                .padding(.vertical, 4)

                // MARK: - List of eaten meals
                List {
                    ForEach(eatenToday) { item in
                        HStack {
                            Text(item.dish.title)
                            Spacer()
                            Text("\(item.dish.calories) ккал")
                        }
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(.plain)

                // MARK: - Add button
                Button(action: { /* откроем выбор блюда позже */ }) {
                    Text("Добавить")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.bottom)
                }

            }
            .navigationTitle("Учёт питания")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showMenu.toggle() }) {
                        Image(systemName: "line.3.horizontal")
                    }
                }
            }
            .sheet(isPresented: $showMenu) {
                SideMenuView()
            }
        }
    }

    // MARK: - Logic

    private func changeDay(_ offset: Int) {
        if let newDate = Calendar.current.date(byAdding: .day, value: offset, to: selectedDate) {
            selectedDate = Calendar.current.startOfDay(for: newDate)
        }
    }

    private func dateString(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "d MMM yyyy"
        return f.string(from: date)
    }

    private var totalCalories: Int {
        eatenToday.reduce(0) { $0 + $1.dish.calories }
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            context.delete(eatenToday[index])
        }
    }
}

#Preview {
    DayView()
        .modelContainer(for: [Dish.self, EatenMeal.self])
}
