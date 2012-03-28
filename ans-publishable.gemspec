# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ans-publishable/version"

Gem::Specification.new do |s|
  s.name        = "ans-publishable"
  s.version     = Ans::Publishable::VERSION
  s.authors     = ["sakai shunsuke"]
  s.email       = ["sakai@ans-web.co.jp"]
  s.homepage    = "https://github.com/answer/ans-publishable"
  s.summary     = %q{重複しないコレクションを生成する}
  s.description = %q{一意な ID を生成し、そこに重複しないコレクションを登録する}

  s.rubyforge_project = "ans-publishable"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  s.add_development_dependency "ans-gem-builder"
  s.add_development_dependency "ans-feature-helpers"
end
