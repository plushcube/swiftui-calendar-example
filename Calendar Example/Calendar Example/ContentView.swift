//
//  ContentView.swift
//  Calendar Example
//
//  Created by Andrei Chevozerov on 23.08.2020.
//  Copyright © 2020 Example. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @State private var date = Date()
    @State private var isCalendarShown: Bool = false

    private let formatter: DateFormatter = {
        let object = DateFormatter()
        object.dateStyle = .medium
        return object
    }()

    var body: some View {
        HStack {
            Text("Selected date: \(date, formatter: formatter)")
            Button(action: { self.isCalendarShown = true }) {
                Image(systemName: "calendar")
                    .resizable()
                    .frame(width: 24.0, height: 24.0)
            }
        }
        .sheet(isPresented: $isCalendarShown) {
            DateSelectionView(selectedDate: self.$date)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
