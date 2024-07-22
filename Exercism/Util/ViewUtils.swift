//
// Created by Kirk Agbenyegah on 01/10/2022.
//

import Foundation
import SwiftUI

extension View {
    func roundEdges(
        backgroundColor: some View = Color.clear,
        lineColor: Color = .gray,
        borderWidth: CGFloat = 1,
        cornerRadius: CGFloat = 20
    ) -> some View {
        modifier(
            RoundedRect(
                radius: cornerRadius,
                borderColor: lineColor,
                backgroundView: backgroundColor,
                borderWidth: borderWidth
            )
        )
    }
    
    #if os(macOS)
    func tooltip(_ tip: String) -> some View {
        ZStack {
            background(GeometryReader { childGeometry in
                TooltipView(tip, geometry: childGeometry) {
                    self
                }
            })
        }
    }
    #endif

    func placeholder(when shouldShow: Bool, alignment: Alignment = .leading, placeholderText: String) -> some View {
        ZStack(alignment: alignment) {
            Text(placeholderText)
                .foregroundColor(.gray)
                .opacity(shouldShow ? 1 : 0)
            self
        }
    }

    @MainActor public func tabItem<TabItem: Tabbable>(for item: TabItem) -> some View {
        return self.modifier(TabBarViewModifier(item: item))
    }
}

#if os(macOS)

private struct TooltipView<Content: View>: View {
    let content: () -> Content
    let tip: String
    let geometry: GeometryProxy
    
    init(_ tip: String, geometry: GeometryProxy, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.tip = tip
        self.geometry = geometry
    }
    
    var body: some View {
        Tooltip(tip, content)
            .frame(width: geometry.size.width, height: geometry.size.height)
    }
}

private struct Tooltip<Content: View>: NSViewRepresentable {
    typealias NSViewType = NSHostingView<Content>
    
    init(_ text: String?, @ViewBuilder _ content: () -> Content) {
        self.text = text
        self.content = content()
    }
    
    let text: String?
    let content: Content
    
    func makeNSView(context _: Context) -> NSHostingView<Content> {
        NSViewType(rootView: content)
    }
    
    func updateNSView(_ nsView: NSHostingView<Content>, context _: Context) {
        nsView.rootView = content
        nsView.toolTip = text
    }
}
#endif


private struct TabBarViewModifier<TabItem: Tabbable>: ViewModifier {
    @EnvironmentObject private var selectionObject: TabBarSelection<TabItem>

    let item: TabItem

    func body(content: Content) -> some View {
        Group {
            if self.item == self.selectionObject.selection {
                content
            } else {
                Color.clear
            }
        }.preference(key: TabBarPreferenceKey.self, value: [self.item])
    }
}


class TabBarSelection<TabItem: Tabbable>: ObservableObject {
    @Binding var selection: TabItem

    init(selection: Binding<TabItem>) {
        self._selection = selection
    }
}

public protocol Tabbable: Hashable {
    var icon: String { get }
    var selectedIcon: String { get }
    var title: String { get }
}

public extension Tabbable {
    var selectedIcon: String {
        return self.icon
    }
}

struct TabBarPreferenceKey<TabItem: Tabbable>: PreferenceKey {
    static var defaultValue: [TabItem] {
        return .init()
    }

    static func reduce(value: inout [TabItem], nextValue: () -> [TabItem]) {
        value.append(contentsOf: nextValue())
    }
}
