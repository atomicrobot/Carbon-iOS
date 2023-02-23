//
//  RequestTypeTests.swift
//  
//
//  Created by Jonathan Lepolt on 2/7/23.
//

import XCTest
@testable import ARNetworking

final class RequestTypeTests: XCTestCase {
    func testFetchRepositories() throws {
        let requestType = RequestType.repositoryList(organization: "atomicrobot")
        let request = try requestType.request

        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url?.relativePath, "/orgs/atomicrobot/repos")
        XCTAssertEqual(request.url?.scheme, "https")
        XCTAssertEqual(request.allHTTPHeaderFields?.first?.key, "Accept")
        XCTAssertEqual(request.allHTTPHeaderFields?.first?.value, "application/vnd.github+json")
    }

    func testCommitsList() throws {
        let strUrl = "https://api.github.com/repos/atomicrobot/Carbon-Android/commits{/sha}"
        let requestType = RequestType.commitsList(commitsUrl: strUrl)
        let request = try requestType.request

        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url?.relativePath, "/repos/atomicrobot/Carbon-Android/commits")
        XCTAssertEqual(request.url?.scheme, "https")
        XCTAssertEqual(request.allHTTPHeaderFields?.first?.key, "Accept")
        XCTAssertEqual(request.allHTTPHeaderFields?.first?.value, "application/vnd.github+json")
    }

    func testCommitDetails() throws {
        let strUrl = "https://api.github.com/repos/atomicrobot/CarbonAndroid/git/commits/thisisafakecommit"
        let requestType = RequestType.commitDetails(commitUrl: strUrl)
        let request = try requestType.request

        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url?.relativePath, "/repos/atomicrobot/CarbonAndroid/git/commits/thisisafakecommit")
        XCTAssertEqual(request.url?.scheme, "https")
        XCTAssertEqual(request.allHTTPHeaderFields?.first?.key, "Accept")
        XCTAssertEqual(request.allHTTPHeaderFields?.first?.value, "application/vnd.github+json")
    }
}
