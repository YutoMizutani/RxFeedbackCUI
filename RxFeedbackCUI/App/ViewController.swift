//
//  ViewController.swift
//  RxFeedbackCUI
//
//  Created by YutoMizutani on 2018/01/31.
//  Copyright © 2018 Yuto Mizutani.
//  This software is released under the MIT License.
//

import RxSwift
import RxCocoa
import RxFeedback

class ViewController: NSViewController {
    public let commandText: Variable<String> = Variable("")
    public var response: Int = 0

    private let disposeBag = DisposeBag()

    private var previousState: State?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.information()
        self.configureFeedback()

    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

extension ViewController {
    private func information() {
        let info = """
================= information =================

RxFeedbackCUI
    Created by YutoMizutani on 2018/01/31.
    This software is released under the MIT License.

enum State:
    case ready
    case looping
    case sleeping
    case ending

enum Event:
    case goStart    (ready    -> looping)
    case goSleep    (looping  -> sleeping)
    case goWakeUp   (sleeping -> looping)
    case goEnd      ( (Any)   -> ending)
    case response   (if looping then count up)
    case noChange   ( (prev)  -> (prev) )

Stateは
    ready -> looping (-> sleep -> looping) -> ending
の順にシフトし，
CommandにEventを入力することによりStateが変化します。

responseはStateがlooping時にのみ動作し，カウントアップします。
まずは \"goStart\" と入力してください。

===================================================

"""
        print(info)
    }
}

extension ViewController {
    private func configureFeedback() {
        let bindUI: (ObservableSchedulerContext<State>) -> Observable<Event> = RxFeedback.bind(self) { (me,state) in
            let subscriptions = [
                /// If no contents, write "Observable<Any>.empty().subscribe(),".
                // Observable<Any>.empty().subscribe(),
                state
                    .filter { $0 == State.ending }
                    .subscribe(onNext: { _ in
                        print("\nEnd of the session")
                        self.exit()
                    }),
                state
                    // 最初の .readyが2回呼ばれるため，previousStateでfilter
                    .filter { $0 != me.previousState }
                    .map { ($0, $0.stateString) }
                    .replay(1).refCount() // https://qiita.com/kazu0620/items/bde4a65e82a10bd33f88
                    .subscribe(onNext: { state, str in
                        me.previousState = state
                        print(str)

                        // Start command
                        DispatchQueue.global().async {
                            print("Command?")
                            print("> ", terminator: "")
                            let text = readLine() ?? ""
                            print("> read: \(text)")
                            me.previousState = nil
                            me.commandText.value = text
                        }

                    }, onCompleted: {
                        // Stateは保持されるのでonCompletedが発火しない
                    }),
                ]
            let events = [
                me.commandText
                    .asObservable()
                    .map { Event.throwState($0) },
            ]
            return Bindings(subscriptions: subscriptions, events: events)
        }

        Observable.system(
            initialState: State.initialState,
            reduce: { [weak self] state, event in
                // in: event, out: state
                switch event {
                case .goStart:
                    if state == State.ready {
                        return State.looping
                    }
                case .goSleep:
                    if state == State.looping {
                        return State.sleeping
                    }
                case .goWakeUp:
                    if state == State.sleeping {
                        return State.looping
                    }
                case .goEnd:
                    return State.ending
                case .response:
                    if state == State.looping {
                        self?.response += 1
                        if let r = self?.response {
                            print("Response! count: \(r)")
                        }
                        return State.looping
                    }
                    break
                case .noChange:
                    break
                }
                return state
            },
            scheduler: MainScheduler.instance,
            scheduledFeedback:
            bindUI
            )
            .subscribe()
            .disposed(by: disposeBag)
    }
}
