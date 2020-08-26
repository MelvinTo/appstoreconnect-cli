// Copyright 2020 Itty Bitty Apps Pty Ltd

import Foundation

public struct BetaGroup: Codable, Equatable {

    public typealias EmailAddress = String

    public var id: String?
    public var groupName: String
    public var isInternal: Bool?
    public var publicLink: String?
    public var publicLinkEnabled: Bool?
    public var publicLinkLimit: Int?
    public var publicLinkLimitEnabled: Bool?
    public var creationDate: String?
    public var testers: [EmailAddress]

    public init(
        id: String?,
        groupName: String,
        isInternal: Bool?,
        publicLink: String?,
        publicLinkEnabled: Bool?,
        publicLinkLimit: Int?,
        publicLinkLimitEnabled: Bool?,
        creationDate: String?,
        testers: [String] = []
    ) {
        self.id = id
        self.groupName = groupName
        self.isInternal = isInternal
        self.publicLink = publicLink
        self.publicLinkEnabled = publicLinkEnabled
        self.publicLinkLimit = publicLinkLimit
        self.publicLinkLimitEnabled = publicLinkLimitEnabled
        self.creationDate = creationDate
        self.testers = testers
    }
}
