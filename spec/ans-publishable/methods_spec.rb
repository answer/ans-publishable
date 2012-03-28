# -*- coding: utf-8 -*-

require "spec_helper"

describe Ans::Publishable::Methods do
  include Ans::Feature::Helpers::ActionHelper

  describe ".publish" do
    before do
      class AnsPublishableMethods_Article
        extend Ans::Publishable::Methods
        def self.transaction
          yield
        end
        def self.table_name
          "articles"
        end
        def self.model_name
          "AnsPublishableMethods_Article"
        end
      end
      class AnsPublishableMethods_ArticlePublish; end
      class AnsPublishableMethods_ArticleSend; end

      @id = 1
      @other_id = 2

      @result = Object.new
      @other_result = Object.new

      @args = Object.new

      stub(AnsPublishableMethods_Article).where(article_publish_id: nil){AnsPublishableMethods_Article}
      stub(AnsPublishableMethods_Article).where(send_id: nil){AnsPublishableMethods_Article}
      stub(AnsPublishableMethods_Article).publishable{AnsPublishableMethods_Article}
      stub(AnsPublishableMethods_Article).other_publishable{AnsPublishableMethods_Article}
      stub(AnsPublishableMethods_Article).update_all

      stub(AnsPublishableMethods_Article).where(article_publish_id: @id){@result}
      stub(AnsPublishableMethods_Article).where(article_publish_id: @other_id){@other_result}

      stub(AnsPublishableMethods_Article).where(send_id: @id){@result}
      stub(AnsPublishableMethods_Article).where(send_id: @other_id){@other_result}

      the_action do
        AnsPublishableMethods_Article.publish(@args)
      end
    end

    context "例外が発生しない場合" do
      before do
        @publish = Object.new

        stub(AnsPublishableMethods_ArticlePublish).create{@publish}

        stub(@publish).send(:id){@id}
        stub(@publish).send(:other_id){@other_id}
      end

      context "デフォルトのメソッド構成でコールする場合" do
        it "は、 Publish を作成してその ID を持つコレクションを返す" do
          the_action.should == @result
          AnsPublishableMethods_Article.should have_received.where(article_publish_id: nil)
          AnsPublishableMethods_Article.should have_received.publishable(@args)
          AnsPublishableMethods_Article.should have_received.update_all(article_publish_id: @id)
          AnsPublishableMethods_Article.should have_received.where(article_publish_id: @id)
        end
      end

      context "publishable_scope をオーバーライドする場合" do
        before do
          stub(AnsPublishableMethods_Article).publishable_scope{:other_publishable}
        end
        it "は、 other_publishable を使用して返す" do
          the_action.should == @result
          AnsPublishableMethods_Article.should have_received.other_publishable(@args)
        end
      end

      context "publish_model をオーバーライドする場合" do
        before do
          stub(AnsPublishableMethods_Article).publish_model{AnsPublishableMethods_ArticleSend}

          @other_publish = Object.new

          stub(AnsPublishableMethods_ArticleSend).create{@other_publish}

          stub(@other_publish).send(:id){@id}
          stub(@other_publish).send(:other_id){@other_id}
        end
        it "は、 AnsPublishableMethods_ArticleSend を使用して返す" do
          the_action.should == @result
        end
      end

      context "publish_foreign_key をオーバーライドする場合" do
        before do
          stub(AnsPublishableMethods_Article).publish_foreign_key{:send_id}
        end
        it "は、 send_id を使用して返す" do
          the_action.should == @result
          AnsPublishableMethods_Article.should have_received.where(send_id: nil)
          AnsPublishableMethods_Article.should have_received.publishable(@args)
          AnsPublishableMethods_Article.should have_received.update_all(send_id: @id)
          AnsPublishableMethods_Article.should have_received.where(send_id: @id)
        end
      end

      context "publish_primary_key をオーバーライドする場合" do
        before do
          stub(AnsPublishableMethods_Article).publish_primary_key{:other_id}
        end
        it "は、 other_id を使用して返す" do
          the_action.should == @other_result
          AnsPublishableMethods_Article.should have_received.update_all(article_publish_id: @other_id)
          AnsPublishableMethods_Article.should have_received.where(article_publish_id: @other_id)
        end
      end

    end

    context "例外が発生する場合" do
      before do
        # retry 5回
        stub(AnsPublishableMethods_ArticlePublish).create.times(5){raise "作成エラー"}
      end
      it "は、例外を発生させる" do
        proc{the_action}.should raise_error("作成エラー")
      end
    end

  end

end

