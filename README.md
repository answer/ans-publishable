ans publishable
===============

同時に実行しても重複しないコレクションを取得するメソッドを提供する

	class Article < ActiveRecord::Base
	  include Ans::Publishable
	end
	
	Article.publish({scope_params: args}) do |article|
	  # article に対して重複しない処理を記述
	end

1. 一意な `publish_id` を生成
2. コレクションに `publish_id` を設定
3. 各レコードごとに transaction して与えられたブロックを処理
4. StandardError が発生した場合はそのレコードのみ transaction でロールバックされ、 `publish_id` を nil に戻す

メソッド
--------

### publish(hash) ###

Article.publishable(hash) で返されるコレクションに ArticlePublish.id を設定

`where(publish_id: id)` を返す

### revert_publish ###

`article.revert_publish` で `publish_id` を削除


規約
----

Article の publishable を取得するなら、

* `Article.publishable(hash)` が定義されていること
* `ArticlePublish` で `publish_id` を振り出すこと
* `Article.article_publish_id` に `publish_id` を持つこと
* `ArticlePublish.id` を `publish_id` として扱うこと


== オーバーライド

* `publishable_scope` でメソッド名を返すことで、 `publishable` 以外のスコープを使用可能
* `publish_model` でモデルクラスを返すことで、 `ArticlePublish` 以外のモデルを使用可能
* `publish_foreign_key` でカラム名を返すことで、 `article_publish_id` 以外のカラムを使用可能
* `publish_primary_key` でカラム名を返すことで、 `ArticlePublish.id` 以外のカラムを使用可能

