ans publishable
===============

同時に実行しても重複しないコレクションを取得するメソッドを提供する

Usage
-----

	class Article < ActiveRecord::Base
	  include Ans::Publishable
	end
	
	Article.publish(scope_params) do |article|
	  # article に対する何らかの処理
	end

時間を置かずに実行されても、同じモデルに対して、二重に処理することがないように考慮している

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

