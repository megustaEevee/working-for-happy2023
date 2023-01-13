# アプリ名 
working-for-happy

# 概要
1. 打刻機能：<br>
労働時間を視覚化する<br>
2. 賃金計算機能:<br>
労働の対価を視覚化する<br>
3. 残業時間申告機能：<br>
残業をするためには、上司と労働者の同意が必要。何のために残業が必要なのかを明確にすることで業務量の適正化に役立つ

# 本番環境
- heroku:<a href="https://working-for-happy.herokuapp.com/">
https://working-for-happy.herokuapp.com/</a><br>
- Basic認証を導入しています

# 制作背景(意図)
勤怠管理アプリとして、使いやすく、打刻がしやすいことを重視
| 解決したい課題     | なぜその課題解決が必要なのか       | 課題を解決する実装の内容 |
| ---------------- | ----------------------------- | -------------------- |
| 不必要な残業をなくす | 業務の効率化と労働者の健康維持のため| 勤務時間を記録する機能、残業目的の明確化 |
| 労働の対価を視覚化する | 労働者のモチベーションアップと最低賃金法違反を防ぐ  | 賃金計算機能 |

# DEMO
- topページ
![demo](https://gyazo.com/b680668f5d0da775286e6042e3b5501b/raw)
- 仕事中ページ
![demo](https://gyazo.com/6654c0e71dea32f0fcea15fa2e717fc2/raw)
- 勤務終了
![demo](https://gyazo.com/579efc397a4939f72a3437fd7ec8cd91/raw)
- 個人ページ
![demo](https://gyazo.com/33beed78b3fab7b1eeed490f2e1b6bdb/raw)

# 工夫したポイント
- 打刻のしやすさ：submitをクリックするだけで完了する
- 9時、12時、18時に、勤務中ページにコメントを表示。休憩時間、勤務時間をわかりやすくした
- 管理職だけが、従業員に対してコメントすることができる
- 従業員は、管理職に対して残業申請をすることができる
- 個人ページで、労働日、労働時間、賃金、自分が発信したコメントを確認できる

# 使用技術(開発環境)
Ruby 2.6.5 Rails 6.0.0 mysql2 0.4.4 utf8

# 課題や今後実装したい機能
- 打刻機能について、改ざんを防ぐセキュリティの検討
- 賃金の計算：時間単位になっているので、分単位で計算できるようにする
- 賃金の表示をわかりやすく：料金を,で区切る
- 月給表示機能：月の合計賃金の表示
- 時間外労働は賃金25%増計算(1日８時間→済み、週40時間以上は時間外労働となる)
- 時間外労働が月60時間を超えると、賃金は50％増計算
- 22時から５時までは賃金25％増の夜間勤務の計算（賃金の割増は重複する）→済み
- 休日出勤は賃金35％増の計算（週1日、月4日は法定休日となる）
- カウントダウン表示機能：休憩の残り時間を表示する
- excelなどのファイルに統計資料としてダウンロードできる
- カレンダーアプリとの連携
- 勤務地が固定であれば、GPSを使って、自動的に打刻を行う

# DB設計

## users テーブル

| Column   | Type   | Options     |
| -------- | ------ | ----------- |
| username | string | null: false |
| email    | string | null: false |
| password | string | null: false |


### Association

- has_many :works
- has_many :wages
- has_many :comments

## works テーブル

| Column     | Type       | Options           |
| ---------- | ---------- | ----------------- |
| start_time | integer    | null: false       |
| user       | references | foreign_key: true |

### Association

- belongs_to :user
- has_one    :wage
- has_many   :comments

## wages テーブル

| Column   | Type       | Options           |
| -------- | ---------- | ----------------- |
| end_time | integer    | null: false       |
| paying   | integer    | null: false       |
| user     | references | foreign_key: true |
| work     | references | foreign_key: true |

### Association

- belongs_to :user
- belongs_to :work

## comments テーブル
| Column | Type       | Options           |
| ------ | ---------- | ----------------- |
| text   | text       | null: false       |
| user   | references | foreign_key: true |
| work   | references | foreign_key: true |

### Association

- belongs_to :user
- belongs_to :work

![demo](https://gyazo.com/712c794397ae3392650f4008d0b68517/raw)