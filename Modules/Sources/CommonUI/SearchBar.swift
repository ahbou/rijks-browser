import Combine
import SwiftUI

public struct SearchBar: View {
    @Binding var text: String

    public init(text: Binding<String>) {
        self._text = text
    }

    public var body: some View {
        HStack {
            TextField("Search...", text: $text)
                .padding(8)
                .padding(.horizontal, 25)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                    }
                )
                .padding(.horizontal, 10)
        }
    }
}
