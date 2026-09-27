struct FunFactModel: Equatable {
    let text: String
    let type: FunFactType
    let isSpoiler: Bool
}

enum FunFactType: String, Decodable {
    case fact = "FACT"
    case blooper = "BLOOPER"
}
