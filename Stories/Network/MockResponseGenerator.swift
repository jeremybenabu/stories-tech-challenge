//
//  MockResponseGenerator.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//
import Foundation

extension StoryResponseDTO {
    static func generateMockData(index: Int) -> StoryResponseDTO {
        StoryResponseDTO(
            users: [
                UserDTO(
                    id: UUID().uuidString,
                    name: String.random(length: 10),
                    avatarURL: randomAvatarURL(),
                    stories: [
                        StoryDTO(
                            id: UUID().uuidString,
                            mediaURL: randomImageURL(),
                            mediaType: .image,
                            timestamp: randomDate(index: index),
                            isSeen: false,
                            isLiked: false,
                            duration: 5
                        )
                    ]
                )
            ]
        )
    }
}

// Returns a Date starting from 2025-06-30T10:03:00Z minus `index` days and with random hour/minute/second.
private func randomDate(index: Int) -> Date {
    var dateComponents = DateComponents()
    dateComponents.year = 2025
    dateComponents.month = 6
    dateComponents.day = 30
    dateComponents.hour = 10
    dateComponents.minute = 3
    dateComponents.second = 0

    let calendar = Calendar(identifier: .gregorian)
    guard let baseDate = calendar.date(from: dateComponents) else {
        return Date()
    }

    let randomHour = Int.random(in: 0...23)
    let randomMinute = Int.random(in: 0...59)
    let randomSecond = Int.random(in: 0...59)

    return calendar.date(byAdding: .day, value: -index, to: baseDate)?
        .addingTimeInterval(TimeInterval(randomHour * 3600 + randomMinute * 60 + randomSecond)) ?? Date()
}

private  extension String {
    static func random(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).compactMap { _ in characters.randomElement() })
    }
}


private  enum RandomUserGender: String {
    case men, women
}

private  func randomUserAvatarURL(gender: RandomUserGender = .men, index: Int) -> URL {
    return URL(string: "https://randomuser.me/api/portraits/\(gender.rawValue)/\(index).jpg")!
}

private func randomAvatarURL() -> URL {
    let gender: RandomUserGender = Bool.random() ? .men : .women
    let index = Int.random(in: 0...99)
    return randomUserAvatarURL(gender: gender, index: index)
}

private func randomImageURL(width: Int = 1920, height: Int = 1080) -> URL {
    let id = Int.random(in: 0...1000)
    return URL(string: "https://picsum.photos/id/\(id)/\(width)/\(height)")!
}
