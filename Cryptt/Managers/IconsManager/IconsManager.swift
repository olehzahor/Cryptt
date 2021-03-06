import Foundation

struct IconsManager {
    static func getIconUrl(forSymbol symbol: String) -> String {
        "https://cryptoicons.org/api/color/\(symbol.lowercased())/180/c7c7cc"
    }
    
    private init() { }
}
