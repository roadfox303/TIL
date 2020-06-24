# もう怖くないGit
### Gitはファイルのバージョンを管理するために使う
- ファイルのバージョンを管理しないと、複数人の場合最新のファイルがわからず、上書きなどのトラブルが起こってします。
- いつ、誰が、何を更新したか
- どのファイルの何が編集されたか
- 上書きしようとすると警告が出る。

### Gitの歴史
- リーナス・トーバルス
- Linuxカーネル開発で使用していたバージョン管理システムが使えなくなって、開発された。
  - 大規模プロジェクトを効率的に開発できる。
  - スピード
  - シンプルな設計
  - ブランチが並列で開発可能

### GitHub とは
- Gitでのファイルをオンラインで共有できるように開発された。
- プルリクエストによる複数人開発。
- 世界中のチームがGitHub上で開発。
- GitHub
  - 非公開リポジトリは有料
  - 公開リポジトリは無料
- BitBucket
  - 非公開リポジトリが無料
  - 人数制限があるが２、３人は無料
  - 小規模チームでの開発に向く

### Atom
- Githubの創業者が開発

### Git

##### Git command

```
# 設定一覧
git config --list

```

### gitの仕組み
- gitはスナップショット（差分ではなく全情報）を新規記録する。
- コミットを辿ると以前の状態(コミット)に戻れる。

- ローカル
  - ローカルリポジトリにスナップショットを記録
- GitHub
  - GitHub(リモートリポジトリ)にアップロード
|ローカルは３つのエリアに分かれている|
|:---:|:---:|
|リポジトリ|スナップショットを記録(git commit)|
|ステージ|コミットする変更を準備(git add)|
|ワークツリー|ファイルを変更する作業場|

### gitのしくみと基本コマンド
##### gitのデータの持ち方（コミットまでの流れ）
|コマンド|行われている処理|
|:---:|:---|
|git init|.gitディレクトリ(ローカルリポジトリ)が作成される。<br>.gitに圧縮ファイル、ツリーファイル、コミットファイル、インデックスファイル、設定ファイルが含まれる。<br>.git/objects に圧縮ファイルやツリーファイルコミットファイルが保存される。|
|git add|1. ステージに追加するファイル（A）の圧縮ファイル（A'）をリポジトリに保存する<br>2. (A')の内容は(A)というファイルですよというマッピング情報を記録したインデックスというファイルをステージに追加。|
|git commit|1. インデックスをもとにツリーというファイルを作成する。ツリーはインデックスに記録してあるファイルとディレクトリの構成を、リポジトリに作成したもの。<br>2. コミットというファイルをリポジトリに作成（コミットには対象となるツリーの情報、作成者、日付、コミットメッセージが記録される）|
|git add(ファイル追加)|同様|
|git commit(ファイル追加)|コミットには親コミット情報も記録される。|
|git add(ファイル変更)|変更したファイルのみ、リポジトリに圧縮ファイルが作成される。|

- git add や git commit で作成された圧縮ファイル、ツリーファイル、コミットファイルの事を、Gitでは **Gitオブジェクト** と呼んでいる。

- ツリーファイルはディレクトリ１つにつき１つ作成される。
- 1つのファイルに１つの圧縮ファイル。１つのディレクトリに１つのツリーファイル。

### GitHub上にあるプロジェクトから始める
|コマンド|行われている処理|
|:---:|:---|
|git clone|リモートリポジトリのファイルと、リポジトリがコピーされる。|

### コミットメッセージ
- 簡単に書くとき
  - 変更内容の要点と理由を一行で簡潔に書く。
- 正式に書く（チームでしっかりやる場合や、オープンソースに書くとき）
  - 1行目:変更内容の要約
  - 2行目:空白
  - 3行目:変更した内容

- 変更したファイルのみコミットする癖をつける。
  - ついつい add . しがちだが、git status で確認し必要なもののみ（変更途中のファイルなどは除いて）addする。
  - git status は ステージにaddしたインデックスと、前回ステージに追加して変更したワークツリー(リポジトリにある前回コミット内のツリーオブジェクト)を比較した結果を表示している。

### ステージに追加する前にどんな変更をしたのか確認する
- 変更差分を確認する。
  - git add　する前。
    - git diff
    - git diff ファイルネーム (特定のファイルを指定する場合)
  - git add したあと。
    - git diff --staged

### 変更履歴を確認する
- git log
- git log --oneline
  - 一行で要点のみ表示する。
- git log -p ファイル名
  - 特定ファイルの差分のみ表示
- git log -n コミット数
  - 直近のコミットのみ表示

### ファイルの削除を記録
- ファイルの削除を記録するには、git add とは別のコマンドを使う必要がある。
- ローカルファイルごと削除（リポジトリとローカルのファイル両方消える）
  - git rm ファイル名
  - git rm -r ディレクトリ名
- ローカルファイルを残したいとき(ワークツリーにファイルを残し、リポジトリからだけ消したい場合)
  - git rm --cached ファイル名

### ファイルの移動を記録
- git mv 旧ファイル名 新ファイル名
  - 下記のコマンドを全て実行したのと同じ結果
  - mv 旧ファイル 新ファイル
  - git rm 旧ファイル
  - git add 新ファイル

### push
- git push -u origin master
  - -u　オプションをつけると、次回から git push のみで origin master にプッシュできる。

### コマンドにエイリアスをつける
- コマンドを省略できる。
- git config --global alias.ci commit
  - git ci　でコミットできるようになる。(--global をつけることによってPC全体で有効な設定になる。)
- git config --global alias.st status
- git config --global alias.br branch
- git config --global alias.co checkout

### ワークツリーのファイルへの変更を取り消す
- git checkout -- ファイル名
- git checkout -- ディレクトリ名
- git checkout -- . (全ファイル)
- ステージの情報を取得してワークツリーへ反映する。

### ステージした変更を取り消す
- git reset HEAD ファイル名
- gir teset HEAD ディレクトリ名
- git reset HEAD . (全変更を取り消す)
- ステージから取り消すだけなので、ワークツリーのファイルには影響を与えない。
- リポジトリから直前のコミットを取得してきて、ステージの内容に上書きしている。
- HEAD とは 自分がいるブランチの最新のコミット

### 直前のコミットをやりなおし(ローカルリポジトリの場合)
- git commit --amend
- 今のステージの内容で直前のコミットを上書きする
- リモートにプッシュしたコミットについてはやり直してはいけない！

### リモートの情報を確認する
- リモートリポジトリの情報(名前)を表示する。
  - git remote
- リモートのURLを表示
  - git remote -v

### リモートリポジトリを新規追加
- リモートリポジトリは複数登録できる。
- git remote add リモート名 リモートURL

### リーモートから情報を取得する（fetch）
- git fetch リモート名
  - git fetch origin
- リモートからローカルリポジトリの下記のブランチに取得している。
  - remotes/リモート/ブランチ
- git merge ワークツリーにマージする。
  - git merge origin/master (origin/master の情報をワークツリーに統合という意味)

### リーモートから情報を取得する（pull）
- リモートから情報を取得してマージまで一度にやりたいとき
- git pull リモート名 ブランチ名
  - git pull　（リモート名、ブランチは省略可能※remote master　と同じになる。）
- git pull　は 下記の二つのコマンドと同じ事
  - git fetch origin master
  - git merge origin/master

### フェッチとプルを使い分ける
- 基本的にはフェッチを使う方がいい。
- プルは特殊。
  - プルは、現在いるローカルブランチに、プルしたリモートブランチの内容をマージする。
  - プルしたブランチと、自分が現在いるローカルブランチが違う場合は、大変なことになるので注意！

### リモートの詳細情報を表示
- git remote show リモート名
- git remote show origin

### リモートを変更、削除
- リモート(リポジトリ)名の変更
  - git remote rename 旧リモート名 新リモート名
- リモート名の削除
 - ghit remote rm リモート名

### ブランチとマージ
- ブランチとはコミットを指すポインタ

### ブランチを新規追加
- git branch ブランチ名
- ブランチの一覧を表示
  - git branch
  - git branch -a (リモートリポジトリも含む全てを表示)

### ブランチを切り替え
- git checkout 既存ブランチ
- 新規作成して切り替え
  - git checkout -b 新規ブランチ

### ブランチとマージ　変更をマージ
- git merge ブランチ名
- git merge リモート名/ブランチ名
##### マージには3種類ある
- Fast Foward：早送りになるマージ
  - ブランチが枝分かれしていなかった場合、（前後関係にある場合）ポインタを先に進めるだけ。
- Auto merge：基本的なマージ
  - 枝分かれして知る場合、マージコミットという新たなコミットを作成する。

###　コンフリクトを解決
- 同じファイルの同じ行に異なる編集を行ったとき。コンフリクト発生
  - git status でどのファイルがコンフリクトしたか確認できる。
  - both modified: xxxxx.html　のように出る。
  - 修正したら、git add、git commit
  - 「コンフリクトの解決」とコミットメッセージに書いた方がいい。

### コンフリクトが起きないようにするには
- 同じファイルを複数人で編集しない。
- pullやmergeする前に、変更中の状態をなくしておく。(commitやstashをしておく)
- pullするときは、pullするブランチに移動してから行う。
- コンフリクトしても慌てない。

### ブランチを変更・削除する
- ブランチの名前を変更する
  - git branch -m ブランチ名
- ブランチを削除する。
  - git branch -d ブランチ名　(安全なデリート。masterにマージしてない変更が残っている場合削除しない)
  - git branch -D ブランチ名 (強制削除)

### ブランチを利用した開発の流れ
- masterブランチはリリース用ブランチ
- 開発はトピックブランチを作成して進めるのが基本。
- トピックの開発が完了したら、最新のmasterにマージ。新しいトピックは、その最新のmasterから新たに分岐。

### githubを利用した開発手順
- プルリクエストとは
  - 自分の変更をリポジトリに取り込んでもらうように依頼する機能

##### プルリクエストの手順
1. ローカルのワークツリーでmasterブランチを最新に更新
2. ブランチを作成
3. ファイルを変更、
4. 変更をコミット
5. Githubへプッシュ
6. プルリクエストを送る
7. コードレビュー
8. プルリクエストをリモートマスターなどにマージ
9. マージが済んだブランチを削除する

### github flow の流れ
- github社のワークフロー
1. masterブランチからブランチを作成
2. ファイルを変更しコミット
3. 同名のブランチをGithubへプッシュ
4. プルリクエスト
5. コードレビューし、masterにマージ
6. masterをデプロイ

- masterは常にデプロイできる状態に保つ.
- 開発はmasterから作成した新しいブランチで行う
- 定期的にpushする。
- masterにマージしたらすぐにデプロイ
- テストとデプロイは自動化

### リベース
- git rebase ブランチ名
- ブランチの起点となる親コミットを別のコミットにする。
  - git checkout 移動するコミット
  - git rebase 親にするコミット
  | |例|
  |:---:|:---:|
  |1|git checkout feature|
  |2|git rebase master|
  |3|git checkout master|
  |4|git merge feature|
- リベースすることでコミットツリーの分岐が統合され、履歴が一直線になる。

### リベースでしてはいけないこと
- Githubにプッシュしたコミットをリベースするのはダメ！
- git push -f　は絶対ダメ！

### マージとリベースのどちらを使うか
- マージ
  - コンフリクトの解決が比較的簡単
  - まーじコミットがたくさんあると履歴が複雑化する
  - 作業の履歴を残したいならマージ！
- リベース
  - 履歴をきれいに保てる
  - コンフリクトの解決が若干面倒(コミットそれぞれに解消が必要)
  - 履歴クォきれいにしたいならリベース！
- プッシュしていないローカルの変更にはリベース、プッシュした後は絶対マージ。コンフリクトしそうならマージが無難。

### プルの設定をリベースに変更する
- プルにはマージ型とリベース型がある。
- マージ型
  - git pull リモート ブランチ
  - マージコミットが残るので、マージしたという記録を残したい場合に適している。
- リベース型
  - git pull --rebase リモート ブランチ
  - マージコミットが残らないので、guthubの内容を取得したいだけの時に適している。
- デフォルトをリベース型にするには
  - git config --global pull.rebase true
  - git config branch.master.rebase true <br>(masterブランチでpullするときだけrebaseにしたい場合)

### リベースで履歴を書き換える
- コミットをきれいに整えてからpudhしたいときに使う。
- **やっていいのはGithubにpushしていないコミットだけ！**
- 直前のコミットだけやりなおすのなら、先述の　--amend　を使う。
- 複数の場合は
  - git rebase -i コミットID
  - git rebase -i HEAD~3 (直前３つ（３世代）のコミットをやりなおし)
  - git rebase -i HEAD^2 (マージした場合の2番目（２世代前）の親コミットをやりなおし)
  - -i は--interactiveの略で、対話型リベース。やりとりしながら履歴を変更していくという意味。

```
git rebase -i HEAD~3

#コミットエディタが立ち上がる
pick gh21f6d ヘッダー修正
pick 19305fa ファイル追加
pick 48d5c04 README修正

# やり直したいcommitをeditにする
edit gh21f6d ヘッダー修正
pick 19305fa ファイル追加
pick 48d5c04 README修正

#やりなおしたら実行する
git commit --amend

#次のコミットへ進む(リベース完了)
git rebase --continue

```

##### コミットを並び替える、削除する。
- 履歴は古い順に表示される（git log とは逆順）

```
git rebase -i HEAD~3

#コミットエディタで、並び替えたり削除したりすることで、並び替え、削除ができる。
pick gh21f6d ヘッダー修正
pick 19305fa ファイル追加
pick 48d5c04 README修正
```
##### コミットをまとめる

```
git rebase -i HEAD~3

#scashを指定するとそのコミットを直前のコミットと一つにまとめられる。
pick gh21f6d ヘッダー修正
squash 19305fa ファイル追加
squash 48d5c04 README修正
```
##### コミットを分割する

```
git rebase -i HEAD~3

#READMEとindex修正を２つのコミットに分割する
pick gh21f6d ヘッダー修正
pick 19305fa ファイル追加
edit 48d5c04 READMEとindex修正
#保存してコミットエディタを終了

git reset HEAD^
git add README
git commit -m 'README修正'
git add index.html
git commit -m 'index.html修正'
git rebase --continue
```

### タグの一覧を表示する
- git tag
- パターンを絞り込んでタグを表示

```
git tag -i "201705"
20170501_01
20170501_02
20170503_01
```

### タグつけする
- 注釈付き(annotated)版と軽量(lightweight)版の2種類がある。
- 注釈付き
  - git tag -a タグ名 -m "メッセージ"
  - タグ名、コメント意外に、自動的に署名（タグ作成者）も付加される。
- 軽量版タグ
  - git tag タグ名
- 後からタグをつける場合(過去のコミットにタグつけ)
  - git tag タグ名 コミット名
- タグのデータを表示する
  - git tag show タグ名

### タグをリモートリポジトリに送信する
- タグをリモートに送信するには、git push で別途送信指定する。
- git push リモート名 タグ名 (タグを個別に送信)
- git push origin --tags (タグを一斉送信)
  - ローカルにあって、リモートにないタグを一斉送信する。

### 作業を一時避難する
- git stash
  - ワークツリーとステージには反映せずに、変更をstashに一時格納する。
- git stash list
  - 避難した作業の一覧を表示する。

### 避難した作業を復元
- git stash apply
  - stageの状況までは復元されない。
- git stash apply --index
  - stageの状況も復元する。
- 特定の作業を復元する。
  - git stash apply スタッシュ名
  - git stash apply stash@{1}

### 避難した作業を削除する。
- git stash drop
  - 最新のstashを削除する。
- 特定のstashを削除する。
  - git stash drop スタッシュ名
  - git stash drop stash@{1}
- 全stashを削除する。
  - git stash clear