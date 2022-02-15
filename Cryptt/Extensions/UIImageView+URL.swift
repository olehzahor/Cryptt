import SDWebImage
import UIKit

extension UIImageView {
    func setImage(url: String?, placeholder: UIImage? = nil) {
        guard let url = URL(string: url ?? "") else { return }
        sd_setImage(with: url, placeholderImage: placeholder)
    }
}
