# encoding: utf-8

require 'adapi'

# Example work-flow:
# * try to add keywords which will trigger policy violation errors (PolicyViolationError)
# * adapi will perform exemption requests (check the adapi log for more details)
# * if keyword errors are exemptable, they will be eventually added

# create ad group
require_relative 'add_bare_ad_group'

$keywords = Adapi::Keyword.new(
  :ad_group_id => $ad_group[:id],
  :keywords => [ 'lékárna', 'lekarna', 'leky' ]
)

$result = $keywords.create

if $keywords.errors.empty?
  puts "OK"

  # get array of keywords from Keyword instance
  $google_keywords = Adapi::Keyword.find(:all, :ad_group_id => $ad_group[:id]).keywords

  $params_keywords = Adapi::Keyword.parameterized($google_keywords)

  $short_keywords = Adapi::Keyword.shortened($google_keywords)

  puts "PARAMS:"
  pp $params_keywords

  puts "\nSHORT:"
  pp $short_keywords
else
  puts "ERROR"
  puts $keywords.errors.full_messages.join("\n")
end
