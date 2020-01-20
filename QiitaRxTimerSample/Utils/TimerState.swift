//
//  TimerState.swift
//  QiitaRxTimerSample
//
//  Created by Yamada Shunya on 2020/01/20.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation

/// タイマーの状態を管理する構造体
///
/// - parameter isValid: タイマーが開始されているか、停止されているか
/// - parameter seconds: バックグラウンドに入った時点のタイマーの秒数
/// - parameter enterBackground: バックグラウンドに入った時間
///
struct TimerState: Codable {
    let isValid: Bool
    let seconds: Int
    let enterBackground: Date
}
