//
//  MisskeyKitError.swift
//  rawr.
//
//  Created by Nila on 19.08.2023.
//

import Foundation
import MisskeyKit

public extension MisskeyKitError? {
    
    func explain() -> String {
        switch self {
        case nil:
            return "The request ended without data or an error. Try restarting the app."
        case .ClientError, .UnknownTypeResponse, .FailedToDecodeJson:
            return "Your Instance responded in an usual format and rawr. was not able to understand it."
        case .AuthenticationError:
            return "Your Instance rejected the request because you are not authenticated. Try restarting the app."
        case .ForbiddonError:
            return "Your Instance rejected the request because you are not allowed to execute this action"
        case .ImAI:
            return "Your Instance was unable to process the request because it is a Firefish. (HTTP 418, this must be a joke response)"
        case .TooManyError:
            return "Your Instance rejected the request because you have been rate limited. Try slowing down a bit."
        case .InternalServerError:
            return "Your Instance was unable to process the request due to an internal server error."
        case .CannotConnectStream:
            return "rawr. was unable to connect to the stream endpoint of your instance."
        case .NoStreamConnection:
            return "rawr. tried to use a stream connection that didn't exist."
        case .FailedToCommunicateWithServer:
            return "rawr. was not able to contact your instance. Check whether your instance is reachable or not."
        case .ResponseIsNull:
            return "Your Instance responded with an empty message. That was not very polite of it."
        }
    }
    
}
