ans publishable
===============

同時に実行しても重複しないコレクションを取得するメソッドを提供する

Usage
-----

Article モデルに対して処理を行う場合、

	class Article < ActiveRecord::Base
	  include Ans::Publishable
	  
	  scope :publishable, lambda{|args|
	    # 処理を実行するコレクションを返す
	    # article_publish_id is null の条件は自動で追加される
	  }
	end
	
	# Article に article_publish_id カラムを追加
	
	# ArticlePublish モデルを追加
	class ArticlePublish < ActiveRecord::Base
	  # カラムは id 以外は必要ない
	end

	# job
	Article.publish(scope_params) do |article|
	  # article に対する何らかの処理
	end

時間を置かずに実行されても、同じモデルに対して、二重に処理することがないように考慮している

用例
----

- メールキューの処理 : 送信時刻が過去の、未送信のメールを送信する
- ポイントの追加 : 実行時刻が過去の、未処理のキューを処理してポイントを追加、メールの送信等を行う

メールの送信や、ポイントの追加など、二重処理すると困る場合

スケジューラーで処理を行なっている場合、機械の状態によって前の実行が終わらないうちに
次の実行が始まってしまう可能性があり、二重処理されてしまう

内部仕様
--------

1. ArticlePublish モデルにより、一意な `article_publish_id` を生成
2. Article の `article_publish_id` に生成した `id` を設定
3. その `id` を持つ Article を順に取得して transaction を張りつつブロックを処理
4. StandardError が発生した場合はそのレコードのみ transaction でロールバックされ、 `publish_id` を nil に戻す

publish メソッドにブロックを渡さなかった場合、生成した `article_publish_id` を持つ Article のリレーションが返される

規約
----

Article の publishable を取得する場合、

* `Article.publishable(hash)` が定義されていること
* `ArticlePublish` で `publish_id` を振り出すこと
* `Article.article_publish_id` に `publish_id` を持つこと
* `ArticlePublish.id` を `publish_id` として扱うこと

### オーバーライド

* `publishable_scope` でメソッド名を返すことで、 `publishable` 以外のスコープを使用可能
* `publish_model` でモデルクラスを返すことで、 `ArticlePublish` 以外のモデルを使用可能
* `publish_foreign_key` でカラム名を返すことで、 `article_publish_id` 以外のカラムを使用可能
* `publish_primary_key` でカラム名を返すことで、 `ArticlePublish.id` 以外のカラムを使用可能

