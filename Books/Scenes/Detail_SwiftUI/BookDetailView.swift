//
//  BookDetailView.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 23/8/22.
//

import Kingfisher
import SwiftUI

struct BookDetailView: View {
    @ObservedObject var viewModel: BookDetailVM
    weak var navigationController: UINavigationController?

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let url = viewModel.details.imageUrl {
                    imageContainer(url: url, height: geometry.size.height * 0.5)

                    overlaidButtons(topMargin: geometry.size.height * 0.15)
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

    func overlaidButtons(topMargin: CGFloat) -> some View {
        return HStack {
            Spacer()

            VStack(alignment: .trailing, spacing: 16) {
                Spacer()
                    .frame(height: topMargin)

                if let url = URL(string: viewModel.details.reviewLink) {
                    Link(destination: url) {
                        Text("Book Review")
                            .font(.callout)
                            .padding(8)
                            .foregroundColor(.blue)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                }

                if let url = URL(string: viewModel.details.amazonURL) {
                    Link(destination: url) {
                        Text("Amazon")
                            .font(.callout)
                            .padding(8)
                            .foregroundColor(.blue)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                }

                Spacer()
            }
            .padding(.trailing, 4)
        }
    }

    func textsStack(width: CGFloat, topMargin: CGFloat) -> some View {
        return VStack {
            Spacer(minLength: topMargin)
            VStack(alignment: .leading) {
                Text(viewModel.details.title)
                    .font(.title)
                    .accessibilityLabel("movie_detail_title")
                    .padding(.top, 8)
                Text(viewModel.details.author)
                    .font(.headline)
                    .accessibilityLabel("movie_detail_author")

                Text(viewModel.details.bookDescription)
                    .font(.body)
                    .accessibilityLabel("movie_detail_summary")
                    .padding()
                Spacer()

                VStack(alignment: .leading) {
                    Text("Publisher: " + viewModel.details.publisher)
                        .font(.subheadline)
                        .accessibilityLabel("movie_detail_publisher")

                    Text("ISBN: " + viewModel.details.primaryISBN10)
                        .font(.footnote)
                        .accessibilityLabel("movie_detail_isbn")

                }
            }
            .padding()
            .frame(width: width)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    func topGradient(width: CGFloat) -> some View {
        let gradient = LinearGradient(
            gradient: Gradient(stops: [
                .init(color: .clear, location: 0.6),
                .init(color: .white, location: 1.0)
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
