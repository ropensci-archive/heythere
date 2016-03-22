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
    Heythere.hey_there(repo = 'sckott/testhey')
  rescue
    next
  end
end

desc "list env vars"
task :envs do
  puts 'label target:        ' + Heythere.label_target
  puts 'label assigned:      ' + Heythere.label_assigned
  puts 'label review in:     ' + Heythere.label_review_in
  puts 'pre deadline days:   ' + Heythere.pre_deadline_days
  puts 'deadline days:       ' + Heythere.deadline_days
  puts 'deadline every days: ' + Heythere.post_deadline_every_days
  puts 'remind after review days: ' + Heythere.post_review_in_days
  puts 'remind after review (toggle): ' + Heythere.post_review_toggle
end

# desc "hey - but local"
# task :hi, [:repo] do |t, args|
#   puts "Restarting build for: #{args[:repo]}"
#   hey_there_local(args[:repo])
# end

#hey_there(repo = 'sckott/testhey')
