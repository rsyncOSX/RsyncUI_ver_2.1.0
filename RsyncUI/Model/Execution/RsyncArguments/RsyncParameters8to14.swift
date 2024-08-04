//
//  RsyncParameters8to14.swift
//  RsyncArguments
//
//  Created by Thomas Evensen on 03/08/2024.
//
// swiftlint:disable line_length cyclomatic_complexity

import Foundation

public final class RsyncParameters8to14 {
    var computedarguments = [String]()

    var parameter8: String?
    var parameter9: String?
    var parameter10: String?
    var parameter11: String?
    var parameter12: String?
    var parameter13: String?
    var parameter14: String?

    var stats = false

    // Compute user selected parameters parameter8 ... parameter14
    // Brute force, check every parameter, not special elegant, but it works
    public func setParameters8To14(dryRun: Bool, forDisplay: Bool) -> [String] {
        stats = false
        if let parameter8, parameter8.isEmpty == false {
            appendParameter(parameter: parameter8, forDisplay: forDisplay)
        }
        if let parameter9, parameter9.isEmpty == false {
            appendParameter(parameter: parameter9, forDisplay: forDisplay)
        }
        if let parameter10, parameter10.isEmpty == false {
            appendParameter(parameter: parameter10, forDisplay: forDisplay)
        }
        if let parameter11, parameter11.isEmpty == false {
            appendParameter(parameter: parameter11, forDisplay: forDisplay)
        }
        if let parameter12, parameter12.isEmpty == false {
            appendParameter(parameter: parameter12, forDisplay: forDisplay)
        }
        if let parameter13, parameter13.isEmpty == false {
            let split = parameter13.components(separatedBy: "+$")
            if split.count == 2 {
                if split[1] == "date" {
                    appendParameter(parameter: split[0].suffixbackupstring, forDisplay: forDisplay)
                }
            } else {
                appendParameter(parameter: parameter13, forDisplay: forDisplay)
            }
        }
        if let parameter14, parameter14.isEmpty == false {
            appendParameter(parameter: parameter14, forDisplay: forDisplay)
        }
        // Append --stats parameter to collect info about run
        if dryRun {
            dryrunparameter(forDisplay: forDisplay)
        } else {
            if stats == false {
                appendParameter(parameter: DefaultRsyncParameters.stats.rawValue, forDisplay: forDisplay)
            }
        }

        return computedarguments
    }

    private func dryrunparameter(forDisplay: Bool) {
        computedarguments.append(DefaultRsyncParameters.dryrun.rawValue)
        if forDisplay { computedarguments.append(" ") }
        if stats == false {
            computedarguments.append(DefaultRsyncParameters.stats.rawValue)
            if forDisplay { computedarguments.append(" ") }
        }
    }

    private func appendParameter(parameter: String, forDisplay: Bool) {
        if parameter.count > 1 {
            if parameter == DefaultRsyncParameters.stats.rawValue {
                stats = true
            }
            computedarguments.append(parameter)
            if forDisplay {
                computedarguments.append(" ")
            }
        }
    }

    public init(parameter8: String?, parameter9: String?, parameter10: String?, parameter11: String?, parameter12: String?, parameter13: String?, parameter14: String?) {
        self.parameter8 = parameter8
        self.parameter9 = parameter9
        self.parameter10 = parameter10
        self.parameter11 = parameter11
        self.parameter12 = parameter12
        self.parameter13 = parameter13
        self.parameter14 = parameter14

        computedarguments.removeAll()
    }
}

extension String {
    var suffixbackupstring: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "-yyyy-MM-dd"
        return self + formatter.string(from: Date())
    }
}

/*
 extension String {
     func en_us_date_from_string() -> Date {
         let dateformatter = DateFormatter()
         dateformatter.locale = Locale(identifier: "en_US")
         dateformatter.dateStyle = .medium
         dateformatter.timeStyle = .short
         dateformatter.dateFormat = "dd MMM yyyy HH:mm"
         return dateformatter.date(from: self) ?? Date()
     }

     func localized_date_from_string() -> Date {
         let dateformatter = DateFormatter()
         dateformatter.formatterBehavior = .behavior10_4
         dateformatter.dateStyle = .medium
         dateformatter.timeStyle = .short
         return dateformatter.date(from: self) ?? Date()
     }

     var setdatesuffixbackupstring: String {
         let formatter = DateFormatter()
         formatter.dateFormat = "-yyyy-MM-dd"
         return self + formatter.string(from: Date())
     }
 }
 */

// swiftlint:enable line_length cyclomatic_complexity
