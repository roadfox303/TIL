### vimでファイル展開


### 範囲削除
- ※インサートモードに入らずに
- 削除確定するまで画面には何も変化がないが問題はない
1. 削除開始位置で ms
2. 削除終了位置で me
3. 最後に :'s,'ed で削除される。

### swapファイル全検索と削除
- findコマンドで検出する。

```
find . -name '.*.sw*'
```
- 削除
```
find . -name '.*.sw*'|xargs rm
```
