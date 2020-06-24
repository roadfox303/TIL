# Rails入門 Rails編

### Railsの全体像と規約
- routes
  - 通信をどのコントローラのどのアクションで処理するか分配する.
- rake
  - Rubyのプログラミングをコマンドラインから呼び出せる仕組み。
- migrate
  - DBのテーブル操作をコマンドで行える仕組み。
  - rake によって実現している。(Rails4系まで？)
- MVCの設計
- Restful
- DRY (Ron't Repeat Yourself)
- 設定より規約（CoC）
  - 設定が多いと書くのが大変なうえに、必要とされる周辺知識が増え、覚えること、考えることが大変いなってしまう。
  - 書かずに便利なデフォルトを決めて基本ルールにする。という思想。
- 基本的にはcontrollerのアクション名と同じファイル名のviewが自動的にレンダリングされる。

### scaffold
- よくある実装を自動生成
- 新規のDBテーブルを作成するマイグレーションファイル。
- 上記テーブルのCRUDできるようにする各画面。
- その他補助的なもの。

##### 活用方法
- とりあえず動く状態が作りやすいので顧客に「欲しいのはこんなのですか？」というイメージを伝えるためのラフとして使える。
- 自動生成を恐れないこと。
- 何が起こるのかをある程度把握しておく。
- いい意味で「Railsのお手本」的なコードを生成するので、読むと参考になる。

### Restfulについて
- URL(URI)に対応した一意のリソースを中心にする設計
  - URLがリソースを示す。
- HTTPメソッドでCRUDを示す。
  - DBのCRUDと密接に関係

### formについて
- 下記のようにフォームからpostする場合、name="title" としたくなるがRails的には、テーブル名[カラム名]　のようにnameを命名する事が望ましい。
```
<div class="field">
    <label for="todo_title">Title</label><br>
    <input type="text" name="todo[title]" id="todo_title" />
    # name="title" としたくなるが、Rails的には
    # テーブル名[カラム名]　で命名するのが良い。
</div>
```

### create! について
- コンソールでモデルのテストなどをする場合、レコード作成の時には、ただの create ではなく、create! を使用した方がよい。
- create(title:"title") と書いても良いが、入力にエラーがありpostがロールバックされた場合 **!** がないと、ActiveRecordがエラー内容を返してくれない。下記のようにロールバックされた空のインスタンスだけが返る。
  -  => #<Todo id: nil, title: nil, body: nil, status: nil, created_at: nil, updated_at: nil>
- create!(title:"")の場合、下記のようにエラー内容を返してくれる。
  - ActiveRecord::RecordInvalid (Validation failed: Title can't be blank)

### link_to　の記述
- 下記の記述でaタグのような感じで link_to のコンテンツ部分を分離する事が可能。
```
#<%= link_to リンクパス do %><%= テキストやimgなどコンテンツ部分 %><% end %>
<%= link_to todo do %><%= todo.title %><% end %>
```
- 下記の記述で、インスタンスにパラメーターを付加して送信する事が可能
```
<%= link_to '完了', status_todo_path(todo, status:1),method: :patch %>
#todo インスタンスに status:1 を指定してパッチしている。
```

### SCSS
- scss は要素をネストして書く事ができる。
```
table {
    border:1px solid #ccc;

    th {
        background-color: #ccc;
    }
}
```
