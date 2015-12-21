require 'octokit'
require_relative 'repos'
require_relative 'hey_there'

desc "checks X repo for any issues that need reminders, and pings if so"
task :hey do
  Octokit.configure do |c|
    c.login = ENV['GITHUB_USERNAME']
    c.password = ENV['GITHUB_PAT_OCTOKIT']
  end

  begin
    hey_there('sckott/testhey')
  rescue
    next
  end
end

# desc "hey - but local"
# task :hi, [:repo] do |t, args|
#   puts "Restarting build for: #{args[:repo]}"
#   hey_there_local(args[:repo])
# end
