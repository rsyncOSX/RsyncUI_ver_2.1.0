//
//  LogRecords.swift
//  RsyncOSX
//
//  Created by Thomas Evensen on 02/05/16.
//  Copyright © 2016 Thomas Evensen. All rights reserved.
//

import Foundation

struct Log: Identifiable, Codable {
    var id = UUID()
    var dateExecuted: String?
    var resultExecuted: String?
    var date: Date {
        dateExecuted?.en_us_date_from_string() ?? Date()
    }
}

struct LogRecords: Identifiable, Codable {
    var id = UUID()
    var hiddenID: Int
    var offsiteserver: String?
    var dateStart: String
    var logrecords: [Log]?

    // Used when reading JSON data from store
    init(_ data: DecodeLogRecords) {
        dateStart = data.dateStart ?? ""
        hiddenID = data.hiddenID ?? -1
        offsiteserver = data.offsiteserver
        for i in 0 ..< (data.logrecords?.count ?? 0) {
            if i == 0 { logrecords = [Log]() }
            var log = Log()
            log.dateExecuted = data.logrecords?[i].dateExecuted
            log.resultExecuted = data.logrecords?[i].resultExecuted
            logrecords?.append(log)
        }
    }

    // Create an empty record with no values
    init() {
        hiddenID = -1
        dateStart = ""
    }
}

extension LogRecords: Hashable, Equatable {
    static func == (lhs: LogRecords, rhs: LogRecords) -> Bool {
        lhs.hiddenID == rhs.hiddenID &&
            lhs.dateStart == rhs.dateStart &&
            lhs.offsiteserver == rhs.offsiteserver
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(String(hiddenID))
        hasher.combine(dateStart)
        hasher.combine(offsiteserver)
    }
}

extension Log: Hashable, Equatable {
    static func == (lhs: Log, rhs: Log) -> Bool {
        lhs.dateExecuted == rhs.dateExecuted &&
            lhs.resultExecuted == rhs.resultExecuted &&
            lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(dateExecuted)
        hasher.combine(resultExecuted)
        hasher.combine(id)
    }
}
