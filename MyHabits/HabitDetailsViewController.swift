
import UIKit

class HabitDetailsViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    private let cellID = "cellID"
    
    //MARK: Edit Habit variable
    var detailsHabit: Habit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = detailsHabit?.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Править", style: .plain, target: self, action: #selector(editHabit))
        navigationController?.navigationBar.tintColor = mainColor
        
        setupLayout()
        setupTableView()
    }
    
    // MARK: Large title
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        tableView.reloadData()
    }
    
    //MARK: Edit Habit method
    @objc func editHabit() {
        let rootVC = HabitViewController()
        let navVC = UINavigationController(rootViewController: rootVC)
        rootVC.dismissingVCDelegate = self
        rootVC.reloadingTitleDelegate = self
        
        rootVC.editingHabit = detailsHabit
        rootVC.isOnEditMode = true
        
        rootVC.setupEditingMode()
        rootVC.setupAlertController()
        
        present(navVC, animated: true, completion: nil)
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        
        let constratints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constratints)
    }
}

extension HabitDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HabitsStore.shared.dates.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = HabitsStore.shared.trackDateString(forIndex: indexPath.row)
        if let habit = detailsHabit {
            if HabitsStore.shared.habit(habit, isTrackedIn: HabitsStore.shared.dates[indexPath.row]) {
                cell.accessoryType = .checkmark
                cell.tintColor = mainColor
            } else {
                cell.accessoryType = .none
            }
        }
    
        return cell
    }
}

extension HabitDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .zero
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .zero
    }
}

extension HabitDetailsViewController: DissmissingViewControllerDelegate {
    func dismissViewController() {
        self.navigationController?.popViewController(animated: false)
    }
}

extension HabitDetailsViewController: ReloadingTitleDelegate {
    func reloadTitle() {
        if let habit = detailsHabit, let index = HabitsStore.shared.habits.firstIndex(of: habit) {
            title = HabitsStore.shared.habits[index].name
        }
    }
}


