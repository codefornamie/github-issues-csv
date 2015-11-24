# github-issues-csv
githubのIssueをプロダクトバックログの形式でexcelで一覧できるようにエクスポートするスクリプト

# このスクリプトについて

GitHubのIssueを使ってプロダクトバックログを記述した際に、それをエクセル形式で一覧できるように変換します。

# Issueのルール

* 「プロダクトバックログ」というLabelが付けられている
* 「優先度：高」「優先度：中」「優先度：低」の3つのLabelのどれかが付けられている
* 「ユーザーストーリー」という行を書き、その下にユーザーストーリーの内容を書く
* 「受け入れ条件」という行を書き、その下に受け入れ条件を書く

このレポジトリのサンプルを参照。

# 使い方

* 自分の環境に合わせた設定ファイルを作成

```
cp config.sample.yml config.yml
# config.ymlの中身を対応するものに変更
```

* 依存ライブラリをインストール後、実行

```
bundle install
bundle exec ruby github_issues_csv.rb
```


<img width="507" alt="2015-11-24 19 38 52" src="https://cloud.githubusercontent.com/assets/843192/11364325/15fb89bc-92e3-11e5-916e-e304e6957f92.png">

<img width="1013" alt="2015-11-24 19 39 00" src="https://cloud.githubusercontent.com/assets/843192/11364335/225739a4-92e3-11e5-95de-e5b9ece05827.png">

<img width="1332" alt="2015-11-24 19 38 39" src="https://cloud.githubusercontent.com/assets/843192/11364321/096a1542-92e3-11e5-8b7d-ef174383940b.png">

