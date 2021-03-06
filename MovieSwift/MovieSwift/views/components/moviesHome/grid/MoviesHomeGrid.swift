//
//  MovieHomeGrid.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 10/10/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct MoviesHomeGrid: ConnectedView {
    struct Props {
        let movies: [MoviesMenu: [Int]]
        let genres: [Genre]
    }
            
    private func moviesRow(menu: MoviesMenu, props: Props) -> some View{
        VStack(alignment: .leading) {
            HStack {
                Text(menu.title())
                    .titleFont(size: 23)
                    .foregroundColor(.steam_gold)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                NavigationLink(destination: MoviesList(movies: props.movies[menu] ?? [],
                                                       displaySearch: true,
                                                       pageListener: MoviesMenuListPageListener(menu: menu, loadOnInit: false),
                                                       headerView: nil)
                    .navigationBarTitle(menu.title()),
                               label: {
                                Spacer()
                                Text("See all")
                                    .foregroundColor(.steam_blue)
                })
                    .padding(.trailing, 16)
                    .padding(.top, 16)
            }
            MoviesHomeGridMoviesRow(movies: props.movies[menu]?.prefix(upTo: 10).map{ $0 } ?? [])
                .padding(.bottom, 8)
        }.onAppear {
            store.dispatch(action: MoviesActions.FetchMoviesMenuList(list: menu, page: 1))
        }.listRowInsets(EdgeInsets())
    }
    
    func map(state: AppState, dispatch: @escaping DispatchFunction) -> Props {
        return Props(movies: state.moviesState.moviesList, genres: state.moviesState.genres)
    }
    
    func body(props: Props) -> some View {
        List {
            ForEach(MoviesMenu.allCases, id: \.self) { menu in
                Group {
                    if menu == .genres {
                        ForEach(props.genres) { genre in
                            NavigationLink(destination: MoviesGenreList(genre: genre)) {
                                Text(genre.name)
                            }
                        }
                    } else {
                        self.moviesRow(menu: menu, props: props)
                    }
                }
            }
        }
        .navigationBarTitle("Movies", displayMode: .automatic)
        .onAppear {
            store.dispatch(action: MoviesActions.FetchGenres())
        }
    }
}

struct MoviesHomeGrid_Previews: PreviewProvider {
    static var previews: some View {
        MoviesHomeGrid()
    }
}
