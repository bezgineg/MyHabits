
import UIKit

class HabitsViewController: UIViewController {
    
    private let progressCellId = "progressCellId"
    private let habitCellID = "habitCellId"
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = customWhiteColor
        cv.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: habitCellID)
        cv.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: progressCellId)
        cv.dataSource = self
        cv.delegate = self
        cv.toAutoLayout()
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupViews()
    }
    
    //MARK: Large title
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        collectionView.reloadData()
    }
    
    //MARK: Large title
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    @IBAction func addNewHabit(_ sender: Any) {
        let rootVC = HabitViewController()
        let navVC = UINavigationController(rootViewController: rootVC)
        rootVC.reloadingDataDelegate = self
        
        present(navVC, animated: true, completion: nil)
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
        
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}


extension HabitsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard section == 0 else { return HabitsStore.shared.habits.count }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let habitCell = collectionView.dequeueReusableCell(withReuseIdentifier: habitCellID, for: indexPath) as! HabitCollectionViewCell
        habitCell.habit = HabitsStore.shared.habits.count > 0 ? HabitsStore.shared.habits[indexPath.item] : nil
        habitCell.onTapTrackImageViewDelegate = self
        
        let progressCell = collectionView.dequeueReusableCell(withReuseIdentifier: progressCellId, for: indexPath) as! ProgressCollectionViewCell
        progressCell.setupProgressView(progress: HabitsStore.shared.todayProgress)
        
        guard indexPath.section == 0 else { return habitCell }
        return progressCell
    }
}

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    
    //MARK: Edit Habit method
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let habitDetailsViewController = HabitDetailsViewController()
        habitDetailsViewController.detailsHabit = HabitsStore.shared.habits[indexPath.item]
        
        self.navigationController?.pushViewController(habitDetailsViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = (view.frame.size.width - 32)
        
        guard indexPath.section == 0  else { return CGSize(width: width, height: 130) }
        return CGSize(width: width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        guard section == 0 else { return 12 }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        guard section == 0 else { return UIEdgeInsets(top: .zero, left: 16, bottom: 18, right: 16) }
        return UIEdgeInsets(top: 22, left: 16, bottom: 18, right: 16)
    }
}

extension HabitsViewController: ReloadingCollectionDataDelegate {
    func reloadCollectionData() {
        collectionView.reloadData()
    }
}

extension HabitsViewController: ReloadingProgressBarDelegate {
    func reloadProgressBar() {
        collectionView.reloadData()
    }
}




    



    
    

