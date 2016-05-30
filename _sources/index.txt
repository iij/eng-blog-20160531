==============================
ドキュメントの継続的な開発方法
==============================

はじめまして、分散システム技術課の藤本です。

私はソフトウェア開発を主体とするエンジニアで、

- クラウドサービスの開発・運用
- 分散処理技術の検証とサービス利用の検討
- 社内の開発支援環境の開発・運用

などの業務に従事していますが、今回の記事は業務とは直接的な関係は無く、私が会社で勝手^H^H自発的に行っている取り組みについて書きたいと思います。

昨今、インターネットは生活に深く浸透し、クラウドサービスを利用することで安く簡単にWebサービスを開発、公開できるようになりました。
Web技術の進化や流行の移り変りも非常に激しく、既存サービスの機能追加や新規サービスの開発は頻繁に行われています。それは弊社も例外ではありません。

このような開発の現場では、リーンソフトウェア開発への取り組みなど開発手法の最適化が積極的に行われ、様々なベストプラクティスが生みだされています。
それらのベストプラクティスには、 **継続的インテグレーション** や **継続的デプロイメント** というものがあり、これらの自動化を行うことにより、

- 開発に集中することができる
- テストによって一定の品質を継続的に確保し易くなる
- 人的なミスを防ぎ易くなる

というような多くのメリットを享受する事ができます。

これらのメリットは開発者の生産性向上に大きく寄与する事から、現在では自動テストや自動デプロイは当り前になりつつあります。
ソフトウェア開発においては既に語り尽されていると思いますので、今回は **自然言語で書かれたドキュメントに対する同じような最適化の手法** についてご紹介したいと思います。


ドキュメントも開発対象？
========================

どのような開発手法でも、仕様書や利用者向けのマニュアルなど自然言語で書かれた **ドキュメント** は必ず作成すると思います。

それらのドキュメントもソースコードと同様に成果物の1つですから、機能の追加開発など行う際には開発対象の1つとしてドキュメントを考慮する必要があります。
仕様書とソースコードのギャップは開発者を混乱させますし、マニュアルが間違っていると利用者はそのソフトウェアやサービスに対して不信感を抱きます。

従って、 **ドキュメントもソースコードと同様に適切に管理し、開発していく必要があります。**

（…と偉そうなことを書いていますが、私は文章を書くのがすごく苦手なので、ちゃんと実践できているかどうか…正確に伝わる文章を書くのは本当に難しいです）


ドキュメントのファイル形式
==========================

かつてドキュメントといえばMicrosoftのOffice製品を使うことが多かったと思いますが、
最近では Markdown_ や `reStructuredText（reST）`_ のような **軽量マークアップ言語** を利用するケースも増えてきていると思います。

軽量マークアップ言語を用いたドキュメント作成の大きな特徴として、以下のものが挙げられます。

- プレーンテキストである（シンプルなテキストエディタで編集できる）
- PDFやHTML形式に変換することができる
- 特別な変換を行わなくても可読性が高い
- それぞれの記法を使うことでワープロソフトに近い柔軟な表現もできる

加えて、軽量マークアップ言語を用いたドキュメントはプレーンテキストなので **バージョン管理システム** と相性が良く、
バージョン管理のメリットとそれらのレポジトリと連携する Github_ や Trac_ などの開発を支援するサービスやツールのメリットを最大限に享受することができます。

以上のような事から、私の所属するチームでは利用者向けのWebマニュアルを作成/公開に Sphinx_ を活用しています。
以降では、このWebマニュアルの作成を例に具体的なドキュメントを開発方法をご紹介したいと思います。


Webマニュアルの作成環境
=======================

前述のとおり Sphinx_ を使用したドキュメントの作成環境をご紹介します。

Sphinxのインストール方法は `Sphinxをはじめよう`_ に分かりやすくまとまっています。
また、 Virtualenv_ という仮想的なPythonの実行環境を作成するツールを使用することで、システム共通の実行環境を汚すことなくSphinxをインストールすることができます。


Virtualenv を利用した環境構築の例
---------------------------------

pip_ というパッケージ管理ツールと Virtualenv_ を事前にインストールした状態で以下のようにコマンドを実行します。

.. code-block:: bash

   $ cd your_document_directory
   $ virtualenv .
   $ source bin/activate

上記を実行することで仮想的なPythonの実行環境が作成され、その環境を利用可能な状態になります。

次に、pipを使用してSphinxやそれに付随するライブラリをインストールします。
pipにはインストールしているライブラリの一覧出力（ ``pip freeze -l > FILE`` ）とその出力を指定して一括でインストール（ ``pip install -r FILE`` ）する方法が用意されていますので、
以下のような依存ライブラリの定義ファイル（ ``requirements.txt`` ）を用意しておくことで、簡単に環境を作ることができます。

.. code-block:: bash

   $ pip install sphinx docutils-ast-writer
   $ pip freeze -l > requirements.txt

（※以下は、2016年03月31日時点でのSphinxとその依存ライブラリです。試す場合には最新のもののご利用をお勧めします）

.. code-block:: text

   alabaster==0.7.7
   Babel==2.2.0
   docutils==0.12
   docutils-ast-writer==0.1.0
   imagesize==0.7.0
   Jinja2==2.8
   MarkupSafe==0.23
   Pygments==2.1.3
   pytz==2016.3
   six==1.10.0
   snowballstemmer==1.2.1
   Sphinx==1.4

.. seealso::

   新しく環境を作成する場合には、以下を実行することで簡単に作ることができます。

   .. code-block:: bash

      $ pip install -r requirements.txt

以上でSphinxを利用するための環境が整いました。次に、以下のようにSphinxのプロジェクトを作成します。

.. code-block:: bash

   $ sphinx-quickstart


コマンドを実行すると対話型のプロジェクト初期設定が始まるので、ここで設定を行います。（よくわからなければデフォルトで問題ないと思います）

プロジェクトの初期化処理が終了すると *Makefile* および *make.bat* ファイルが生成されるので、以下のように ``make`` コマンドを実行する事により、
初期化時に指定したビルドディレクトリ（デフォルトでは ``_build/`` ）配下にHTMLが生成されます。

.. code-block:: bash

   $ make html

以上が Virtualenv_ を利用した Sphinx_ のドキュメント作成環境を作る手順です。

あとは、reSTの記述 → ``make`` の実行 → 確認のサイクルの繰り返しになります。

.. image:: _static/images/sphinx-writing-cycle.png
   :width: 800px

reSTの記法については、以下のサイトに分かりやすくまとまっていますのでご参照ください。
  - `reStructuredText入門 - Sphinx 1.4 ドキュメント <http://docs.sphinx-users.jp/rest.html>`_
  - `逆引き辞典 - Python製ドキュメンテーションビルダー、Sphinxの日本ユーザ会 <http://sphinx-users.jp/reverse-dict/index.html>`_

.. seealso::

   複数のVirtualenv環境を使い分ける場合は Virtualenvwrapper_ を利用すると管理しやすくなります。



バージョン管理
==============

前述の通り、reSTなどの軽量マークアップ言語で記述したドキュメントはプレーンテキストなので、
Git_ や Subversion_ などのバージョン管理システムと相性が良いです。

バージョン管理システムを利用することで、変更点の確認や切り戻しが簡単にできるようになるだけで無く、
自動テストや自動デプロイ、以下で紹介する Github_ を利用した開発フロー構築の足掛りとなります。

IIJではGithub Enterpriseを導入しており、私の所属チームでもGitでバージョン管理を行っているので、
以降の説明では **Githubの機能を利用した管理方法** を紹介します。


継続的インテグレーション（CI）
==============================

個人的な体験として、reSTのドキュメントをチームで書いていた時に
「構文チェックを行わずに ``git push`` （リモートブランチに適用）してしまい、 Sphinx_ でビルドを行う際にシンタックスエラーが発生してしまう」
という状況に何度も遭遇しました。

シンタックスエラーが発生する度にどのコミットでエラーになったのかを確認するのは大変ですし、デプロイを自動化するには少なくともシンタックスエラーを検出することは必要です。

そこで私のチームでは、Githubと連携する Drone_ というオープンソースのCIツールを利用して、自動的にシンタックスを検査するようにしました。
Sphinxには ``sphinx-build`` コマンドの ``-W`` オプションを付けることで警告レベルの問題もエラーとして扱うようになり、CIツールからシンタックスエラーを検出できるようになります。

Droneを使用する場合は、drone.yml というファイルを追加し、Droneの管理画面からレポジトリを登録することでGithubと連携して動作するようになります。

以下は、Droneの設定ファイル（.drone.yml）の記述例です。

.. code-block:: yaml

   image: centos6
   script:
     - pip install -r requirements.txt
     - sphinx-build -W -b html source/ build/

インターネットからアクセスできる環境でしたら `drone.io`_ や `Travis CI`_ などのCIサービスを利用することもできます。


マニュアル作成/公開フロー
=========================

Github_ のPull Requestの仕組みを使うことで綺麗なフローを構築することができると思います。

以下は、私のチームで採用しているマニュアルの作成・変更から公開までのフローです。

.. image:: _static/images/flow.png
   :width: 500px

ブランチの構成は以下の通りです。

==================== ============================================================================================
ブランチ名	         説明
==================== ============================================================================================
master               | 公開中のマニュアル
                     | masterにマージされたものは自動的に本番環境にデプロイして公開
develop	             | 査読済みのマニュアル
                     | ステージングの公開サーバに自動的にデプロイし、最終確認を終えたらmasterにPull Requestを出す
<topic name>         | マニュアルの作成、修正時に作成するトピックブランチ
                     | developブランチにPull Requestを出す
==================== ============================================================================================


textlintを使用した文章校正と自動テスト
======================================

.. image:: _static/images/textlint.png
   :width: 800px

弊社にはIIJ表記ガイドラインというドキュメントを書く際の表記ルールがあり、社外に公開するドキュメントはその表記ルールに準ずる必要がありますが、
この表記ルールは量が多く詳細なため一人一人が全てのルールを把握することは難しく、表記ルールを確認しながらドキュメントを書くのは非効率です。

そこで、自然言語もチェックすることができる textlint_ という文章校正ツールを利用し、文章チェックの自動化を試みています。

textlintはMarkdownやHTMLなどの形式にデフォルトで対応し、また他のテキスト形式のサポートや文章の検査内容の定義（ルール）をプラグイン形式で自由に追加することができるなど、非常に高い柔軟性が特徴のツールです。

執筆時点での最新バージョンは *v6.6.0* ですが、頻繁に新しいバージョンがリリースされており開発の活発さが伺えます。
*v6.0.0* からは実験的な機能だった自動修正が正式にサポートされ、機械的に修正可能なところは自動的に修正することができるようになりました。
従来は既存ドキュメントへの適用に際して手動で修正が必要な点が手間となっていましたが、
この機能の正式サポートにより修正作業まで自動化が可能になったため、導入のメリットが一段と向上しています。

textlintのルールは、 ESLint_ や Babel_ などで採用されているプラグインモデルを採用しており、
小さくシンプルなルールを組み合わせて使う設計となっているので高い再利用性と柔軟性を持つ一方で、
プリセット（preset）という仕組みにより簡便な導入が可能になっています。

そのプリセットは予めいくつか用意されており、その内の1つの textlint-rule-preset-JTF-style_ は `JTF日本語標準スタイルガイド（翻訳用）`_ の一部をルール化したもので、
技術系の文書はこのプリセットで大半がカバーされていると思います。私自身はこのプリセットを包含する形でIIJ用のプリセットを作成しています。

reSTファイルへの適用には textlint-plugin-rst_ というプラグインが必要ですが、
これを導入する事で前述のSphinxを利用したドキュメント作成環境でtextlintの利用が可能になります。
なお、 textlint-plugin-rstは現在のバージョンではPythonの docutils-ast-writer_ というライブラリが必要なので以下のようにインストールしておく必要があります。

.. code-block:: bash

   $ pip install --upgrade docutils-ast-writer
   $ npm install textlint textlint-plugin-rst

また `公開されているルール`_ を使う場合は、以下のようにインストールして利用することができます。

.. code-block:: bash

   $ npm install textlint-rule-max-ten textlint-rule-preset-jtf-style
   $ $(npm bin)/textlint --plugin rst --rule max-ten --preset textlint-rule-preset-jtf-style <reST file>

これをCIツールなどを利用してテストを自動化することで、ソフトウェア開発と同じように継続的なドキュメントの開発をすることができます。

.. seealso::

   このような文字校正ツールはtextlintの他に `RedPen <http://redpen.cc/>`_ というJava製のツールもあります。

   RedPenはtextlintと同様に拡張性が高く、標準で対応するフォーマットがや周辺ツール、サポートするテキストエディタも豊富なので、
   検査内容や動作させる環境などに合わせて使い分けるのが良いと思います。

   Gihyo.jpの連載「 `RedPenを使って技術文書を手軽に校正しよう <http://gihyo.jp/lifestyle/serial/01/redpen>`_ 」で導入方法からRedPenの内部の解説まで非常に詳しく説明されています。


導入効果
--------

textlintは、 `Atom <https://atom.io/>`_ や `GNU Emacs <https://www.gnu.org/software/emacs/>`_ などのテキストエディタと連携し、
文章を書きながらリアルタイムにチェックすることができます。
それにより問題箇所があれば即座にフィードバックが得られるため、使っているうちに正しい文章の書き方が自然と身に付きます。

さらに、CIツールを利用した継続的なテストを行うことで一定の品質を保つことができ、新たなルールを追加していくことでドキュメントを洗練させていくことができます。
追加するルールは `kuromoji.js <https://github.com/takuyaa/kuromoji.js>`_ を使用することで形態素解析を行い、誤字の検出や品詞別のルールなど細かいチェックを実現することもできます。


まとめ
======

今回は、ドキュメントの継続的な開発方法として

- Sphinx_ を使用したドキュメント作成
- textlint_ を使用した文章のチェック
- Github_ と Drone_ や `Travis CI`_ を利用した継続的なテスト

を紹介しました。具体例として、本記事のソースコードを公開していますので参考にしていただければ幸いです。

https://github.com/iij/eng-blog-20160531


参考URL
=======

- `技術文書をソフトウェア開発する話 <https://azu.gitbooks.io/nodefest-technical-writing/content/>`_
- `RedPenを使って技術文書を手軽に校正しよう <http://gihyo.jp/lifestyle/serial/01/redpen>`_

.. URLs

.. _Markdown: http://daringfireball.net/projects/markdown/
.. _`reStructuredText（reST）`: http://docutils.sourceforge.net/rst.html
.. _Git: https://git-scm.com/
.. _Subversion: http://subversion.apache.org/
.. _Sphinx: http://www.sphinx-doc.org/ja/stable/
.. _`Sphinxをはじめよう`: http://sphinx-users.jp/gettingstarted/
.. _Virtualenv: https://virtualenv.pypa.io/en/latest/
.. _Virtualenvwrapper: https://virtualenvwrapper.readthedocs.org/en/latest/
.. _pip: https://pypi.python.org/pypi/pip
.. _`drone.io`: https://drone.io/
.. _`Travis CI`: https://travis-ci.org/
.. _textlint: https://github.com/textlint
.. _`JTF日本語標準スタイルガイド（翻訳用）`: https://www.jtf.jp/jp/style_guide/styleguide_top.html
.. _textlint-rule-preset-JTF-style: https://github.com/azu/textlint-rule-preset-JTF-style
.. _textlint-plugin-rst: https://www.npmjs.com/package/textlint-plugin-rst
.. _docutils-ast-writer: https://pypi.python.org/pypi?name=docutils-ast-writer&version=0.1.0&:action=display
.. _`公開されているルール`: https://github.com/textlint/textlint/wiki/Collection-of-textlint-rule
.. _Github: https://github.com
.. _GitLab: https://gitlab.com
.. _ESLint: http://eslint.org/
.. _Babel: https://babeljs.io/
.. _Trac: https://trac.edgewall.org/
.. _Drone: https://github.com/drone/drone
