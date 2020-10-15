### RSpecについて
- RSpecで代表的なテストコードはModelSpec, SystemSpec, RequestSpecの3種類。

### テスト用 Gem

##### gem ‘rspec-rails’
RSpecを使用するために、必要なgemです。

##### gem ‘factory_bot_rails’
factory_botを使用することで、フィクスチャ（テストで使用するデータ）を作成する際に、それぞれのデータを関連付けることができるようになる。

##### gem ‘spring-commands-rspec’
bin/rspec のコマンド（rspecのテストを実行するコマンド）を実行するときに必要になるGem。
rspec は bin/ コマンドをつけないと Spring という Rails に組み込まれているアプリが起動せず、処理が少し重たくなる。

##### gem ‘factory_bot_rails’
factory_botを使用することで、フィクスチャ（テストで使用するデータ）を作成する際に、それぞれのデータを関連付けることができるようになる。

##### gem ‘faker’
フィクスチャを作成するときに、名前などを存在していそうな値にしてくれる。

##### gem ‘launchy’
Capybaraでテスト中に、save_and_open_page というメソッドで現在ページを確認できるようにしてくれる。

##### gem ‘capybara’
アプリケーション操作をRubyで設定して、あたかもユーザがアプリケーションを使っているかのように様々なページを遷移させ、その際にどこか不具合がないか調べてくれる。

##### gem ‘webdrivers’
ブラウザでの自動テストをサポートしてくれる。

```
$ bundle install

$ bundle exec spring binstub rspec
# RSpecでSpringの機能を使うために必要なコマンド
```

### RSpecの初期設定
- 必要なファイルを生成

```
rails g rspec:install
```

- RSpecファイルを編集する（.rspec）

```
追記
--format documentation

# --format documentationを追記することによって、
RSpecのデフォルトの設定を、ドキュメント形式にする。
これによってテストの結果が見やすくなる。
```

### 無駄なファイルが作成されないようにする
- 下記はモデルスペックのみの場合
```
    省略
    class Application < Rails::Application
      省略
      config.generators do |g|
        g.test_framework :rspec,
          fixtures: true,
          view_specs: false,
          helper_specs: false,
          routing_specs: false,
          controller_specs: false,
          request_specs: false
        g.fixture_replacement :factory_bot, dir: "spec/factories"
      end
    end
  end
```

### 動作テスト
```
bin/rspec
```
### describe、context、it の使い分け
- describe で目的の処理（アクションなど）、context で状況、it でふるまいの結果のように、入れ子で段組みすると、結果表示の際にもわかりやすいレイアウトになる。
```
# 文字列に一致する一致するメッセージを検索する
describe "search message for a them" do
  before do
    @note1 = @project.notes.create(
      message: "This is the first note.",
      user: @user,
    )
  end
  # 一致するデータが見つかるとき
  context "when a match is found" do
    # 検索文字列に一致するメモを返すこと
    it "returns notes that match the search term" do
      expect(Note.search("first")).to include(@note1, @note3)
    end
  end
  # 一致するデータが１件も見つからないとき
  context "when no match is found" do
    # 空のコレクションを返すこと
    it "returns an empty collection" do
      expect(Note.search("message")).to be_empty
    end
  end
end
```

## FactoryBot
### メソッド
##### create_list

## Feature Spec
### メソッド
##### save_and_open_page
- その時点の処理ステップの結果がhtmlとして保存される。
- gem 'launchy' がインストールしてあれば、自動でブラウザに画面が立ち上がる。

##### within
- セレクタを制限（指定）する。下記の場合 css id="rails" 要素内の "リンクボタン" テキスト要素をクリックしている。
```
within "#rails" do
  click_link "リンクボタン"
end
```

##### using_wait_time(10)
- ブラウザ表示が遅い機能をテストする際に使用する。Capybara が処理の完了をｘ秒間待つようになる。
- using_wait_time　を使用することで、Ruby の sleep メソッドを使うのは避ける。
