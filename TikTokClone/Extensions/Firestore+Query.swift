//
//  Firestore+Query.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/10/23.
//

import Firebase

extension Query {
    func getDocuments<T: Decodable>(as type: T.Type) async throws -> [T] {
        let snapshot = try await getDocuments()
        return snapshot.documents.compactMap({ try? $0.data(as: T.self) })
    }
}
