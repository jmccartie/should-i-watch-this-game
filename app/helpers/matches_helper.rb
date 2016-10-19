module MatchesHelper

  def watch_stars(match)
    str = ""
    str << '<span class="glyphicon glyphicon-star" aria-hidden="true"></span>' * match.watch_score
    str << '<span class="glyphicon glyphicon-star-empty" aria-hidden="true"></span>' * (5-match.watch_score)

    str.html_safe
  end
end
