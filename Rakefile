require "ans-releaser"

class Task
  include Ans::Releaser::GemTask

  def gem_host
    "gem.ans-web.co.jp"
  end
  def gem_root
    "/var/www/gem/public"
  end
end

Task.new.build_release_tasks
