require 'date'
require_relative 'helpers'

def hey_there(repo, days_since_last = 10)
  is = Octokit.issues repo, :per_page => 100
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
        if tags.has?('editor-assigned') and !tags.has?('editor-assigned')
          # if editor-assigned and no reviews in, ping reviewers
          ## get issue comments
          iscomm = Octokit.issue_comments(repo, x['number'])
          ## get date reviewers assigned
          rev_assgn = tmp[0][:created_at]
          ## if more than x days, ping, else stop
          if days_since(rev_assgn) < days_since_last
            ## it's been < days since setting, don't ping the issue
            puts sprintf('%s issue %s %s', repo, x['number'], 'is within day limit, skipping')
          else
            ## get reviewer handles
            tmp = iscomm.select { |a,b| a[:body].match('Reviewers:') }
            revs = tmp[0][:body].sub(/Reviewers:/, '').split(/,/).map(&:strip)
            ## mention reviewers with message
            mssg = sprintf("%s, hey there, it's been %s days, please get your review in soon, thanks :smiley_cat:",
              revs.join(' '), days_since(rev_assgn))
            ### add the comment
            Octokit.add_comment(repo, x['number'], mssg)
          end
        else
          # review in, awaiting changes => ping if been more than days_wait
          if tags.has?('review-in-awaiting-changes')
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
