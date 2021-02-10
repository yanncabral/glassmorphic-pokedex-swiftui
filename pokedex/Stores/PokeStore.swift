//
// Created by Yann Cabral on 06/02/21.
//

import Foundation

class PokeStore: ObservableObject {
    @Published var pokemons: [SchemaResult]? = []

    init() {
        self.update()
    }

    func update() {
        PokeAPI.shared.getPokemonList { results in
            self.pokemons = results
        }
    }
}