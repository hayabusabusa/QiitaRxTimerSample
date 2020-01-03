//
//  StopwatchViewController.swift
//  QiitaRxTimerSample
//
//  Created by 山田隼也 on 2020/01/03.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class StopwatchViewController: UIViewController {
    
    // MARK: IBOutlet
    
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var stopButton: UIButton!
    @IBOutlet private weak var startButton: UIButton!
    
    // MARK: Properties
    
    private let isValidRelay: BehaviorRelay<Bool> = .init(value: false)
    private let secondsRelay: BehaviorRelay<Int> = .init(value: 0)
    
    private let disposeBag = DisposeBag()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupButtons()
        setupLabel()
        setupTimer()
    }
    
    // MARK: IBAction
}

// MARK: - Setup

extension StopwatchViewController {
    
    private func setupNavigation() {
        let resetButton = UIBarButtonItem(title: "リセット", style: .plain, target: nil, action: nil)
        resetButton.tintColor = .systemRed
        resetButton.rx.tap.map { 0 }
            .bind(to: secondsRelay)
            .disposed(by: disposeBag)
        isValidRelay
            .map { !$0 }
            .bind(to: resetButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        navigationItem.title = "ストップウォッチ"
        navigationItem.rightBarButtonItem = resetButton
    }
    
    private func setupButtons() {
        stopButton.rx.tap.map { false }
            .bind(to: isValidRelay)
            .disposed(by: disposeBag)
        startButton.rx.tap.map { true }
            .bind(to: isValidRelay)
            .disposed(by: disposeBag)
    }
    
    private func setupLabel() {
        secondsRelay
            .map { String(format: "%02i:%02i:%02i", $0 / 3600, $0 / 60 % 60, $0 % 60) }
            .bind(to: timerLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupTimer() {
        isValidRelay
            .distinctUntilChanged()
            .flatMapLatest { $0
                ? Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
                : Observable.empty() }
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.secondsRelay.accept(self.secondsRelay.value + 1)
            })
            .disposed(by: disposeBag)
    }
}
