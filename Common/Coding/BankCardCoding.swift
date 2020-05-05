import Foundation

func BankCardEncode(_ bankCard: BankCard) throws -> Data {
    do {
        return try JSONEncoder().encode(bankCard)
    } catch {
        throw CodingError.encodingFailed
    }
}

func BankCardDecode(data: Data) throws -> BankCard {
    do {
        return try JSONDecoder().decode(BankCard.self, from: data)
    } catch {
        throw CodingError.decodingFailed
    }
}
