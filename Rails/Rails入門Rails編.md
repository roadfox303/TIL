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
- showアクションなど、インスタンスへの情報を元にしたページへリンクする場合、aタグだとこのように

```
<% @blogs.each do |blog| %>

#こう書くより
<a href="<%= blog_path(blog.id)%>">
  ソース
</a>

# こう書いた方が良いかもしれない。
<%= link_to blog do %>
  ソース
<% end %>

<% ebd %>
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

### scaffoldに関して
- 失敗した場合、取り消すコマンドが用意されている。
```
bin/rails destroy scaffold テーブル名 オプション
```

### フォームの select　に関して
```
# ソースコード
<% @categories = Category.all %>
<%= select :todo, :category_id, @categories.map{|t| [t.name, t.id]} %>
## select オブジェクト(テーブル) プロパティ名(カラム), フォームのoption用配列
```
```
# HTML生成結果
<select name="todo[category_id]" id="todo_category_id">
  <option value="1">日常生活</option>
  <option value="2">学校関係</option>
</select>
```

- f. で利用するとオブジェクトが要らなくなる。（fがオブジェクトだから）
```
<%= f.select :category_id, @categories.map{|t| [t.name, t.id]} %>
```

##### オプション
- include_blank: true
  - 先頭に空のoptionを追加する。

```
<%= f.select :category_id, @categories.map{|t| [t.name, t.id]}, include_blank: true %>
```

### 便利メソッド
##### try
- 値が存在しなく nil だったら何もしない。
- 値があれば値を取ってくる。
- nil な値を持つレコードのせいでメソッドエラーが返るような場合に便利！
- 機能拡張などで新たにDBのカラムを追加して、既存のレコードがエラーの原因になる際などに良さそう。
```
<%= todo.category.try(:name) %>
#category.name に値があれば取得し、無かったら(nilなら)何もしない。
```

##### インスタンス からの


### リレーション
- モデルに記述する、has_many や belongs_to は、メソッドを追加するイメージ。
```
class User <ActiveRecord::Base
has_many :blogs
# User に blogs を扱うメソッドを追加しますよ。という感じ。
```

### パーシャル
- パーシャルへ渡すインスタンスを呼び出し元で指定できる。
```
<%= render partial: 'todos_table', locals: { todos: @todos } %>
```

- 他モデルのパーシャルを利用できる。
- パーシャルに渡すレコード一覧をパーシャルを読み込んでいるview内で取得できる。パーシャルは別ファイルだが、読み込み元と一枚のソースになるので、配列（メソッド）を共有できる。よく考えたら当たり前のこと。
```
# 通常は partial: 'todos_table'　のように同階層のディレクトリ内にあるパーシャルを読み込む。
# しかしこのようにパスを指定する事で categories/show　から、todos/_todos_table.html.erb というパーシャルを読み込んでいる。
<%= render partial: 'todos/todos_table', locals: { todos: @category.todos } %>
# locals: { todos: @category.todos }　で、 @category の has_many な todo が todos配列 に map される感じでパーシャルに渡している。
```
