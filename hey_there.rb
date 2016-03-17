require 'date'
require 'octokit'
require_relative 'helpers'
require_relative 'configuration'

module Heythere
  extend Configuration

  define_setting :pre_deadline_days, ENV['HEYTHERE_PRE_DEADLINE_DAYS'] || "15"
  define_setting :deadline_days, ENV['HEYTHERE_DEADLINE_DAYS'] || "21"
  define_setting :post_deadline_every_days, ENV['HEYTHERE_POST_DEADLINE_EVERY_DAYS'] || "4"
  define_setting :label_target, ENV['HEYTHERE_LABEL_TARGET'] || 'package'
  define_setting :label_assigned, ENV['HEYTHERE_LABEL_ASSIGNED'] || 'editor-assigned'
  define_setting :label_review_in, ENV['HEYTHERE_LABEL_REVIEW_IN'] || 'review-in-awaiting-changes'

  def self.hey_there(repo)
    puts 'using repo ' + repo
    is = Octokit.issues repo, :per_page => 100
    puts is.length.to_s + ' issues found'
    if is.length == 0
      raise 'no issues found'
    else
      # remove issues that aren't packages
      is = is.only_packages

      # for each issue, run through labels and days since events
      is.each do |x|
        info = x.to_h.get_info

        tags = x['labels'].map(&:name)
        if tags.has?('holding')
          puts sprintf('%s issue %s %s', repo, x['number'], 'on hold, skipping')
        else
          if tags.has?(Heythere.label_assigned) and !tags.has?(Heythere.label_review_in)
            puts sprintf('%s issue %s %s', repo, x['number'], 'editor-assigned and no reviews in, checking days since')
            # if editor-assigned and no reviews in, ping reviewers
            ## get issue comments
            iscomm = Octokit.issue_comments(repo, x['number'])
            tmp = iscomm.select { |a,b| a[:body].match('Reviewers:') }
            ## get date reviewers assigned
            rev_assgn = tmp[0][:created_at]
            ## if more than x days, ping, else stop
            if days_since(rev_assgn) < Heythere.deadline_days
              ## it's been < days since setting, don't ping the issue
              puts sprintf('%s issue %s %s', repo, x['number'], 'is within day limit, checking for predeadline ping')
              if days_since(rev_assgn) > Heythere.pre_deadline_days
                ## get reviewer handles
                revs = tmp[0][:body].sub(/Reviewers:/, '').split(/,/).map(&:strip)
                ## mention reviewers with message
                mssg = sprintf("%s - hey there, it's been %s days, please get your review in by %s, thanks :smiley_cat:",
                  revs.join(' '), days_since(rev_assgn), Heythere.deadline_days - days_since(rev_assgn))
                ### add the comment
                ff = Octokit.add_comment(repo, x['number'], mssg)
                puts 'sent off ' + ff.length.to_s + 'comments'
              else
                puts sprintf('%s issue %s %s', repo, x['number'], 'is less than half way, skipping')
              end
            else
              ## get reviewer handles
              revs = tmp[0][:body].sub(/Reviewers:/, '').split(/,/).map(&:strip)
              ## mention reviewers with message
              mssg = sprintf("%s - hey there, it's been %s days, please get your review in soon, thanks :smiley_cat:",
                revs.join(' '), days_since(rev_assgn))
              ### add the comment
              ff = Octokit.add_comment(repo, x['number'], mssg)
              puts 'sent off ' + ff.length.to_s + 'comments'
            end
          else
            # review in, awaiting changes => ping if been more than days_wait
            if tags.has?(Heythere.label_review_in)
              puts sprintf('%s issue %s %s', repo, x['number'], 'not awaiting changes, skipping')
            else
              puts sprintf('%s issue %s %s', repo, x['number'], 'reviews in, awaiting changes, continuing...')
              iscomm = Octokit.issue_comments(repo, x['number'])
              iscomm.last
            end
          end
        end
      end
    end
  end

end
