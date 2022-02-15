// 
//

import UIKit

protocol KeyValueRowViewInterface: UIView {
    func setKey(_ key: String)
    func setValue(_ value: String)
}

protocol KeyValueRowViewDelegate: AnyObject {
    
}

class KeyValueRowView: UIView {
    weak var delegate: KeyValueRowViewDelegate?
    
    let keyLabel = UILabel {
        $0.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    let valueLabel = UILabel {
        $0.font = UIFont.preferredFont(forTextStyle: .body)
        $0.textColor = .gray
        $0.textAlignment = .right
    }
    
    let separator = UIView {
        $0.backgroundColor = .lightGray.withAlphaComponent(1/2)
    }

    private func setupView() {
        backgroundColor = .white
        
        addSubview(valueLabel)
        valueLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        addSubview(keyLabel)
        keyLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.lessThanOrEqualTo(valueLabel.snp.leading).offset(-16)
        }
        
        addSubview(separator)
        separator.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(keyLabel)
            $0.height.equalTo(1)
        }
    }

    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension KeyValueRowView: KeyValueRowViewInterface {
    func setKey(_ key: String) {
        keyLabel.text = key
    }
    
    func setValue(_ value: String) {
        valueLabel.text = value
    }
}
