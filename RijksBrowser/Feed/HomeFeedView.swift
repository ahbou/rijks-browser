//
//  HomeFeedView.swift
//  Rijksmuseum

import Foundation
import SwiftUI

struct HomeFeedView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                ImagesGridView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarTitle("Explore", displayMode: .large)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeFeedView()
    }
}
