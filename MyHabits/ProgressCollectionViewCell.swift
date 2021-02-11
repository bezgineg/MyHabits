import UIKit


class ProgressCollectionViewCell: UICollectionViewCell {
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.text = "Всё получится!"
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .systemGray
        return label
    }()
    
    let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.toAutoLayout()
        progressView.trackTintColor = .systemGray2
        progressView.progressTintColor = customPurpleColor
        progressView.clipsToBounds = true
        progressView.layer.cornerRadius = 4
        return progressView
    }()
    
    private let progessInPercentLabel: UILabel = {
       let label = UILabel()
        label.toAutoLayout()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .systemGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .white
        
        setupViews()
    }
     
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupProgressView(progress: Float) {
        progressView.setProgress(progress, animated: false)
        progessInPercentLabel.text = "\(Int(progress * 100)) %"
    }
    
    private func setupViews() {
        contentView.addSubview(statusLabel)
        contentView.addSubview(progressView)
        contentView.addSubview(progessInPercentLabel)
        
        let constraints = [
            statusLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            progessInPercentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            progessInPercentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            progressView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 10),
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            progressView.heightAnchor.constraint(equalToConstant: 7)

        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

