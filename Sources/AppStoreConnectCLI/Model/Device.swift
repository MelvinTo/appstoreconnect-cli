// Copyright 2020 Itty Bitty Apps Pty Ltd

import Foundation
import AppStoreConnect_Swift_SDK
import SwiftyTextTable

struct Device: ResultRenderable {
    var id: String
    var addedDate: Date?
    var name: String?
    var deviceClass: DeviceClass?
    var model: String?
    var udid: String?
    var platform: BundleIdPlatform?
    var status: DeviceStatus?
}

// TODO: Extract these extensions somewhere that makes sense down the road

// MARK: - API conveniences

extension Device {
    static func fromAPIDevice(_ apiDevice: AppStoreConnect_Swift_SDK.Device) -> Device {
        let attributes = apiDevice.attributes
        return Device(id: apiDevice.id,
                      addedDate: attributes.addedDate,
                      name: attributes.name,
                      deviceClass: attributes.deviceClass,
                      model: attributes.model,
                      udid: attributes.udid,
                      platform: attributes.platform,
                      status: attributes.status)
    }
}

// MARK: - TextTable conveniences

extension Device: TableInfoProvider {
    static func tableColumns() -> [TextTableColumn] {
        return [
            TextTableColumn(header: "ID"),
            TextTableColumn(header: "Date Added"),
            TextTableColumn(header: "Name"),
            TextTableColumn(header: "Device Class"),
            TextTableColumn(header: "Model"),
            TextTableColumn(header: "UDID"),
            TextTableColumn(header: "Platform"),
            TextTableColumn(header: "Status"),
        ]
    }

    var tableRow: [CustomStringConvertible] {
        return [
            id,
            addedDate?.formattedDate ?? "",
            name ?? "",
            deviceClass?.rawValue ?? "",
            model ?? "",
            udid ?? "",
            platform?.rawValue ?? "",
            status?.rawValue ?? ""
        ]
    }
}
