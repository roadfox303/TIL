#リレーショナルデータベースのテーブル
- 横は列、縦は行、リレーショナルデータベースは行は値なので増えるが、列は名前なので増えない。
- テーブルとは行の集合である。
- 順番は存在しない。検索時に並び替えを指定する事を前提としている。

#dockerでのpostgreSQL11
```
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

## ファイルからSQLを実行する
1. 例) test1.sql というファイルを作成
2. ファイル内に select current_data; と書いて保存する。
3. psqlコマンドプロンプトで 「\i test.sql」(または\i ~/test.sql) で実行する。
- ※dockerで実行しｒている場合、ファイルパスは実際のファイルパスを指定。

## psql コマンド
### データ作成

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

### データ検索
- テーブルの全ての行を検索

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
