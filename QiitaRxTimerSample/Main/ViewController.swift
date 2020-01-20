//
//  ViewController.swift
//  QiitaRxTimerSample
//
//  Created by 山田隼也 on 2020/01/03.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    // MARK: Properties
    
    private lazy var onViewWillAppear: Void = {
        presentBgStopwatchIfNeeded()
    }()

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _ = onViewWillAppear
    }
}

// MARK: - Transition

extension ViewController {
    
    private func presentBgStopwatchIfNeeded() {
        guard let timerState = UserDefaultsManager().decodableObject(of: TimerState.self, for: .timerState) else { return }
        let vc = UINavigationController(rootViewController: BgStopwatchViewController.instantiate(dependency: timerState))
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
}
