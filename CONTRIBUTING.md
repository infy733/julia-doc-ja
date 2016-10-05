# 翻訳の指針

対訳表は`TranslationTable.md`

#. ひらがなで書くのが適当な語の例は[こちら](http://www.yamanouchi-yri.com/yrihp/techwrt-2-4s/t-2-4s03fb.html)を参考にする。
#. 日本語文中の括弧は全角`（）`に統一。ただし原文の英単語を残したい場合の括弧のみ半角とする。例： 配列(array)
#. 「！」と「？」は全角で統一する。文末の場合は直前に半角スペースを空けるが、文中では空けない。
#. `ー`は多くの場合削除する。（例: `サーバー`ではなく`サーバ`）、例外は`TranslationTable.md`に記載
#. [総称用法の`you`は訳さない](http://einzelzelle.blogspot.jp/2014/01/blog-post.html)
#. ファイルごとに翻訳をする。開始した時点で以下を実行する。
 * すぐにPRを作成する。
 * [Projectのページ](https://github.com/hshindo/julia-doc-ja/projects)から Add cardsでPRをworking の列に移動。
 * TBDから対応するカードを消す。
#. 原文はコメントアウトし、その下に一行開けて翻訳文を書く。
#. 原文に忠実に訳すよりも、技術者が読んで意味が通る(最短時間で理解できる)文章であることを優先する。
#. 翻訳が全て終わったら、いったん自己点検した後にPRのページで終わった旨を宣言し、プロジェクトページのカードをworkingからreviewingに変更する。
#. マージしたらDoneに移す。
