//
//  IntentEntity.swift
//  IntelligenceKit-Sample
//
//  Created by Michel-Andre Chirita on 23/10/2024.
//

import Foundation
import AppIntents
import CoreLocation
import CoreTransferable

@AssistantEntity(schema: .whiteboard.board)
struct ColorEntity: IndexedEntity {

    // MARK: Static

    static let defaultQuery = ColorQuery()

    // MARK: Properties

    let id: String
    let color: ColorItem

    @Property(title: "Title")
    var title: String
    var creationDate: Date
    var lastModificationDate: Date
    var colorType: ColorType?

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: LocalizedStringResource(stringLiteral: title),
            subtitle: colorType?.localizedStringResource ?? "Color"
        )
    }
}

extension ColorEntity: Transferable {

    struct ColorQuery: EntityQuery {

        @MainActor
        func entities(for identifiers: [ColorEntity.ID]) async throws -> [ColorEntity] {
            //            library.assets(for: identifiers).map(\.entity)
            []
        }

        @MainActor
        func suggestedEntities() async throws -> [ColorEntity] {
            //            library.assets.prefix(3).map(\.entity)
            []
        }
    }

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .plainText) { entity in
            entity.title.data(using: .utf16)!
        }
    }
}
