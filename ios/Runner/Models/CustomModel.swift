import SwiftUI

struct CustomModel: Codable {
    let id: String
    let code: String
    let valueUrl: String
    let valueUrlUSDZ: String
    let title: String
    let description: String?
    let logoUrl: String
    let platformLogoUrl: String?
    let version: Int
    let createdAt: String
    let updatedAt: String
    let like: Bool
}
