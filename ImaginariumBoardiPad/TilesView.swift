//
//  TilesView.swift
//  ImaginariumBoardiPad
//
//  Created by Exey Panteleev on 08.06.2022.
//

import SwiftUI

struct TilesView: View {
    
    @EnvironmentObject var viewModel: TilesViewModel
    
    var body: some View {
        gridIOS13
        .padding(.horizontal, 20)
    }
    
    var gridIOS13: some View {
        VStack(spacing: 16) {
            ForEach(0..<viewModel.tilesFallback.count, id: \.self) { row in
                // Row
                HStack(spacing: 16) {
                    ForEach(viewModel.tilesFallback[row]) { tile in
                        TileCell(index: tile.index, type: tile.type)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

enum TileType {
    case empty
    case fourWords
    case question
    case brand
    case tv
    case narrative
}

struct Tile: Identifiable, Hashable {
    
    let index: UInt8
    var type: TileType
    
    var id: UInt8 { index }
    
    init(index: UInt8, _ type: TileType = .empty) {
        self.index = index
        self.type = type
    }
}

struct TileCell: View {
    
    var index: UInt8
    var type: TileType
    
    var columns: [GridItem] = Array(repeating: .init(), count: 8)
    
    var body: some View {
        tile
    }
    
    var tile: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.clear)
                //.border(Color(hex: 0x3b3b5c), width: 4)
            VStack(alignment: .leading) {
                HStack {
                    VStack {
                        Text("\(index)")
                            .foregroundColor(.white)
                            .font(.system(size: 40))
                            
                        imageByTileType(type: type)
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .font(.system(size: 24))
                    }
                    .padding(0)
                    .frame(width: 60)
                    //.padding(.top, 6)
                    if index > 2 {
                        Spacer()
                    } else {
                        LazyVGrid(columns: columns, spacing: 8) {
                            ForEach(0..<16, id: \.self) { i in
                                Image(systemName: "\(i+1).square.fill")
                                    .font(.title)
                            }
                        }.padding(0)
                    }
                }.padding(0)
            }.padding(0)
        }
        .background(Material.ultraThin)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .frame(maxWidth: .infinity)
        .frame(height: 100)
    }
    
    func imageByTileType(type: TileType) -> some View {
        switch type {
        case .empty:
            return AnyView(Spacer().frame(height: 40))
        case .fourWords:
            return AnyView(Image(systemName: "square.grid.2x2.fill"))
        case .question:
            return AnyView(Image(systemName: "questionmark.circle.fill"))
        case .brand:
            return AnyView(Image(systemName: "applelogo"))
        case .tv:
            return AnyView(Image(systemName: "sparkles.tv.fill"))
        case .narrative:
            return AnyView(Image(systemName: "book.fill"))
        }
    }
}


struct TilesView_Previews: PreviewProvider {
    static var previews: some View {
        TilesView()
    }
}
