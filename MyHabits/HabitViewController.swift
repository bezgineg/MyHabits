

import UIKit

protocol  ReloadingCollectionDataDelegate: AnyObject {
    func reloadCollectionData()
}

protocol DissmissingViewControllerDelegate: AnyObject {
    func dismissViewController()
}

protocol ReloadingTitleDelegate: AnyObject {
    func reloadTitle()
}

class HabitViewController: UIViewController {
    
    weak var reloadingDataDelegate: ReloadingCollectionDataDelegate?
    weak var dismissingVCDelegate: DissmissingViewControllerDelegate?
    weak var reloadingTitleDelegate: ReloadingTitleDelegate?
    
    var isOnEditMode: Bool = false
    
    //MARK: Edit Habit variable
    var editingHabit: Habit?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.textColor = .black
        label.text = "НАЗВАНИЕ"
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    private let descriptionLabel: UITextField = {
        let textField = UITextField()
        textField.toAutoLayout()
        textField.backgroundColor = .white
        textField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        textField.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        return textField
    }()
    
    private let colorLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.textColor = .black
        label.text = "ЦВЕТ"
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    private lazy var colorPickerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.toAutoLayout()
        imageView.backgroundColor = mainColor
        imageView.layer.cornerRadius = colorPickerImageSize.height/2
        return imageView
   }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.textColor = .black
        label.text = "ВРЕМЯ"
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    private let everyDayLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.textColor = .black
        label.text = "Каждый день в "
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    private let datePickerLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.textColor = mainColor
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.toAutoLayout()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(setupTime), for: .valueChanged)
        return datePicker
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.toAutoLayout()
        button.setTitle("Удалить привычку", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(deleteHabit), for: .touchUpInside)
        return button
    }()
    
    private var colorPickerImageSize: CGSize {
        return CGSize(width: 30, height: 30)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Создать"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(addHabit))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(cancelAddingHabit))
        navigationController?.navigationBar.tintColor = mainColor
        
        setupLayout()
        showColorPicker()
        setupTime()
    }
    
    private func showColorPicker() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(colorPickerImageTapped))
        colorPickerImage.isUserInteractionEnabled = true
        colorPickerImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func colorPickerImageTapped() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        present(colorPicker,animated: true)
    }
    
    @objc func cancelAddingHabit() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addHabit() {
        if isOnEditMode {
            saveHabitChanges()
        } else {
            let newHabit = Habit(name: descriptionLabel.text ?? "",
                                 date: datePicker.date,
                                 color: colorPickerImage.backgroundColor ?? mainColor)
            let store = HabitsStore.shared
            store.habits.append(newHabit)
            reloadingDataDelegate?.reloadCollectionData()
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func setupTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        datePickerLabel.text = formatter.string(from: datePicker.date)
    }
    
    //MARK: Edit Habit method
    func saveHabitChanges() {
        if let habit = editingHabit, let index = HabitsStore.shared.habits.firstIndex(of: habit) {
            HabitsStore.shared.habits[index].name = descriptionLabel.text ?? ""
            HabitsStore.shared.habits[index].date = datePicker.date
            HabitsStore.shared.habits[index].color = colorPickerImage.backgroundColor ?? mainColor
            HabitsStore.shared.save()
            reloadingDataDelegate?.reloadCollectionData()
            reloadingTitleDelegate?.reloadTitle()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func deleteHabit() {
        let alertController = UIAlertController(title: "Удалить привычку?", message: "Вы хотите удалить привычку \(descriptionLabel.text ?? "")?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            if let habit = self.editingHabit, let index = HabitsStore.shared.habits.firstIndex(of: habit) {
                HabitsStore.shared.habits.remove(at: index)
                self.reloadingDataDelegate?.reloadCollectionData()
                self.dismiss(animated: true, completion: nil)
                self.dismissingVCDelegate?.dismissViewController()
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setupEditingMode() {
        if isOnEditMode {
            if let habit = editingHabit {
                descriptionLabel.text = habit.name
                descriptionLabel.textColor = habit.color
                colorPickerImage.backgroundColor = habit.color
                datePickerLabel.textColor = habit.color
            }
        }
    }
    
    private func setupLayout() {
        view.addSubview(nameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(colorLabel)
        view.addSubview(colorPickerImage)
        view.addSubview(timeLabel)
        view.addSubview(everyDayLabel)
        view.addSubview(datePickerLabel)
        view.addSubview(datePicker)
        
        let constraints = [
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 7),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            colorLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15),
            colorLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            colorLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            colorPickerImage.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 7),
            colorPickerImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            colorPickerImage.widthAnchor.constraint(equalToConstant: 30),
            colorPickerImage.heightAnchor.constraint(equalToConstant: 30),
            
            timeLabel.topAnchor.constraint(equalTo: colorPickerImage.bottomAnchor, constant: 15),
            timeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            timeLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            everyDayLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 7),
            everyDayLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            datePickerLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 7),
            datePickerLabel.leadingAnchor.constraint(equalTo: everyDayLabel.trailingAnchor, constant: .zero),
            datePickerLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            datePicker.topAnchor.constraint(equalTo: everyDayLabel.bottomAnchor, constant: 15),
            datePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupAlertController(){
        view.addSubview(deleteButton)
        
        let deleteButtonConstraints = [
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ]
        NSLayoutConstraint.activate(deleteButtonConstraints)
    }
}

extension HabitViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let selectedColor = viewController.selectedColor
        colorPickerImage.backgroundColor = selectedColor
    }
}
