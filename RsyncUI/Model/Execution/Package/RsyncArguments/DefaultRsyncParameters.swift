//
//  DefaultRsyncParameters.swift
//  RsyncArguments
//
//  Created by Thomas Evensen on 02/08/2024.
//

import Foundation

public enum DefaultRsyncParameters: String, CaseIterable, Identifiable, CustomStringConvertible {
    case verify_parameter1 = "--checksum"
    case archive_parameter1 = "--archive"
    case verbose_parameter2 = "--verbose"
    case compress_parameter3 = "--compress"
    case delete_parameter4 = "--delete"
    case eparam_parameter5 = "-e"
    case ssh_parameter6 = "ssh"
    case recursive = "--recursive"
    case stats = "--stats"
    case dryrun = "--dry-run"
    case linkdest = "--link-dest="
    case synchronize
    case snapshot
    case syncremote

    public var id: String { rawValue }
    public var description: String { rawValue.localizedLowercase }
}
