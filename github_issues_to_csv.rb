# GitHub Issue Exporter
# refs: https://gist.github.com/tkarpinski/2369729

require 'octokit'
require 'csv'
require 'date'
require 'yaml'

def convert_body(body)
  status = :default

  desc = {us: '', ac: ''}

  body.each_line do |line|
    if line =~ /ユーザーストーリー/
      status = :us
      next
    end
    if line =~ /受け入れ条件/
      status = :ac
      next
    end

    if line.gsub(/(\s)/,"") == ""
      next
    end
    line.gsub!(/(\r\n)/, "\r")

    case status
    when :us then
      desc[:us] << line
    when :ac
      desc[:ac] << line
    end
  end

  desc[:us].gsub!(/(\r$)/, "")
  desc[:ac].gsub!(/(\r$)/, "")
  desc
end

app_config = YAML.load_file("config.yml")

client = Octokit::Client.new(
  :login => app_config["github"]["credential"]["username"],
  :password => app_config["github"]["credential"]["password"])

csv = CSV.new(File.open(File.dirname(__FILE__) + "/issues_sjis.csv", 'w', :encoding => "SJIS"))

puts "Initialising CSV file..."
#CSV Headers
header = [
  "番号",
  "タイトル",
  "ユーザーストーリー",
  "受け入れ条件",
  "作成日時",
  "更新日時",
  "マイルストーン",
  "優先度",
  "ステータス",
  "作成者",
  "GitHub Issue URL",
]
csv << header

puts "Getting issues from Github..."
temp_issues = []
issues = []
page = 0
begin
  page = page +1
  temp_issues = client.list_issues("#{app_config["github"]["repository"]}", :state => "closed", :page => page)
  issues = issues + temp_issues;
end while not temp_issues.empty?
temp_issues = []
page = 0
begin
  page = page +1
  temp_issues = client.list_issues("#{app_config["github"]["repository"]}", :state => "open", :page => page)
  issues = issues + temp_issues;
end while not temp_issues.empty?


puts "Processing #{issues.size} issues..."
issues.each do |issue|
  unless issue['labels'].to_s =~ /プロダクトバックログ/
    next
  end
  puts "Processing issue #{issue['number']}..."

  # Work out the priority based on our existing labels
  case
    when issue['labels'].to_s =~ /優先度：高/i
      priority = "高"
    when issue['labels'].to_s =~ /優先度：中/i
      priority = "中"
    when issue['labels'].to_s =~ /優先度：低/i
      priority = "低"
  end
  milestone = issue['milestone'] || "None"
  if (milestone != "None")
    milestone = milestone['title']
  end

  desc = convert_body(issue['body'])

  row = [
    issue['number'],
    issue['title'],
    desc[:us],
    desc[:ac],
    issue['created_at'],
    issue['updated_at'],
    milestone,
    priority,
    issue['state'],
    issue['user']['login'],
    issue['html_url']
  ]
  csv << row
end
