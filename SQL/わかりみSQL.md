#リレーショナルデータベースのテーブル
- 横は列、縦は行、リレーショナルデータベースは行は値なので増えるが、列は名前なので増えない。
- テーブルとは行の集合である。
- 順番は存在しない。検索時に並び替えを指定する事を前提としている。

#dockerでのpostgreSQL11
```
#初回作成時
#コンテナ起動
$ docker run --name postgres11 -d -e POSTGRES_PASSWORD=password postgres:11

#コンテナにアクセス
$ docker exec postgres11 bash

#DBユーザー「user1」を作成
$ createuser -U postgres user1

#作成を確認
$ psql -U postgres -c '\U'

#データベース「testdb1」を作成
$ createdb -U postgres -O user1 -E UTF8 --locale=C -T template0 testdb1

#DB作成を確認
$ psql -l postgres -l

#作成したユーザーでDBにアクセス
$ psql -U user1 testdb1

# psqlコマンドを抜ける
$ \q

```

```
#再起動時

# コンテナ起動
docker container start postgres11

# DBコンテナのbash起動
docker exec -it postgres11 bash

#作成済みのユーザーでDBにアクセス
psql -U user1 testdb1

```

## ■ファイルからSQLを実行する
1. 例) test1.sql というファイルを作成
2. ファイル内に select current_data; と書いて保存する。
3. psqlコマンドプロンプトで 「\i test.sql」(または\i ~/test.sql) で実行する。
- ※dockerで実行しｒている場合、ファイルパスは実際のファイルパスを指定。

## ■データ作成

- テーブル作成

```
create table testtable1 (
  id integer primary key,
  name text not null unique,
  age integer
);
```

- テーブルを削除

```
drop table testtable1;
```

- 行を追加(insert)

```
# 1行づつ追加
insert into testtable1(id, name, age) values (101, 'Alice', 20);
insert into testtable1(id, name, age) values (102, 'Bob', 25);

#複数行まとめて追加(バルクインサート)
insert into testtable1(id, name, age)
values (101, 'Alice', 20),
(102, 'Bob', 25),
(103, 'Cathy', 20);
```

- データを更新
  - 条件を指定しない場合、全ての行が更新される。
  - 但し、複数行にそれぞれ違う値で更新したい場合には向かない。
  - その場合は素直に複数回の update で更新する。

```
# 全レコードを更新
update testtable1
set age = age + 1;

# 特定のレコードだけ更新
update testtable1
set age = 27
where name = 'Bob';
```

- データを削除

```
# 特定の行を削除
delete from testtable1
where name = 'Bob';

# 条件を指定しないと全ての行が削除されてしまう
delete from testtable1;
```

## ■データ検索
- テーブルの全ての行を検索
  - 構文は select（何を） from（どこから） where（どんな条件で取得するか） order（どんな順番で） の順。
  - 実行順序は from → where → order → limit/offset → select の順番で実行される。※実は正確では無いがとりあえずそう覚えておく。
  - from → where → group → having → order → limit/offset → select

```
#全列の全行を取得
select *
from testtable1;

#nameとageを全行取得
select name, age
from testtable1;
```

- 特定の行だけを検索

```
select name, age
from testtable1
where name = 'Bob';
```

- ソートして検索

```
# nameの昇順で表示
select * from testtable1
order by name;

# heightの降順で表示
select * from members
order by height desc;

# height の指定のみだと height が同じ行が複数ある場合、順序はどちらが先になるかは決まらず、時々による。
# 下記のように複数の条件で並び替える事で順序を安定させることができる。（idは一意なので）
select * from members
order by height desc, id;

# 二つ目以降の条件にも昇順降順を設定できる。
select * from members
order by height desc, id desc;
```

- 複合的な条件
```
select *from members
where (gender = 'M' and height >= 170) or (gender = 'F' and height < 170);
```

- 範囲を指定
  - limit
  ```
  # 先頭から２行だけ出力
  select * from members order by id limit 2;
  ```
  - offset
  ```
  # 先頭から４行は出力せずにスキップする
  select * from members by id offset 4;
  ```
  - 組み合わせ
  ```
  # 先頭の3行をスキップして、次の１行だけを出力
  select * from members order by id limit 1 offset 3;
  ```

- グループ化
  - 集約関数が必要
  - グループ化すると、select句、order句に指定できるのは「グループ化のキー」と「集約関数」だけ。
  ```
  # gender でグループ化し、それぞれの平均値を算出する。
  select gender, avg(height) from members group by gender;
  ```
  - グループ化のキーにはテーブルの列名だけでなく、式も使える。
  ```
  # 名前の長さをキーにグループ化、それぞれの人数を数える。（列名を含めた式を）
  select length(name), count(*) from members group by length(name);
  ```

- 集約関数
  - 集約関数は group by していなくても select句 では使うことができる。where句 は group by句より先に実行されるので、集約関数を使うことができない。(whereで使用するにはサブクエリを利用する)
  - sum() … 合計する。
  - avg() … 平均する。
  - max() … 最大値を調べる。
  - min() … 最小値を調べる。
  - count() … 行数を揃える。
  - length() … 値の長さを調べる。
  - coalesce(x, y) … x が null でなければ x、null なら y を返す。
  - string_agg() … 文字列を連結する。
  - array_agg() … 複数の値を配列にする。
  - json_object_agg() … JSONデータを作る。
  - json_agg() … JSON配列を作る。
  - having … group を 指定条件でフィルターする。

  ```
  # where は行を対象に条件選択、having はグループを対象に条件選択する。

  # 性別でグループ化してから、平均身長が168cm以上のグループだけを表示。
  select gender ,avg(height) from members group by gender having avg(height) >= 168;

  # 性別でグループ化してから、３人以上のグループだけを表示。
  select gender, count(*) from members group by gender having count(*) >= 3;
  ```

- 複合値
  - 数値や文字列、真偽値などを複数集めて組みにしたもの。異なるデータ型が混在していても良い。

```
select (1, 2, 3) = (1, 2, 3) #false
select (1, 2, 3) <> (1, 2, 3) #true

select ('2019-03-11'::date, 9) > ('2019-03-10'::date, 9) #true
select ('2019-03-10'::date, 9) > ('2019-03-10'::date, 10) #false
select ('2019-03-10'::date, 10) > ('2019-03-11'::date, 9) #false

# ::date は日付型へのキャスト
# 最初に１つ目の要素で比較、同じなら２つ目の要素で比較する。
```

## ■コメント
- 二種類のコメントがある。
  - -- の後には半角スペースが必要。

```
/*ここから

ここまで*/

-- ここから行末までコメント

select * -- 行頭じゃなくてもコメント
```

## ■演算子
- <> … 等しく無い。
- || … 文字列を結合する

```
select 'Hello' || 'World' || '!';
# HelloWorld!
```

##### パターンマッチ演算子
- like … パターンにマッチ true
- not like … パターンにマッチしない true
- ilike … パターンにマッチ（大文字小文字を区別しない） true
- not ilike … パターンにマッチしない（大文字小文字を区別しない） true

```
select 'ミカサ' like '%サ'; # サで終わるパターンマッチ
select 'サシャ' like 'サ%'; # サで始まるパターンマッ
select 'サシャ' like 'サ__'; # サで始まる3文字のパターンマッチ
select 'サシャ' like '%シ%'; # シが含まれるパターンマッチ
select 'ベルトルト' like '%ル%ル%'; # ルが2回含まれるパターンマッチ
select 'やまもとやま' like '%や%や%'; # やが2回含まれるパターンマッチ

# 実際の使いかた。（ンで終わる名前だけ検索）
select name from members where name like '%ン';
```

##### in演算子
- in … 複数の値の中に指定の値が含まれている true
- not in … 複数の値の中に指定の値が含まれていない true

```
select 7 in (3, 5, 7, 9);
select 'zz' in ('xx', 'yy', 'zz');
select 8 not in (3, 5, 7, 9);

select * from members where name in ('エレン', 'ミカサ', 'アルミン') order by id;
# 左辺の中に右辺の値が含まれているか？というような使い方。
```

##### exists演算子
- 右辺にサブクエリを受け取り、１行でも結果を返したら true、１行も返さなかったらfalse
- つまりはサブクエリで指定した条件に合う行が有るかどうかを調べる。
- 存在確認するとき、counts() などで行を数えるよりも高速に処理できる。

- exists (サブクエリ) … 条件に合う行が一つでもあれば true 無ければ false
- not exists (サブクエリ) …  … 条件に合う行が無ければ true 一つでもあれば false
```
select exists (select * from test_scores where subject = '社会' and score = 100);
```
- exists (select 1 from ) と書かれる事があるが、これは「行の中身は使われないよ」 という事を示唆しているだけの事。hoge みたいなものなので深い意味はない。

##### all演算子
- all … サブクエリが返した値全てが条件に合っていれば true。ひとつでも条件と合わなかったら false。
```
# サブクエリの値が全てが40以上なら true
select 40 <= all (select score from test_scores where subject = '算数');
```

##### any演算子
- any … サブクエリが返した値の中に条件に合うものがあれば true。合うものがなければ false。
```
select 100 = any (select score from test_scores where subject = '理科');
```

##### null 関連
- x = null のような構文では null を判別できない。
  - null を用いた計算式は、結果自体が全てnullになってしまう。
  - そこで下記の演算子を使用する。
- is null … null なら true
- is not null … null でないなら true

```
select x is null;
select x in null, y is not null;
```

- coalesce() 関数
  - 値が null だった場合に別の値に変換する。
  - 第1引数と第2引数のデータ型が揃っていないとエラーになる。

  ```
  # x が null なら 0 を返す。null でなければ x の値を返す。
  coalesce(x, 0)

  # x が null なら 空文字 を返す。null でなければ x の値を返す。
  coalesce(x, '')

  # x が null なら false を返す。null でなければ x の値を返す。
  coalesce(x, false)

  # null でない最初の引数の値が返される(x が nullでなければ x が返され、x が null　かつ　y が null でなければ y が返され、x と y が共に null なら z が返される)
  coalesce(x, y, z)
  ```

## ■エイリアス
- 列に別名を付けられる。
  - 列は式の一種なので、式にも別名がつけられるということ。

```
select id as "ID", name as 名前, height as 身長 from members where gender = 'F';
# id を "" で囲っているのは、SQLは大文字と小文字の区別をしないから。"" で囲むことで大文字を含められる。
```

- テーブルにも別名をつけられる。
  - 「テーブル名 as 別名」または as を省略して「テーブル名 別名」で指定する。
  - 列名に例えば select などをつけている場合 SQLキーワードと解釈されるため通常はアクセスできない。テーブル名にエイリアスを付けることで、m.select のような指定をすれば列名であると解釈されるため、select列にアクセスできる。

```
select m.id, m.name, m.height from members m where m.gender = 'F' order by m.id;
# 上記の例では from members m で members のエイリアスを m と指定している。
```

- 列の別名は where句 では参照できない。order by句 では参照できる。
  - テーブルの別名は where でも order でも使用できる。
  - 列の別名は select（最後に処理される） で指定されるが、テーブルの別名は from(where、orderよりも先に処理される) で 指定されるため。

## ■サブクエリ
- SQL を別の SQL の一部として、埋め込んで(入れ子)使う機能。
  - 入れ子の階層は多段が可能。
- ある SQL の結果を利用して別の SQL を実行できる。
- ある SQL の検索結果を利用して別のテーブルを検索できる。

```
# 平均身長より身長の高いメンバーを検索
select * from members where height > (select avg(height) from members);
```
- サブクエリが返す結果によって、サブクエリをどのように扱うのかが決まる。
  ||単一列|複数列|
  |:---:|:---|:---|
  | **単一行** |結果例: (10)<br>使い方: 単一値の代わりに使う|結果例: (10, 20, 'A')<br>使い方: 複合値の代わりに使う|
  | **複数行** |結果例: (10),(11),(12)<br>使い方: in演算子とともに使う|結果例: (10, 20, 'A'), (11, 21, 'B'), (12, 22, 'C')<br>使い方: テーブルの代わりに使う|

##### 単一列単一行のサブクエリ
- 単一列単一行 = (10)
- １行も返さないサブクエリ（結果が空）の場合、null と同じ意味になってしまう。
- 下記の例は where t.subject = '国語' and t.score = (サブクエリの結果が単一列単一行)

  ```
  select t.student_id, t.score from test_scores t where t.subject = '国語' and t.score = (select max(score) from test_scores where subject = '国語') order by t.student_id;
  ```

##### 複数列単一行のサブクエリ
- 複数列単一行 = (10, 20, 'A')
- 下記の例は where (t.subject, t.score) = (サブクエリの結果が複数列単一行)
  - つまり複合値との比較で検索している。

  ```
  select t.student_id, t.score from test_scores t where (t.subject, t.score) = (select subject, max(score) from test_scores where subject = '国語' group by subject) order by t.student_id;
  ```

##### 単一列複数行のサブクエリ
- 単一列複数行 = (10),(11),(12)
- １行も返さないサブクエリでもエラーにならない（空配列 は null ではないから？）。検索結果が0行になるだけ。
- 下記の例は where s.id in(サブクエリの結果が複数列複数行)
  - つまりは s.id in(配列) で検索している。

  ```
  select s.* from students s where s.id in (select student_id from test_scores where score = 100) order by s.id;
  ```

##### 複数列複数行のサブクエリ
- 複数列複数行 = (10, 20, 'A'), (11, 21, 'B'), (12, 22, 'C')
- サブクエリには別名指定が必要（仮想的にテーブルと見立てているのでテーブル名として扱うため）
  - 導出テーブルという。実態はないがサブクエリによって導出されるので。
- 下記の例は from(サブクエリの結果が複数列複数行) エイリアス where エイリアス.導出テーブルの列名
  - つまりは from に導出テーブルを 渡して検索している。

  ```
  select x.subject, x.avg_score from(select subject, avg(score) as avg_score from test_scores group by subject) x where x.avg_score < 70;
  ```

##### 多段のサブクエリ例
  ```
  select * from students where id in (select student_id from test_scores where subject = '国語' and score = (select max(score) from test_scores where subject = '国語')) order by id;
  ```

##### with句(CTE)
- サブクエリに別名をつけることができる。
- select より前に書く。

```
with x as (select subject, avg(score) as avg_score from test_scores group by subject)
select x.subject, x.avg_score from x where x.avg_score < 70;
```

- サブクエリの列名（カラム名）にも別名をつけることができる。
  - リーディングの際にサブクエリ内の select句 を確認しなくてもよくなって便利。

```
with x(subject, avg_score) as (select subject, avg(score) ※1
    from test_scores group by subject
  )
select x.subject, x.avg_score from where x.avg_score < 70;

# ※1 本来はここで[as avg_score]というふうにエイリアスを付けるが、それをwith句で付けられるということ。
# この例では select句 で xテーブル(導出テーブル) を直に参照しているので　where x.avg_score < 70　という使い方で問題ない。
```
```
with x(max_score) as ( select max(score)
    from test_scores where subject = '国語'
  )
select t.student_id, t.score
from test_scores t
where t.subject = '国語' and t.score = x.max_score
order by t.student_id;

# where t.subject = '国語' and t.score = ( select x.max_score from x) これを
# where t.subject = '国語' and t.score = x.max_score とは書けない。
# この例では select句 で tテーブルを参照しているが、


```
with x(max_score) as ( select max(score) from test_scores where subject = '国語')select t.student_id, t.score from test_scores t where t.subject = '国語' and t.score = (select x.max_score from x) order by t.student_id;
