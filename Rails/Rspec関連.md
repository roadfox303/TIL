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
