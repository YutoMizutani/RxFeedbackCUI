# RxFeedbackCUI
A sample software using RxFeedback operating from CUI.<br>
<br>
 ================= information =================<br>
<br>
RxFeedbackCUI<br>
    Created by YutoMizutani on 2018/01/31.<br>
    This software is released under the MIT License.<br>
<br>
enum State:<br>
   	 case ready<br>
    case looping<br>
    case sleeping<br>
    case ending<br>
<br>
enum Event:<br>
    case goStart    (ready    -> looping)<br>
    case goSleep    (looping  -> sleeping)<br>
    case goWakeUp   (sleeping -> looping)<br>
    case goEnd      ( (Any)   -> ending)<br>
    case response   (if looping then count up)<br>
    case noChange   ( (prev)  -> (prev) )<br>
<br>
Stateは<br>
    ready -> looping (-> sleep -> looping) -> ending<br>
の順にシフトし，<br>
CommandにEventを入力することによりStateが変化します。<br>
<br>
responseはStateがlooping時にのみ動作し，カウントアップします。<br>
まずは \"goStart\" と入力してください。<br>
<br>
 ===================================================<br>
<br>