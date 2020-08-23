//
//  DayView.swift
//  Calendar Example
//
//  Created by Andrei Chevozerov on 23.08.2020.
//  Copyright © 2020 Example. All rights reserved.
//

import SwiftUI

struct DayView: View {

    let day: Int
    let size: CGFloat
    @Binding var selectedDay: Int

    var body: some View {
        Text("\(day)")
            .frame(width: size, height: size)
            .modifier(SelectionViewModifier(isSelected: day == selectedDay))
            .onTapGesture {
                self.selectedDay = self.day
            }
    }
}

private struct SelectionViewModifier: ViewModifier {
    let isSelected: Bool

    func body(content: Content) -> some View {
        content
            .overlay(Circle()
                .stroke(Color.primary, lineWidth: 1.0)
                .opacity(isSelected ? 1.0 : 0.0)
            )
    }
}

struct DateView_Previews: PreviewProvider {
    static var previews: some View {
        DayView(day: 13, size: 44.0, selectedDay: Binding<Int>(get: { 13 }, set: { _ in }))
    }
}
