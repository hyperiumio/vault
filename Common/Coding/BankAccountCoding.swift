import Foundation

func BankAccountEncode(_ bankAccount: BankAccount) throws -> Data {
    do {
        return try JSONEncoder().encode(bankAccount)
    } catch {
        throw CodingError.encodingFailed
    }
}

func BankAccountDecode(data: Data) throws -> BankAccount {
    do {
        return try JSONDecoder().decode(BankAccount.self, from: data)
    } catch {
        throw CodingError.decodingFailed
    }
}
