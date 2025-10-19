import Foundation

struct URLHost: RawRepresentable {
    var rawValue: String
}

extension URLHost {
    static var staging: Self {
        URLHost(rawValue: "api.github.com")
    }

    static var production: Self {
        URLHost(rawValue: "api.github.com")
    }

    static var `default`: Self {
        #if DEBUG
        return staging
        #else
        return production
        #endif
    }
}

