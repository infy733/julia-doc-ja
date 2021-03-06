# 翻訳の指針

対訳表は`TranslationTable.md`

## スタイル

### 全体として

1. [総称用法の`you`は訳さない](http://einzelzelle.blogspot.jp/2014/01/blog-post.html)
1. 原文はコメントアウトし、その下に一行開けて翻訳文を書く。
1. 原文に忠実に訳すよりも、技術者が読んで意味が通る(最短時間で理解できる)文章であることを優先する。
1. 同様の意味を伝えられる文の候補が2つ以上あった場合、最も文字数が少ないものを選ぶ。

### 表記ルール

1. ひらがなで書くのが適当な語の例は[こちら](http://www.yamanouchi-yri.com/yrihp/techwrt-2-4s/t-2-4s03fb.html)を参考にする。
1. 日本語文中の括弧は全角`（）`に統一。ただし原文の英単語を残したい場合の括弧のみ半角とする。例： 配列(array)
1. 「！」と「？」は全角で統一する。文末の場合は直前に半角スペースを空けるが、文中では空けない。
1. `ー`は多くの場合削除する。（例: `サーバー`ではなく`サーバ`）、例外は`TranslationTable.md`に記載
1. 日本語だと斜体での表示に違和感があるため、強調文では必ず`*`を２つ使用する。例: `**ここは重要です！**`
1. 訳注は
 * インラインで書く場合は （訳注: ここに内容を書く）のように書く
 * 長くなる場合は以下のようにCitation記法を使用し、ファイルの最後にまとめて書く。

```
本文 [訳注1]_ 本文本文
本文本文


.. [訳注] ここに
    内容を書く

```

## 進め方

### reviewまでの手順

1. ファイルごとに翻訳をする。開始した時点で以下を実行する。
 * すぐにPRを作成する。
 * [Projectのページ](https://github.com/hshindo/julia-doc-ja/projects)から Add cardsでPRをworking の列に移動。
 * TBDから対応するカードを消す。
1. 翻訳が全て終わったら、いったん自己点検した後にPRのページで終わった旨を宣言し、プロジェクトページのカードをworkingからreviewingに変更する。

### reviewの手順


PR内の最新のドキュメントのhtmlをs3で保持しているので、以下のURLから閲覧する。

`http://juliadocja.s3-website-ap-northeast-1.amazonaws.com/<PR番号>`

差分のチェックと、Rendering後のhtmlが正しいことの確認とが終了したら、マージしてProjectのカードをreviewからDoneに移す。 -> 自動でmasterが更新され、[gh-pages](https://naist-cl-parsing.github.io/julia-doc-ja/) が更新される。
