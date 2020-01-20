//
//  BgStopwatchViewController.swift
//  QiitaRxTimerSample
//
//  Created by Yamada Shunya on 2020/01/20.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class BgStopwatchViewController: UIViewController {
    
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
}

// MARK: - Setup

extension BgStopwatchViewController {
    
    private func setupNavigation() {
        let closeButton = UIBarButtonItem(title: "閉じる", style: .plain, target: nil, action: nil)
        closeButton.rx.tap.asSignal()
            .emit(onNext: { [weak self] in self?.dismiss(animated: true, completion: nil) })
            .disposed(by: disposeBag)
        let resetButton = UIBarButtonItem(title: "リセット", style: .plain, target: nil, action: nil)
        resetButton.tintColor = .systemRed
        resetButton.rx.tap.map { 0 }
            .bind(to: secondsRelay)
            .disposed(by: disposeBag)
        isValidRelay
            .map { !$0 }
            .bind(to: resetButton.rx.isEnabled)
            .disposed(by: disposeBag)
        isValidRelay
            .map { !$0 }
            .bind(to: closeButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        navigationItem.title = "バックグラウンド対応版"
        navigationItem.leftBarButtonItem = closeButton
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
