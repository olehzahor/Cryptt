import UIKit

protocol InitConfigurable {
    init()
}

extension InitConfigurable {
    init(configure: (Self) -> Void) {
        self.init()
        configure(self)
    }
}

extension UIView: InitConfigurable {}
