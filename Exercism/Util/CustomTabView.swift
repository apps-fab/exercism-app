//
//  CustomTabBar.swift
//  Exercism
//
//  Created by Angie Mugo on 15/08/2023.
//

import SwiftUI

public enum TabBarPosition {
    case top
    case bottom
}

public struct CustomTabView<TabItem: Tabbable, Content: View>: View {
    private let selectedItem: TabBarSelection<TabItem>
    private var tabBarPosition: TabBarPosition
    private let content: Content
    @State private var items: [TabItem]
    let gradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.appAccent.opacity(0.4),
            Color.appAccent.opacity(0.6),
            Color.appAccent.opacity(0.8),
            Color.appAccent
        ]),
        startPoint: .top,
        endPoint: .bottom
    )

    public init(selectedItem: Binding<TabItem>,
                tabBarPosition: TabBarPosition = .top,
                @ViewBuilder content: () -> Content) {
        self.selectedItem = .init(selection: selectedItem)
        self.content = content()
        self.tabBarPosition = tabBarPosition
        self._items = .init(initialValue: .init())
    }

    public var tabItems: some View {
        HStack(spacing: 0) {
            ForEach(self.items.indices, id: \.self) { index in
                ZStack {
                    if selectedItem.selection == items[index] {
                        gradient.edgesIgnoringSafeArea(.all)
                    }
                    HStack {
                        Image(systemName: items[index].icon)
                            .accessibilityHidden(true)
                        Text(items[index].title)
                            .font(.subheadline)
                            .accessibilityLabel(items[index].title)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedItem.selection = items[index]
                        selectedItem.objectWillChange.send()
                    }
                }

                if index < items.count - 1 {
                    Divider()
                        .frame(width: 2, height: 40)
                }
            }
        }
        .frame(height: 50)
        .background(Color.gray.opacity(0.2))
    }

    public var body: some View {
        Group {
            if tabBarPosition == .top {
                VStack(spacing: 0) {
                    Spacer()
                    Divider().frame(height: 2)
                    tabItems
                    Divider().frame(height: 2)
                    ZStack {
                        content
                            .font(.callout)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .environmentObject(selectedItem)
            } else {
                VStack(spacing: 0) {
                    ZStack {
                        content
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    tabItems
                }
                .environmentObject(selectedItem)
            }
        }.onPreferenceChange(TabBarPreferenceKey.self) { value in
            items = value
        }
    }

}
