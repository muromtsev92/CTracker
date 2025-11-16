//
//  SideMenuView.swift
//  FoodTracker
//
//  Created by Sergei Muromtsev on 16.11.2025.
//


import SwiftUI

struct SideMenuView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Каталог блюд") {
                    Text("Dish list placeholder")
                }
                NavigationLink("Настройки") {
                    Text("Settings placeholder")
                }
                NavigationLink("О приложении") {
                    Text("About placeholder")
                }
            }
            .navigationTitle("Меню")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Закрыть") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SideMenuView()
}
