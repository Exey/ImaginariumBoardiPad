//
//  TilesViewModel.swift
//  ImaginariumBoardiPad
//
//  Created by Exey Panteleev on 10.06.2022.
//

import Combine

final class TilesViewModel: ObservableObject {
    
    @Published var tiles: [Tile] = [
        Tile(index: 10),   Tile(index: 11),    Tile(index: 28),    Tile(index: 29),
        Tile(index: 9),    Tile(index: 12),    Tile(index: 27),    Tile(index: 30),
        Tile(index: 8),    Tile(index: 13),    Tile(index: 26),    Tile(index: 31),
        Tile(index: 7),    Tile(index: 14),    Tile(index: 25),    Tile(index: 32),
        Tile(index: 6),    Tile(index: 15),    Tile(index: 24),    Tile(index: 33),
        Tile(index: 5),    Tile(index: 16),    Tile(index: 23),    Tile(index: 34),
        Tile(index: 4),    Tile(index: 17),    Tile(index: 22),    Tile(index: 35),
        Tile(index: 3),    Tile(index: 18),    Tile(index: 21),    Tile(index: 36),
        Tile(index: 2),    Tile(index: 19),    Tile(index: 20),    Tile(index: 37),
        Tile(index: 1),    Tile(index: 39),    Tile(index: 38),
    ]
    var tilesFallback: [[Tile]] = .init()
    
    init() {
        
        applyType(.fourWords,   indicies: [3, 18, 25, 28])
        applyType(.tv,          indicies: [5, 21, 31, 38])
        applyType(.question,    indicies: [6, 10, 17, 26])
        applyType(.narrative,   indicies: [8, 15, 19, 32])
        applyType(.brand,       indicies: [12, 23, 29, 35])
        
        collectArticleAsGrid()
    }
    
    // iOS13 Fallback
    func collectArticleAsGrid() {
        let columned = tiles.publisher.collect(4) // [[0,1,2], [3,4,5], ...] of Publishers
        _ = columned.collect().sink {
            self.tilesFallback = $0
        }
    }
    
    // Tiles
    
    func applyType(_ tileType: TileType, indicies: [UInt8]) {
        for i in 0..<tiles.count {
            if indicies.contains(tiles[i].index) {
                tiles[i].type = tileType
            }
        }
    }
    
}
