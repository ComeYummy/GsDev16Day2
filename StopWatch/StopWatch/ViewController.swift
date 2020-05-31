//
//  ViewController.swift
//  StopWatch
//
//  Created by Naoki Kameyama on 2020/05/31.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // タイマー(一定時間ごとに関数を呼び出すときに必要)
    // classの中の変数は初期値が必要。オプショナル型とすることでnilを代入しておく
    var timer: Timer?

    // タイマースタート時に経過した時間(0.01秒が何回経過したか)
    var count: Int = 0 {
        // count変数の値が変わるたびにdidSet{}の中が動作する
        didSet {
            print("countの値は\(count)だよ👿")
            convertToTimerFromCount(count)
        }
    }

    // 計測状態か否か(STARTとSTOPの機能を切り替える)を管理する変数
    var isStarting = false {
        // isStarting変数の値が変わるたびにdidSet{}の中が動作する
        didSet {
            print("isStartingの値は\(isStarting)だよ🐢")
            if isStarting {
                // isStarting == true(計測状態)のときは、ボタンを”STOP”に変更
                startOrStopButton.setTitle("STOP", for: .normal)
            } else {
                // isStarting == false(計測状態ではない)のときは、ボタンを”START”に変更
                startOrStopButton.setTitle("START", for: .normal)
            }
        }
    }

    // タイマー表示
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var millisecondsLabel: UILabel!

    // START/STOPボタン
    @IBOutlet weak var startOrStopButton: CustomButton!

    /* ↑ ここより上にプロパティ(変数を書く)
       ↓ ここから下はメソッド(関数を書く) 決まりはないけど、読みやすいコードになります */


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // タイマー表示のfontが等幅ではないと、数字によって左右にブレるので等幅フォントに変更
        let fontSize: CGFloat = 38.0
        minutesLabel.font = .monospacedSystemFont(ofSize: fontSize, weight: .regular)
        secondsLabel.font = .monospacedSystemFont(ofSize: fontSize, weight: .regular)
        millisecondsLabel.font = .monospacedSystemFont(ofSize: fontSize, weight: .regular)
    }

    // RESETボタンが押されたとき
    @IBAction func tappedResetButton(_ sender: Any) {
        // タイマーをストップさせる
        timer?.invalidate()
        // countを0に戻す
        count = 0
        // isStarting変数を変更
        isStarting = false
    }

    // START/STOPボタンが押されたとき
    @IBAction func tappedStartButton(_ sender: Any) {
        if isStarting {
            // isStarting == trueのとき、タイマーをストップさせる
            timer?.invalidate()
            // isStarting変数を変更
            isStarting = false
        } else {
            // isStarting == falseのとき、タイマーをスタートさせる
            // 0.01秒ごとにselectorの関数を繰り返し動かす。(selectorの場合には関数名に@objcをつける。お約束)
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
            // isStarting変数を変更
            isStarting = true
        }
    }

    // 0.01秒ごとに動作する関数
    @objc func handleTimer() {
        // countに1ずつ足してゆく
        count += 1
    }

    // countの値からタイマー表示を行う関数
    func convertToTimerFromCount(_ count: Int) {
        // countを100で割った余りがミリ秒の表記
        let milliseconds: Int = count % 100
        // countを100で割った商が秒の表記(60以上の場合は分に繰り上がるのでさらに60で割った余り)
        let seconds: Int = count / 100 % 60
        // countを100*60で割った商が分の表記
        let minutes: Int = count / (100 * 60) % 60

        // 文字列を2桁固定の数字でLabelに反映
        minutesLabel.text = String(format: "%02d", minutes)
        secondsLabel.text = String(format: "%02d", seconds)
        millisecondsLabel.text = String(format: "%02d", milliseconds)
    }
}

