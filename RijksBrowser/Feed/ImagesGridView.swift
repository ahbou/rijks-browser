//
//  ImagesGridView.swift
//  Rijksmuseum

import CommonUI
import Foundation
import SwiftUI

/// Searchable vertical grid of images
struct ImagesGridView: View {
    /// Feed View Model
    @ObservedObject var viewModel = HomeFeedModel()
    /// Device orientation holder
    @State private var orientation = UIDevice.current.orientation
    /// Computed grid layout
    private let layout: [GridItem] = {
        var itemsCount: CGFloat
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            itemsCount = UIDevice.current.orientation.isLandscape ? 6 : 4
        default:
            itemsCount = 2
        }

        let maxWidth = UIScreen.main.bounds.width / itemsCount
        return Array(
            repeating: GridItem(.adaptive(minimum: 120, maximum: maxWidth)),
            count: Int(itemsCount)
        )
    }()

    var body: some View {
        SearchBar(text: $viewModel.query)
        LazyVGrid(columns: layout) {
            ForEach(viewModel.objects, id: \.id) { artObject in
                RemoteImageView(artObject.webImage.url)
                    .aspectRatio(1, contentMode: .fit)
                    .padding(.all, 8)
                    .onAppear {
                        viewModel.loadMoreIfNeeded(from: artObject)
                    }
                    .id(artObject.id)
            }
        }
        .onRotate { newOrientation in
            orientation = newOrientation
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.black)
            }
        }
    }
}
