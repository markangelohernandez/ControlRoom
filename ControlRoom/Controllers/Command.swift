//
//  Command.swift
//  ControlRoom
//
//  Created by Paul Hudson on 12/02/2020.
//  Copyright © 2020 Paul Hudson. All rights reserved.
//

import Foundation

/// A type that lets us execute simctl commands easily. It's an enum because it shouldn't be instantiated.
enum Command {
    /// Errors we might get from running simctl
    enum CommandError: Error {
        case missingCommand
        case missingOutput
        case unknown(Error)
    }

    /// Runs one command using Process, and sends the result or error back on the main thread.
    static func run(command: String, arguments: [String], completion: ((Result<Data, CommandError>) -> Void)? = nil) {
        DispatchQueue.global(qos: .userInitiated).async {
            let result = Process.execute(command, arguments: arguments)
            DispatchQueue.main.async {
                if let data = result {
                    completion?(.success(data))
                } else {
                    completion?(.failure(.missingCommand))
                }
            }
        }
    }

    /// Runs one simctl command and sends the result or error back on the main thread.
    static func simctl(_ arguments: String..., completion: ((Result<Data, CommandError>) -> Void)? = nil) {
        let arguments = ["simctl"] + arguments
        Command.run(command: "/usr/bin/xcrun", arguments: arguments, completion: completion)
    }

    /// Swift doesn't have array splatting yet, so this needs to exist to complement the variadic option above.
    static func simctl(_ arguments: [String], completion: ((Result<Data, CommandError>) -> Void)? = nil) {
        let arguments = ["simctl"] + arguments
        Command.run(command: "/usr/bin/xcrun", arguments: arguments, completion: completion)
    }
}
