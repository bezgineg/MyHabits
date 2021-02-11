
import UIKit

protocol ReloadingProgressBarDelegate: AnyObject {
    func reloadProgressBar()
}

class HabitCollectionViewCell: UICollectionViewCell {
    
    weak var onTapTrackImageViewDelegate: ReloadingProgressBarDelegate?

    var habit: Habit? {
        didSet {
            guard let habit = habit else { return }
            habitNameLabel.text = habit.name
            habitNameLabel.textColor = habit.color
            everyDayLabel.text = habit.dateString
            countLabel.text = "Выполнено дней: \(habit.trackDates.count)"
            trackImageView.layer.borderColor = habit.color.cgColor
            if habit.isAlreadyTakenToday {
                setupCheckedImageView()
            } else {
                setupUnchekedImageView()
            }
        }
    }
    
    let habitNameLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()
    
    private let everyDayLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemGray2
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemGray2
        return label
    }()
    
    lazy var trackImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.toAutoLayout()
        imageView.layer.borderWidth = 3
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = trackImageSize.height/2
        return imageView
    }()
    
    private let checkImageView: UIImageView = {
        let image = UIImageView()
        image.toAutoLayout()
        image.image = UIImage(systemName: "checkmark")
        image.tintColor = .white
        return image
    }()
    
    private var trackImageSize: CGSize {
        return CGSize(width: 36, height: 36)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .white
        
        setupViews()
        trackHabit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func trackHabit() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(trackImageViewTapped))
        trackImageView.isUserInteractionEnabled = true
        trackImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func trackImageViewTapped() {
        if let habit = habit {
            if habit.isAlreadyTakenToday == false {
                setupCheckedImageView()
                HabitsStore.shared.track(habit)
                onTapTrackImageViewDelegate?.reloadProgressBar()
            }
        }
    }
    
    private func setupViews() {
        contentView.addSubview(habitNameLabel)
        contentView.addSubview(everyDayLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(trackImageView)
        
        let constraints = [
            habitNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            habitNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            everyDayLabel.topAnchor.constraint(equalTo: habitNameLabel.bottomAnchor, constant: 4),
            everyDayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            countLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            countLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            trackImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 47),
            trackImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26),
            trackImageView.widthAnchor.constraint(equalToConstant: 36),
            trackImageView.heightAnchor.constraint(equalToConstant: 36),
            trackImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -47)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupUnchekedImageView() {
        trackImageView.backgroundColor = .white
        checkImageView.removeFromSuperview()
    }
    
    func setupCheckedImageView() {
        trackImageView.backgroundColor = habitNameLabel.textColor
        trackImageView.addSubview(checkImageView)
        
        let checkedImageViewConstrains = [
        checkImageView.centerXAnchor.constraint(equalTo: trackImageView.centerXAnchor),
        checkImageView.centerYAnchor.constraint(equalTo: trackImageView.centerYAnchor),
        checkImageView.widthAnchor.constraint(equalToConstant: 25),
        checkImageView.heightAnchor.constraint(equalToConstant: 25)
        ]
        
        NSLayoutConstraint.activate(checkedImageViewConstrains)
    }
}
