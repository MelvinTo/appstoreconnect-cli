// Copyright 2020 Itty Bitty Apps Pty Ltd

@testable import AppStoreConnectCLI
import AppStoreConnect_Swift_SDK
import Combine
import Foundation
import XCTest

final class ReadCertificateOperationTests: XCTestCase {

    let successRequestor = OneEndpointTestRequestor(response: { _ in
            Future { $0(.success(readCertificateResponse)) }
        }
    )

    let failedRequestor = OneEndpointTestRequestor(response: { _ in
            Future<CertificatesResponse, Error> { promise in
                promise(.failure(TestError.somethingBadHappened))
            }
        }
    )

    let noResponseRequestor = OneEndpointTestRequestor(response: { _ in
            Future{ $0(.success(noCertificateResponse)) }
        }
    )

    let notUniqueRequestor = OneEndpointTestRequestor(response: { _ in
            Future{ $0(.success(notUniqueResponse)) }
        }
    )

    typealias OperationError = ReadCertificateOperation.ReadCertificateError

    let options = ReadCertificateOperation.Options(serial: "abcde")

    func testExecute_success() {
        let operation = ReadCertificateOperation(options: options)

        let result = Result {
            try operation.execute(with: successRequestor).await()
        }

        switch result {
        case .success(let certificate):
            XCTAssertEqual(certificate.name, "Mac Installer Distribution: Hello")
            XCTAssertEqual(certificate.platform, BundleIdPlatform.macOS)
            XCTAssertEqual(certificate.content, "MIIFpDCCBIygAwIBAgIIbgb/7NS42MgwDQ")
        default:
            XCTFail("Error happened when parsing read certificate response")
        }
    }

    func testExecute_propagatesUpstreamErrors() {
        let operation = ReadCertificateOperation(options: options)

        let result = Result {
            try operation.execute(with: failedRequestor).await()
        }

        let expectedError = TestError.somethingBadHappened

        switch result {
        case .failure(let error as TestError):
            XCTAssertEqual(expectedError, error)
        default:
            XCTFail("Expected failure with: \(expectedError), got: \(result)")
        }
    }

    func testCouldNotFindCertificateError() {
        let operation = ReadCertificateOperation(options: options)

        let result = Result {
            try operation.execute(with: noResponseRequestor).await()
        }

        let expectedError = OperationError.couldNotFindCertificate("abcde")

        switch result {
        case .failure(let error as OperationError):
            XCTAssertEqual(error.errorDescription, expectedError.errorDescription)
        default:
            XCTFail("Expected failed with \(expectedError), got: \(result)")
        }
    }

    func testCertificateSerialNotUniqueError() {
        let operation = ReadCertificateOperation(options: options)

        let result = Result {
            try operation.execute(with: notUniqueRequestor).await()
        }

        let expectedError = OperationError.serialNumberNotUnique("abcde")

        switch result {
        case .failure(let error as OperationError):
            XCTAssertEqual(error.errorDescription, expectedError.errorDescription)
        default:
            XCTFail("Expected failed with \(expectedError), got: \(result)")
        }
    }

    static let readCertificateResponse = Certificate
        .readCertificateResponse
        .map({ try! jsonDecoder.decode(CertificatesResponse.self, from: $0) })!

    static let noCertificateResponse = Certificate
        .noCertificateResponse
        .map({ try! jsonDecoder.decode(CertificatesResponse.self, from: $0) })!

    static let notUniqueResponse = Certificate
        .notUniqueResponse
        .map({ try! jsonDecoder.decode(CertificatesResponse.self, from: $0) })!

}
