//
//  BookDetailView.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 23/8/22.
//

import SwiftUI
import Kingfisher

struct BookDetailView: View {
    
    @ObservedObject var viewModel: BookDetailVM
    weak var navigationController: UINavigationController?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let url = viewModel.details.imageUrl {
                    imageContainer(url: url, height: geometry.size.height * 0.5)
                }

                textsStack(
                    width: geometry.size.width,
                    topMargin: geometry.size.height * 0.35
                )

                topGradient(width: geometry.size.width)
            }
        }
    }

    func imageContainer(url: URL, height: CGFloat) -> some View {
        return VStack {
            KFImage(url)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxHeight: height)
                .accessibilityLabel("movie_detail_image")
            Spacer()
        }
    }

    func textsStack(width: CGFloat, topMargin: CGFloat) -> some View {
        return VStack {
            Spacer(minLength: topMargin)
            VStack {
                Text(viewModel.details.title)
                    .font(.title)
                    .accessibilityLabel("movie_detail_title")
                    .padding()
                Text(viewModel.details.bookDescription)
                    .font(.body)
                    .accessibilityLabel("movie_detail_summary")
                    .padding()
                Spacer()
            }
            .frame(width: width)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    func topGradient(width: CGFloat) -> some View {
        let gradient = LinearGradient(
            gradient: Gradient(stops: [
                .init(color: .clear, location: 0.6),
                .init(color: .white, location: 1.0),
            ]),
            startPoint: .bottom,
            endPoint: .top
        )

        return VStack {
            VStack {}
                .frame(width: width, height: 180)
                .background(gradient)
            Spacer()
        }
        .ignoresSafeArea()
    }
}

#if DEBUG
struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(viewModel: BookDetailVM(bookDetails: ListItem.mocked()))
    }
}
#endif
