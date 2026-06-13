import Foundation

protocol UserStatePersisting {
    func load() -> UserState
    func save(_ state: UserState)
    func reset()
}

struct UserStatePersistence: UserStatePersisting {
    private let key = "dishPassport.userState.v1"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func load() -> UserState {
        guard let data = defaults.data(forKey: key) else {
            return .empty
        }

        do {
            return try JSONDecoder().decode(UserState.self, from: data)
        } catch {
            return .empty
        }
    }

    func save(_ state: UserState) {
        do {
            let data = try JSONEncoder().encode(state)
            defaults.set(data, forKey: key)
        } catch {
            assertionFailure("Failed to encode user state: \(error)")
        }
    }

    func reset() {
        defaults.removeObject(forKey: key)
    }
}

