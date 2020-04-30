// Copyright 2020 Itty Bitty Apps Pty Ltd

import AppStoreConnect_Swift_SDK
import ArgumentParser
import Combine
import Foundation
import Files

struct ReadDownloadCertificate: CommonParsableCommand {
    static var configuration = CommandConfiguration(
    commandName: "read",
    abstract: "Get information about a certificate and download the certificate data.")

    @OptionGroup()
    var common: CommonOptions

    @Argument(help: "The certificate’s serial number. (eg. 1A23BCDEF4G5D6C7)")
    var serial: String

    @Option(help: "The file download path and name. (eg. ./file.cer)")
    var certificateOutput: String?

    typealias Error = ListDownloadCertificates.CommandError

    func run() throws {
        let service = try makeService()

        let options = ReadCertificateOptions(
            serial: serial
        )

        let certificate = try service
            .readCertificate(with: options)
            .await()

        if let certificateOutput = certificateOutput {
            guard let content = certificate.content else {
                throw Error.invalidContent
            }

            do {
                let (folderName, fileName) = File.getFolderAndFileName(from: certificateOutput)

                let file = try File.createFile(
                    in: folderName,
                    named: fileName,
                    with: content
                )

                print("📥 Certificate '\(certificate.name ?? "")' downloaded to: \(file.path)")
            } catch {
                throw Error.invalidPath(certificateOutput)
            }
        }

        certificate.render(format: common.outputFormat)
    }
    
}
