.. _man-arrays:

.. currentmodule:: Base

..
    **************************
     Multi-dimensional arrays
    **************************

************
 多次元配列
************

..
    Julia, like most technical computing languages, provides a first-class
    array implementation. Most technical computing languages pay a lot of
    attention to their array implementation at the expense of other
    containers. Julia does not treat arrays in any special way. The array
    library is implemented almost completely in Julia itself, and derives
    its performance from the compiler, just like any other code written in
    Julia. As such, it's also possible to define custom array types by
    inheriting from ``AbstractArray.`` See the :ref:`manual section on the
    AbstractArray interface <man-interfaces-abstractarray>` for more details
    on implementing a custom array type.

他の多くの技術計算用プログラミング言語と同様、Juliaには
第一級オブジェクトとして実装された配列(array)があります。そういった
言語ではたいてい、他のコンテナ型をないがしろにしている場合でも
配列の実装にはかなり気を使っていますが、Juliaでは配列を特別扱いは
しません。配列ライブラリはほぼ完全にJulia自身で実装されており、
他の全てのJuliaのプログラムと同様、コンパイラの機能によって
パフォーマンスが決定します。従って、 ``AbstractArray`` を継承することで
カスタムの配列型を定義することも可能です。
より詳しくは :ref:`AbstractArrayインターフェイスのマニュアル
<man-interfaces-abstractarray>` を参照してください。

..
    An array is a collection of objects stored in a multi-dimensional
    grid.  In the most general case, an array may contain objects of type
    ``Any``.  For most computational purposes, arrays should contain
    objects of a more specific type, such as ``Float64`` or ``Int32``.

配列とは多次元の格子に保持されたオブジェクトのコレクションのことです。
一般化していうと、配列の要素は ``Any`` 型のオブジェクトとなりますが、
ほとんどの計算時には、 ``Float64`` や ``Int32`` といったより具体的な型を
要素として持ちます。

..
    In general, unlike many other technical computing languages, Julia does
    not expect programs to be written in a vectorized style for performance.
    Julia's compiler uses type inference and generates optimized code for
    scalar array indexing, allowing programs to be written in a style that
    is convenient and readable, without sacrificing performance, and using
    less memory at times.

他の多くの技術計算用言語と違い、Juliaではパフォーマンス向上の為に
ベクトル化されたスタイルで表記する必要はありません。Juliaのコンパイラは
型推論を行い、スカラー値配列のインデックス化(slacar array indexing)
をして、最適化されたコードを生成します。このお陰でプログラムは
パフォーマンスやメモリ容量を犠牲にすることなく、より扱いやすく
より読みやすいものとなります。



..
    In Julia, all arguments to functions are passed by reference. Some
    technical computing languages pass arrays by value, and this is
    convenient in many cases. In Julia, modifications made to input arrays
    within a function will be visible in the parent function. The entire
    Julia array library ensures that inputs are not modified by library
    functions. User code, if it needs to exhibit similar behavior, should
    take care to create a copy of inputs that it may modify.

Juliaでは関数への引数は全て参照で渡されます。技術計算用言語の中には
値渡しをするものもあり、こちらの方が便利な場合も多々あります。
Juliaでは関数内で引数として渡された配列への変更は親（呼び出し元）関数内
でも有効になります。Juliaの配列ライブラリ中の関数においては、インプット
された値が変更されることはないと保証されています。ユーザーの書くコード
が似たような挙動を示す必要がある場合には、変更される可能性がある値の
コピーを取ることです。

..
    Arrays
    ======

配列
====

..
    Basic Functions
    ---------------

基本的な関数
------------

..
    ================================  ==============================================================================
    Function                          Description
    ================================  ==============================================================================
    :func:`eltype(A) <eltype>`        the type of the elements contained in ``A``
    :func:`length(A) <length>`        the number of elements in ``A``
    :func:`ndims(A) <ndims>`          the number of dimensions of ``A``
    :func:`size(A) <size>`            a tuple containing the dimensions of ``A``
    :func:`size(A,n) <size>`          the size of ``A`` along a particular dimension
    :func:`indices(A) <indices>`      a tuple containing the valid indices of ``A``
    :func:`indices(A,n) <indices>`    a range expressing the valid indices along dimension ``n``
    :func:`eachindex(A) <eachindex>`  an efficient iterator for visiting each position in ``A``
    :func:`stride(A,k) <stride>`      the stride (linear index distance between adjacent elements) along dimension ``k``
    :func:`strides(A) <strides>`      a tuple of the strides in each dimension
    ================================  ==============================================================================

================================  ==============================================================================
関数                              説明
================================  ==============================================================================
:func:`eltype(A) <eltype>`        ``A`` が保持する要素(element)の型
:func:`length(A) <length>`        ``A`` が保持する要素の数
:func:`ndims(A) <ndims>`          ``A`` の次元数
:func:`size(A) <size>`            ``A`` のそれぞれの次元を保持するタプル
:func:`size(A,n) <size>`          特定の次元における``A``のサイズ
:func:`indices(A) <indices>`      ``A`` の有効なインデックスを持つタプル
:func:`indices(A,n) <indices>`    次元 ``n`` の有効なインデックスの範囲
:func:`eachindex(A) <eachindex>`  ``A`` のそれぞれのポジションを効率的に走査するイテレータ
:func:`stride(A,k) <stride>`      ``A`` の次元 ``k`` におけるストライド（隣り合う要素間の間隔）
:func:`strides(A) <strides>`      それぞれの次元におけるストライドのタプル
================================  ==============================================================================


..
    Construction and Initialization
    -------------------------------

作成と初期化
------------

..
    Many functions for constructing and initializing arrays are provided. In
    the following list of such functions, calls with a ``dims...`` argument
    can either take a single tuple of dimension sizes or a series of
    dimension sizes passed as a variable number of arguments.

配列の作成と初期化を行う関数には様々なものがあります。以下がその
一覧です。引数に ``dims...`` が書いてある関数は次元数を単一のタプルとして
与えても良いし、展開した状態で渡してもかまわないものです。

..
    =================================================== =====================================================================
    Function                                            Description
    =================================================== =====================================================================
    :func:`Array{type}(dims...) <Array>`                an uninitialized dense array
    :func:`zeros(type, dims...) <zeros>`                an array of all zeros of specified type, defaults to ``Float64`` if
                                                        ``type`` not specified
    :func:`zeros(A) <zeros>`                            an array of all zeros of same element type and shape of ``A``
    :func:`ones(type, dims...) <ones>`                  an array of all ones of specified type, defaults to ``Float64`` if
                                                        ``type`` not specified
    :func:`ones(A) <ones>`                              an array of all ones of same element type and shape of ``A``
    :func:`trues(dims...) <trues>`                      a ``Bool`` array with all values ``true``
    :func:`trues(A) <trues>`                            a ``Bool`` array with all values ``true`` and the shape of ``A``
    :func:`falses(dims...) <falses>`                    a ``Bool`` array with all values ``false``
    :func:`falses(A) <falses>`                          a ``Bool`` array with all values ``false`` and the shape of ``A``
    :func:`reshape(A, dims...) <reshape>`               an array with the same data as the given array, but with
                                                        different dimensions.
    :func:`copy(A) <copy>`                              copy ``A``
    :func:`deepcopy(A) <deepcopy>`                      copy ``A``, recursively copying its elements
    :func:`similar(A, element_type, dims...) <similar>` an uninitialized array of the same type as the given array
                                                        (dense, sparse, etc.), but with the specified element type and
                                                        dimensions. The second and third arguments are both optional,
                                                        defaulting to the element type and dimensions of ``A`` if omitted.
    :func:`reinterpret(type, A) <reinterpret>`          an array with the same binary data as the given array, but with the
                                                        specified element type
    :func:`rand(dims) <rand>`                           :obj:`Array` of ``Float64``\ s with random, iid [#iid]_ and uniformly
                                                        distributed values in the half-open interval :math:`[0, 1)`
    :func:`randn(dims) <randn>`                         :obj:`Array` of ``Float64``\ s with random, iid and standard normally
                                                        distributed random values
    :func:`eye(n) <eye>`                                ``n``-by-``n`` identity matrix
    :func:`eye(m, n) <eye>`                             ``m``-by-``n`` identity matrix
    :func:`linspace(start, stop, n) <linspace>`         range of ``n`` linearly spaced elements from ``start`` to ``stop``
    :func:`fill!(A, x) <fill!>`                         fill the array ``A`` with the value ``x``
    :func:`fill(x, dims) <fill>`                        create an array filled with the value ``x``
    =================================================== =====================================================================

=================================================== =====================================================================
関数                                                説明
=================================================== =====================================================================
:func:`Array{type}(dims...) <Array>`                初期化されていない密な配列（密行列）
:func:`zeros(type, dims...) <zeros>`                全ての要素が特定の型のゼロである配列、 ``type`` を指定しない場合、
                                                    デフォルトで ``Float64``
:func:`zeros(A) <zeros>`                            要素の型と個数が ``A`` と同じで、値が全てゼロの配列
:func:`ones(type, dims...) <ones>`                  すべての要素が特定の型の1である配列、 ``type`` を指定しない場合、
                                                    デフォルトで ``Float64``
:func:`ones(A) <ones>`                              要素の型と個数が ``A`` と同じで、値が全て1の配列
:func:`trues(dims...) <trues>`                      ``Bool`` 型の配列。全ての値が ``true``
:func:`trues(A) <trues>`                            ``Bool`` 型の配列。全ての値が ``true`` で ``A`` と同じ形
:func:`falses(dims...) <falses>`                    ``Bool`` 型の配列。全ての値が ``false``
:func:`falses(A) <falses>`                          ``Bool`` 型の配列。全ての値が ``false`` で ``A`` と同じ形
:func:`reshape(A, dims...) <reshape>`               与えられた配列と同じ形の配列。ただし次元数が違う
:func:`copy(A) <copy>`                              ``A`` のコピー
:func:`deepcopy(A) <deepcopy>`                      ``A`` のコピー、要素を再帰的にコピーする
:func:`similar(A, element_type, dims...) <similar>` 配列自体の型(例: 密行列か疎行列か、など)は与えられた配列と同等だが、
                                                    要素の型と次元数が異なる配列。引数の２つ目と３つ目はいずれも任意で
                                                    、省略された場合は ``A`` とおなじになる。
:func:`reinterpret(type, A) <reinterpret>`          あたえられた配列と同じバイト列を要素として持つ配列、ただしそのバイト
                                                    列を ``type`` として解釈する
:func:`rand(dims) <rand>`                           ``Float64`` の :obj:`Array` 、ただしその要素は半開区間 :math:`[0, 1)`
                                                    の iid [#iid]_ からサンプリングしたランダムな値
:func:`randn(dims) <randn>`                         ``Float64`` の :obj:`Array` 、ただしその要素はiid準拠の標準正規分布
                                                    空のサンプリングしたランダムな値
:func:`eye(n) <eye>`                                ``n``-by-``n`` の単位行列
:func:`eye(m, n) <eye>`                             ``m``-by-``n`` の単位行列
:func:`linspace(start, stop, n) <linspace>`         ``start`` から ``stop`` まで等間隔で区切られた ``n`` 個の要素を持つ配列
:func:`fill!(A, x) <fill!>`                         全ての要素に ``x`` を持つ ``A``
:func:`fill(x, dims) <fill>`                        全ての要素に ``x`` を持つ配列を新規に作成
=================================================== =====================================================================

.. [#iid] *iid*, 独立同一分布

..
    ``[A, B, C, ...]`` constructs a 1-d array (vector) of its arguments.

``[A, B, C, ...]`` というシンタックスで与えられた値を要素にもつ1次元配列を作成します

..
    Concatenation
    -------------


配列の結合
----------

..
    Arrays can be constructed and also concatenated using the following
    functions:

以下の関数で配列の作成、結合を行うことができます。

..
    =========================== ======================================================
    Function                    Description
    =========================== ======================================================
    :func:`cat(k, A...) <cat>`  concatenate input n-d arrays along the dimension ``k``
    :func:`vcat(A...) <vcat>`   shorthand for ``cat(1, A...)``
    :func:`hcat(A...) <hcat>`   shorthand for ``cat(2, A...)``
    =========================== ======================================================

=========================== ======================================================
関数                        説明
=========================== ======================================================
:func:`cat(k, A...) <cat>`  あたえられたn次元配列を ``k`` 次元方向に結合する
:func:`vcat(A...) <vcat>`   ``cat(1, A...)`` のエイリアス
:func:`hcat(A...) <hcat>`   ``cat(2, A...)`` のエイリアス
=========================== ======================================================

..
    Scalar values passed to these functions are treated as 1-element arrays.

これらの関数にスカラーをあたえると、１要素の配列として扱われます。

..
    The concatenation functions are used so often that they have special syntax:

結合関数は頻繁に用いられるため、特別なシンタックスがあります。

..
    =================== =============
    Expression          Calls
    =================== =============
    ``[A; B; C; ...]``  :func:`vcat`
    ``[A B C ...]``     :func:`hcat`
    ``[A B; C D; ...]`` :func:`hvcat`
    =================== =============

=================== =================
表記法              呼び出される関数
=================== =================
``[A; B; C; ...]``  :func:`vcat`
``[A B C ...]``     :func:`hcat`
``[A B; C D; ...]`` :func:`hvcat`
=================== =================

..
    :func:`hvcat` concatenates in both dimension 1 (with semicolons) and dimension 2
    (with spaces).

:func:`hvcat` は一次元方向(セミコロン)と2次元方向(空白)の両方に結合します。

..
    Typed array initializers
    ------------------------

型アノテーション付きでの配列初期化
----------------------------------

..
    An array with a specific element type can be constructed using the syntax
    ``T[A, B, C, ...]``. This will construct a 1-d array with element type
    ``T``, initialized to contain elements ``A``, ``B``, ``C``, etc.
    For example ``Any[x, y, z]`` constructs a heterogeneous array that can
    contain any values.

``T[A, B, C]`` というシンタックスで配列の要素の型を指定して初期化をする
ことができます。この場合は ``T`` という型の値を要素にもつ1次元配列です。
要素の値は ``A``, ``B``, ``C`` 等です。
例えば ``Any[x, y, z]`` はいかなる型の値でも要素に持つことができる配列
となります。

..
    Concatenation syntax can similarly be prefixed with a type to specify
    the element type of the result.

結合時のシンタックスにおいても、同様に型指定を行うことができます。

.. doctest::

    julia> [[1 2] [3 4]]
    1×4 Array{Int64,2}:
     1  2  3  4

    julia> Int8[[1 2] [3 4]]
    1×4 Array{Int8,2}:
     1  2  3  4

.. _comprehensions:

..
    Comprehensions
    --------------

内包表記
---------

..
    Comprehensions provide a general and powerful way to construct arrays.
    Comprehension syntax is similar to set construction notation in
    mathematics::

内包表記は配列を作るための強力で汎用的な方法です。
数学における集合の定義に表記法が似ています。::

    A = [ F(x,y,...) for x=rx, y=ry, ... ]

..
    The meaning of this form is that ``F(x,y,...)`` is evaluated with the
    variables ``x``, ``y``, etc. taking on each value in their given list of
    values. Values can be specified as any iterable object, but will
    commonly be ranges like ``1:n`` or ``2:(n-1)``, or explicit arrays of
    values like ``[1.2, 3.4, 5.7]``. The result is an N-d dense array with
    dimensions that are the concatenation of the dimensions of the variable
    ranges ``rx``, ``ry``, etc. and each ``F(x,y,...)`` evaluation returns a
    scalar.

これは、「 ``F(x, y,...)`` という関数に ``x``, ``y``, etc が与えられた際の
返り値」を要素として持つ配列になります。ただし、 ``x``, ``y`` はそれぞれ
``rx``, ``ry`` というiterableの値を一つずつ抜き出したものです。
多くの場合これには ``1:n`` や ``2:(n-1)`` といった範囲表記や
``[1.2, 3.4, 5.7]`` のような配列が用いられます。
結果として返されるN次元配列は ``rx`` や ``ry`` の次元数と要素数に応じた
形になり、それぞれの要素 ``F(x, y,...)`` はスカラーになります。

..
    The following example computes a weighted average of the current element
    and its left and right neighbor along a 1-d grid. :

以下の例では、一次元の格子中で隣あう3要素間の重み付き平均を計算しています。 :

.. testsetup:: *

    srand(314);

.. doctest:: array-rand

    julia> x = rand(8)
    8-element Array{Float64,1}:
     0.843025
     0.869052
     0.365105
     0.699456
     0.977653
     0.994953
     0.41084
     0.809411

    julia> [ 0.25*x[i-1] + 0.5*x[i] + 0.25*x[i+1] for i=2:length(x)-1 ]
    6-element Array{Float64,1}:
     0.736559
     0.57468
     0.685417
     0.912429
     0.8446
     0.656511

..
    The resulting array type depends on the types of the computed elements.
    In order to control the type explicitly, a type can be prepended to the comprehension.
    For example, we could have requested the result in single precision by writing::

返り値の配列の要素の型は計算結果に依存します。型を明示したい場合は、
内包表記の頭に型を指定することができます。例えば返り値を単精度浮動小数点
にするよう指定する場合は以下のようになります::

    Float32[ 0.25*x[i-1] + 0.5*x[i] + 0.25*x[i+1] for i=2:length(x)-1 ]

.. _man-generator-expressions:

..
    Generator Expressions
    ---------------------

ジェネレータ表記
----------------

..
    Comprehensions can also be written without the enclosing square brackets, producing
    an object known as a generator. This object can be iterated to produce values on
    demand, instead of allocating an array and storing them in advance
    (see :ref:`man-interfaces-iteration`).
    For example, the following expression sums a series without allocating memory:

内包表記には、必ずしも角括弧を用いる必要はありません。その場合、返り値はジェネレータ
と呼ばれるオブジェクトになります。このオブジェクトは、あらかじめ配列を作成してそこに
値を持つのではなく、必要に応じてイテレートすることで値を生成します。
（ :ref:`man-interfaces-iteration` を参照）例えば以下はメモリへのアロケート無しで値
の合計をとります。

.. doctest::

    julia> sum(1/n^2 for n=1:1000)
    1.6439345666815615

..
    When writing a generator expression with multiple dimensions inside an argument
    list, parentheses are needed to separate the generator from subsequent arguments::

複数のiterableを持つジェネレータを、別の関数の引数として与える場合、後続の
引数と区別するためにジェネレータを括弧で囲む必要があります。::

    julia> map(tuple, 1/(i+j) for i=1:2, j=1:2, [1:4;])
    ERROR: syntax: invalid iteration specification

..
    All comma-separated expressions after ``for`` are interpreted as ranges. Adding
    parentheses lets us add a third argument to ``map``:

上では ``for`` に続くカンマ区切りの表記がすべて範囲として扱われています。ここに
括弧を追加することで、3つ目の引数をジェネレータとは独立に ``map`` に渡しましょう

.. doctest::

    julia> map(tuple, (1/(i+j) for i=1:2, j=1:2), [1 3; 2 4])
    2×2 Array{Tuple{Float64,Int64},2}:
     (0.5,1)       (0.333333,3)
     (0.333333,2)  (0.25,4)

..
    Ranges in generators and comprehensions can depend on previous ranges by writing
    multiple ``for`` keywords:

内包表記中で ``for`` を複数回書いた場合、直前の範囲の値に依存するような範囲を
書くことができます。

.. doctest::

    julia> [(i,j) for i=1:3 for j=1:i]
    6-element Array{Tuple{Int64,Int64},1}:
     (1,1)
     (2,1)
     (2,2)
     (3,1)
     (3,2)
     (3,3)

..
    In such cases, the result is always 1-d.

そのような場合、結果は必ず１次元になります。

..
    Generated values can be filtered using the ``if`` keyword:

生成された値は ``if`` 文でフィルタリングすることができます。

.. doctest::

    julia> [(i,j) for i=1:3 for j=1:i if i+j == 4]
    2-element Array{Tuple{Int64,Int64},1}:
     (2,2)
     (3,1)

.. _man-array-indexing:

..
    Indexing
    --------

インデックス記法
----------------

..
    The general syntax for indexing into an n-dimensional array A is::

N次元配列Aをインデックスによってスライスする場合の基本的な記法は
以下のようになります。::

    X = A[I_1, I_2, ..., I_n]

.. where each ``I_k`` may be:

個々の ``I_k`` は以下のうちのいずれかです。

..
    1. A scalar integer
    2. A ``Range`` of the form ``a:b``, or ``a:b:c``
    3. A ``:`` or ``Colon()`` to select entire dimensions
    4. An arbitrary integer array, including the empty array ``[]``
    5. A boolean array to select a vector of elements at its ``true`` indices

1. 整数のスカラー
2. ``a:b`` または ``a:b:c`` で表される `Range`
3. 次元全体を選択する ``:`` あるいは ``Colon()``
4. 任意の整数を要素にもつ配列。空の配列（``[]``）も可
5. ブール値の配列。 ``true`` の部分に一致するベクトルを抜き出す

..
    If all the indices are scalars, then the result ``X`` is a single element from
    the array ``A``. Otherwise, ``X`` is an array with the same number of
    dimensions as the sum of the dimensionalities of all the indices.

全てのインデックスがスカラー値の場合、結果として生じる ``X`` は 配列 ``A``
からの単一の要素となります。それ以外の場合はすべて、インデックスとして
与えられた要素の合計と同じ次元数の配列となります。

..
    If all indices are vectors, for example, then the shape of ``X`` would be
    ``(length(I_1), length(I_2), ..., length(I_n))``, with location
    ``(i_1, i_2, ..., i_n)`` of ``X`` containing the value
    ``A[I_1[i_1], I_2[i_2], ..., I_n[i_n]]``. If ``I_1`` is changed to a
    two-dimensional matrix, then ``X`` becomes an ``n+1``-dimensional array of
    shape ``(size(I_1, 1), size(I_1, 2), length(I_2), ..., length(I_n))``. The
    matrix adds a dimension. The location ``(i_1, i_2, i_3, ..., i_{n+1})`` contains
    the value at ``A[I_1[i_1, i_2], I_2[i_3], ..., I_n[i_{n+1}]]``. All dimensions
    indexed with scalars are dropped. For example, the result of ``A[2, I, 3]`` is
    an array with size ``size(I)``. Its ``i``\ th element is populated by
    ``A[2, I[i], 3]``.

例えばもし全てのインデックスがベクトルならば、 ``X`` の形は
``(length(I_1), length(I_2), ..., length(I_n))`` となり、
``(length(I_1), length(I_2), ..., length(I_n))`` の部分の値には
``A[I_1[i_1], I_2[i_2], ..., I_n[i_n]]`` のそれぞれがはいります。もし ``I_1``
が2次元の行列になったとしたら、 ``X`` は
``(size(I_1, 1), size(I_1, 2), length(I_2), ..., length(I_n))`` という形の
``n+1`` 次元の配列となります。
つまり行列の次元が一つ増え ``(i_1, i_2, i_3, ..., i_{n+1})`` のそれぞれの位置には
``A[I_1[i_1, i_2], I_2[i_3], ..., I_n[i_{n+1}]]`` が入るということです。
スカラーでインデックスをとられた次元はすべてドロップされます。例えば
``A[2, I, 3]`` の結果の配列は ``size(I)`` でその ``i`` 番目の要素は
``A[2, I[i], 3]`` となります。

..
    Indexing by a boolean array ``B`` is effectively the same as indexing by the
    vector that is returned by :func:`find(B) <find>`. Often referred to as logical
    indexing, this selects elements at the indices where the values are ``true``,
    akin to a mask. A logical index must be a vector of the same length as the
    dimension it indexes into, or it must be the only index provided and match the
    size and dimensionality of the array it indexes into. It is generally more
    efficient to use boolean arrays as indices directly instead of first calling
    :func:`find`.

ブール値の配列（ここでは ``B`` とします）によってインデックスをとると、
:func:`find(B)` の返すベクトルでインデックスをとった場合と同様の結果が
得られます。 これは論理値インデックス(logical indexing)と呼ばれ、 ``true``
を要素にもつ部分のスライスが返るので、値の一部をマスクするような効果
が得られます。論理値インデックスに用いられるベクトルは対象となる配列の次元数
と同長の配列でなくてはなりません。 一般的に :func:`find` をはじめに呼ぶよりも
直接ブール値の配列でスライスした方が高速です。

..
    Additionally, single elements of a multidimensional array can be indexed as
    ``x = A[I]``, where ``I`` is a ``CartesianIndex``. It effectively behaves like
    an ``n``-tuple of integers spanning multiple dimensions of ``A``. See
    :ref:`man-array-iteration` below.

さらに、多次元配列中の単一の要素は ``x = A[I]`` で値をとることができます。
ここで ``I`` は直行座標系インデックス( ``CartesianIndex`` )と呼ばれます。
``A`` の複数次元にまたがった ``n`` 要素の整数のタプルのようにふるまうためです。
より詳しくは以下の :ref:`man-array-iteration` を参照してください。

..
    As a special part of this syntax, the ``end`` keyword may be used to represent
    the last index of each dimension within the indexing brackets, as determined by
    the size of the innermost array being indexed. Indexing syntax without the
    ``end`` keyword is equivalent to a call to ``getindex``::

このシンタックスの特別な例として、キーワードインデックスの角括弧中で ``end``
キーワードで角括弧内の各次元の一番最後の要素を参照できる。という機能があります。
これはインデックスをとられる配列の最も内側の配列によって決定されます。
``end`` を用いない場合は ``getindex`` で同等のことを行えます。::

    X = getindex(A, I_1, I_2, ..., I_n)

例:

.. doctest::

    julia> x = reshape(1:16, 4, 4)
    4×4 Base.ReshapedArray{Int64,2,UnitRange{Int64},Tuple{}}:
     1  5   9  13
     2  6  10  14
     3  7  11  15
     4  8  12  16

    julia> x[2:3, 2:end-1]
    2×2 Array{Int64,2}:
     6  10
     7  11

    julia> x[map(ispow2, x)]
    5-element Array{Int64,1}:
      1
      2
      4
      8
     16

    julia> x[1, [2 3; 4 1]]
    2×2 Array{Int64,2}:
      5  9
     13  1

..
    Empty ranges of the form ``n:n-1`` are sometimes used to indicate the inter-index
    location between ``n-1`` and ``n``.  For example, the :func:`searchsorted` function uses
    this convention to indicate the insertion point of a value not found in a sorted
    array:

インデックスとインデックスの間の隙間を指示するために、 ``n:n-1`` のような空の範囲
（ ``n-1`` と ``n`` の間）を指定することがあります。例えば、 :func:`searchsorted` 関数
では、ソート済みの配列の中に、新規の値を挿入する際の挿入点を表すのにこの記法を用いています。

.. doctest::

    julia> a = [1,2,5,6,7];

    julia> searchsorted(a, 3)
    3:2

..
    Assignment
    ----------

値の代入
---------
..
    The general syntax for assigning values in an n-dimensional array A is::

N次元配列Aに値を代入する際の一般的な記法は以下です::

    A[I_1, I_2, ..., I_n] = X

..
    where each ``I_k`` may be:

それぞれの ``I_k`` が取りうる値は以下です。

..
    1. A scalar integer
    2. A ``Range`` of the form ``a:b``, or ``a:b:c``
    3. A ``:`` or ``Colon()`` to select entire dimensions
    4. An arbitrary integer array, including the empty array ``[]``
    5. A boolean array to select elements at its ``true`` indices

1. 整数のスカラー値
2. ``a:b``, ``a:b:c`` といった ``Range``
3. 次元全体を選択する際の ``:``, ``Colon()``
4. 任意の整数の配列、空の配列 ``[]`` を含む
5. ブール値の配列。 ``true`` の部分に一致するベクトルを抜き出す

..
    If ``X`` is an array, it must have the same number of elements as the product
    of the lengths of the indices:
    ``prod(length(I_1), length(I_2), ..., length(I_n))``. The value in location
    ``I_1[i_1], I_2[i_2], ..., I_n[i_n]`` of ``A`` is overwritten with the value
    ``X[i_1, i_2, ..., i_n]``. If ``X`` is not an array, its value
    is written to all referenced locations of ``A``.

もし ``X`` が配列ならば、その要素の数は左辺の配列インデックスの直積
``prod(length(I_1), length(I_2), ..., length(I_n))`` と同じでなくては
なりません。 ``A`` の ``I_1[i_1], I_2[i_2], ..., I_n[i_n]`` における値は
``X[i_1, i_2, ..., i_n]`` に置き換えられます。 ``X`` が配列でなければ、
``A`` のインデックスで指定された部分の値は全て ``X`` の値で置き換えられます。

..
    A boolean array used as an index behaves as in :func:`getindex`, behaving as
    though it is first transformed with :func:`find`.

ブール値の配列をインデックスとして用いた場合、 :func:`getindex` を用いた場合と
同様の挙動を示します。初めに :func:`find` で変換した場合も同様です。

..
    Index assignment syntax is equivalent to a call to :func:`setindex!`::

左辺にインデックスを用いた変数の代入は、 :func:`setindex!` 関数によっても
可能です。::

      setindex!(A, X, I_1, I_2, ..., I_n)

例:

.. doctest::

    julia> x = collect(reshape(1:9, 3, 3))
    3×3 Array{Int64,2}:
     1  4  7
     2  5  8
     3  6  9

    julia> x[1:2, 2:3] = -1
    -1

    julia> x
    3×3 Array{Int64,2}:
     1  -1  -1
     2  -1  -1
     3   6   9

.. _man-array-iteration:

..
    Iteration
    ---------

イテレーション
--------------

..
    The recommended ways to iterate over a whole array are
    ::

配列の要素に対してイテレートしたい場合は、以下のやり方が推奨されています。
::

    for a in A
        # 要素 a を用いて何かを行う
    end

    for i in eachindex(A)
        # インデックス i を用いて何かを行う。加えて、 A[i] で要素を参照してもよい
    end

..
    The first construct is used when you need the value, but not index, of each element.  In the second construct, ``i`` will be an ``Int`` if ``A`` is an array
    type with fast linear indexing; otherwise, it will be a ``CartesianIndex``::

一つ目の構文は、要素の値のみが必要でインデックスは必要ない場合に用います。
二つ目の構文においては、 ``A`` が 高速線形インデックス(fast linear indexing)可能な
配列の場合 ``i`` は ``Int`` 型になり、そうでなければ ``CartesianIndex`` になります。::

    A = rand(4,3)
    B = view(A, 1:3, 2:3)
    julia> for i in eachindex(B)
               @show i
           end
           i = Base.IteratorsMD.CartesianIndex_2(1,1)
           i = Base.IteratorsMD.CartesianIndex_2(2,1)
           i = Base.IteratorsMD.CartesianIndex_2(3,1)
           i = Base.IteratorsMD.CartesianIndex_2(1,2)
           i = Base.IteratorsMD.CartesianIndex_2(2,2)
           i = Base.IteratorsMD.CartesianIndex_2(3,2)

..
    In contrast with ``for i = 1:length(A)``, iterating with ``eachindex`` provides an efficient way to iterate over any array type.

``eachindex`` を用いると ``for i = i:length(A)`` の場合に比べて
どのような配列に対しても高速に要素をイテレートすることができます。

..
    Array traits
    ------------

配列のトレイト
--------------
..
    If you write a custom :obj:`AbstractArray` type, you can specify that it has fast linear indexing using
    ::

:obj:`AbstractArray` を継承したカスタム型を自分で定義した場合、
以下のようにして高速線形インデックスをサポートすることを明示できます。::


    Base.linearindexing{T<:MyArray}(::Type{T}) = LinearFast()

..
    This setting will cause ``eachindex`` iteration over a ``MyArray`` to use integers.  If you don't specify this trait, the default value ``LinearSlow()`` is used.

これにより ``MyArray`` に対して ``eachindex`` を呼び出した際のインデックス
として整数が用いられます。さもなくばデフォルトの ``LinearSlow()`` が用いられます。

..
    Vectorized Operators and Functions
    ----------------------------------

ベクトル演算子と関数
--------------------

..
    The following operators are supported for arrays. The dot version of a binary
    operator should be used for elementwise operations.

配列に対して以下の演算子を使用することができます。二項演算子にドッ
トがつくと、要素ごとに作用する効果を持つようになります。

..
    1.  Unary arithmetic — ``-``, ``+``, ``!``
    2.  Binary arithmetic — ``+``, ``-``, ``*``, ``.*``, ``/``, ``./``,
        ``\``, ``.\``, ``^``, ``.^``, ``div``, ``mod``
    3.  Comparison — ``.==``, ``.!=``, ``.<``, ``.<=``, ``.>``, ``.>=``
    4.  Unary Boolean or bitwise — ``~``
    5.  Binary Boolean or bitwise — ``&``, ``|``, ``$``

1.  単項演算子 — ``-``, ``+``, ``!``
2.  二項演算子 — ``+``, ``-``, ``*``, ``.*``, ``/``, ``./``,
    ``\``, ``.\``, ``^``, ``.^``, ``div``, ``mod``
3.  比較演算子 — ``.==``, ``.!=``, ``.<``, ``.<=``, ``.>``, ``.>=``
4.  単項ブーリアン（ビットワイズ）演算子 — ``~``
5.  二項ブーリアン（ビットワイズ） — ``&``, ``|``, ``$``

..
    Some operators without dots operate elementwise anyway when one argument is a
    scalar. These operators are ``*``, ``+``, ``-``, and the bitwise operators. The
    operators ``/`` and ``\`` operate elementwise when the denominator is a scalar.

いくつかの演算子は、引数の値の一方がスカラーだった場合、ドット演算子でなくとも
要素ごとに適用されます。その演算子とは ``*``, ``+``, ``-`` ,そして
ビットワイズ演算子です。 ``/`` と ``\`` は分母がスカラーの場合に要素ごとに
適用されます。

..
    Note that comparisons such as ``==`` operate on whole arrays, giving a single
    boolean answer. Use dot operators for elementwise comparisons.

``==`` 演算子は全配列を丸ごと比較し、単一のブール値を返すことに注意
してください。要素ごとに比較したい際はドット演算子（ ``.==`` ）です。

..
    To enable convenient vectorization of mathematical and other operations, Julia provides
    the compact syntax ``f.(args...)``, e.g. ``sin.(x)`` or ``min.(x,y)``, for elementwise
    operations over arrays or mixtures of arrays and scalars (a :func:`broadcast` operation).
    See :ref:`man-dot-vectorizing`.

数学的な演算やその他の処理のベクトル化を簡単に行うため、 Juliaは ``f.(args...)``
というコンパクトな構文を提供しています。例えば ``sin.(s)`` や ``min.(x,y)`` 等です。
これにより配列、あるいは配列とスカラーを一緒にしたものに対して、要素ごとの演算を高速
に行えます（これを :func:`broadcast` 演算と言います）詳しくは :ref:`man-dot-vectorizing`
を参照してください。

..
    Note that there is a difference between ``max.(a,b)``, which ``broadcast``\ s :func:`max`
    elementwise over ``a`` and ``b``, and ``maximum(a)``, which finds the largest value within
    ``a``. The same statements hold for ``min.(a,b)`` and ``minimum(a)``.

以下の二つの違いに注意してください

1. ``max.(a,b)``  — :func:`max` を ``a`` と ``b`` の全ての要素に ``broadcast`` する
2. ``maximum(a)`` — ``a`` のうちの最大の要素を返す。

同様のことは ``min.(a,b)`` と ``minimum(a)`` にも言えます。

.. _man-broadcasting:

..
    Broadcasting
    ------------

ブロードキャスト
----------------

..
    It is sometimes useful to perform element-by-element binary operations
    on arrays of different sizes, such as adding a vector to each column
    of a matrix.  An inefficient way to do this would be to replicate the
    vector to the size of the matrix:

例えば行列の各列に対してベクトルを足すなど、異なるサイズの配列同士で、
要素対要素の二項演算をしたくなることがあります。効率の悪いやり方として、
ベクトルを必要な分だけ複製してから足す。という方法があります。

.. doctest::

    julia> a = rand(2,1); A = rand(2,3);

    julia> repmat(a,1,3)+A
    2×3 Array{Float64,2}:
     1.20813  1.82068  1.25387
     1.56851  1.86401  1.67846

..
    This is wasteful when dimensions get large, so Julia offers
    :func:`broadcast`, which expands singleton dimensions in
    array arguments to match the corresponding dimension in the other
    array without using extra memory, and applies the given
    function elementwise:

このやり方だと次元数が大きいほど無駄が大きくなるため、Juliaには
:func:`broadcast` という関数が用意されています。これは余分なメモリ
を消費することなく、片方の配列の次元をもう片方に合うように拡張した
のち、あたえられた関数を要素ごとに適用していきます。

.. doctest::

    julia> broadcast(+, a, A)
    2×3 Array{Float64,2}:
     1.20813  1.82068  1.25387
     1.56851  1.86401  1.67846

    julia> b = rand(1,2)
    1×2 Array{Float64,2}:
     0.867535  0.00457906

    julia> broadcast(+, a, b)
    2×2 Array{Float64,2}:
     1.71056  0.847604
     1.73659  0.873631

..
    Elementwise operators such as ``.+`` and ``.*`` perform broadcasting if necessary. There is also a :func:`broadcast!` function to specify an explicit destination, and :func:`broadcast_getindex` and :func:`broadcast_setindex!` that broadcast the indices before indexing.   Moreover, ``f.(args...)`` is equivalent to ``broadcast(f, args...)``, providing a convenient syntax to broadcast any function (:ref:`man-dot-vectorizing`).

``.+`` や ``.*`` といった要素ごとに適用される演算子の場合、必要に応じて
自動でブロードキャストを実行します。また、 :func:`broadcast!` で適用先を明示
することも可能です。また :func:`broadcast_setindex!` と :func:`broadcast_getindex`
を用いてインデックスをとる前に、インデックスをブロードキャストすることも可能です。
さらに補足すると、 ``f.(args...)`` と ``broadcast(f, args...)`` は互いに同等なので、
前者の書き方をした方がより簡便になります。 詳しくは :ref:`man-dot-vectorizing`
を参照してください。

..
    Additionally, :func:`broadcast` is not limited to arrays (see the function documentation), it also handles tuples and treats any argument that is not an array or a tuple as a "scalar".

さらに付け加えると、 :func:`broadcast` は配列以外にタプルにも適用可能です。
（関数のドキュメントを参照してください）配列でもタプルでもない引数を与えられると
スカラーとして扱います。

.. doctest::

    julia> convert.(Float32, [1, 2])
    2-element Array{Float32,1}:
     1.0
     2.0

    julia> ceil.((UInt8,), [1.2 3.4; 5.6 6.7])
    2×2 Array{UInt8,2}:
     0x02  0x04
     0x06  0x07

    julia> string.(1:3, ". ", ["First", "Second", "Third"])
    3-element Array{String,1}:
     "1. First"
     "2. Second"
     "3. Third"


..
    Implementation
    --------------

配列の実装
----------

..
    The base array type in Julia is the abstract type
    ``AbstractArray{T,N}``. It is parametrized by the number of dimensions
    ``N`` and the element type ``T``. :obj:`AbstractVector` and
    :obj:`AbstractMatrix` are aliases for the 1-d and 2-d cases. Operations on
    :obj:`AbstractArray` objects are defined using higher level operators and
    functions, in a way that is independent of the underlying storage.
    These operations generally work correctly as a fallback for any
    specific array implementation.

Juliaにおける配列の基本型は ``AbstractArray{T,N}`` という抽象型です。
次元数 ``N`` と、要素の型 ``T`` がそのパラメータです。
1次元、2次元の場合はそれぞれ ``AbstractVector``, ``AbstractMatrix``
がエイリアスとして使用できます。 :obj:`AbstractArray` への操作は
より高位の演算子(higher level operator)と関数で定義されており、
実際に値がどのように保持されているかとは無関係です。
これらの演算子（あるいはメソッド）は、個々の配列の具象型への操作が
失敗した際のコールバック処理として呼び出されます。

..
    The :obj:`AbstractArray` type includes anything vaguely array-like, and
    implementations of it might be quite different from conventional
    arrays. For example, elements might be computed on request rather than
    stored.  However, any concrete ``AbstractArray{T,N}`` type should
    generally implement at least :func:`size(A) <size>` (returning an ``Int`` tuple),
    :func:`getindex(A,i) <getindex>` and :func:`getindex(A,i1,...,iN) <getindex>`;
    mutable arrays should also implement :func:`setindex!`.  It
    is recommended that these operations have nearly constant time complexity,
    or technically Õ(1) complexity, as otherwise some array functions may
    be unexpectedly slow.   Concrete types should also typically provide
    a :func:`similar(A,T=eltype(A),dims=size(A)) <similar>` method, which is used to allocate
    a similar array for :func:`copy` and other out-of-place operations.
    No matter how an ``AbstractArray{T,N}`` is represented internally,
    ``T`` is the type of object returned by *integer* indexing (``A[1,
    ..., 1]``, when ``A`` is not empty) and ``N`` should be the length of
    the tuple returned by :func:`size`.

ほんの少しでも配列のようなところのあるオブジェクトならば、例え実装が典型的な
配列からかけ離れていたとしても大抵は :obj:`AbstractArray` を継承しています。
例えば、要素がメモリに保持されるのではなく、リクエストに応じて呼び出される
ような場合です（訳注: イテレータのこと）。しかし、 ``AbstractArray{T,N}`` の
具象型は必ず、最低でも以下の関数を実装していなくてはなりません。

* :func:`size(A) <size>` これは ``Int`` のタプルを返します。
* :func:`getindex(A,i) <getindex>`
* :func:`getindex(A,i1,...,iN) <getindex>`

更にミュータブルな配列の場合

* :func:`setindex!`

も実装している必要があります。
これらの関数はおおよそ定数時間、つまり Õ(1) の時間計算量で動作することが
推奨されています。さもないと、配列を扱う関数のうちのいくつかが予想外に遅く
なるためです。具象型の場合、上記に加えて

* :func:`similar(A,T=eltype(A),dims(A)) <similar>`

を実装しているのが普通です。これは例えば :func:`copy` や値渡しをする操作
を適用した際に、元の配列とほぼ同一の配列を作成するのに使われます。
``AbstractArray{T,N}`` を継承した型ならば、実際の実装がどうであろうと必ず
以下の規則を満たす必要があります。

1. 空でない配列 ``A`` に対して **整数の** インデックスで値を取る（ ``A[1, ..., 1]`` ）と型 ``T`` の値が返る。
2. :func:`size` を適用すると長さ ``N`` のタプルが返る。

..
    :obj:`DenseArray` is an abstract subtype of :obj:`AbstractArray` intended
    to include all arrays that are laid out at regular offsets in memory,
    and which can therefore be passed to external C and Fortran functions
    expecting this memory layout.  Subtypes should provide a method
    :func:`stride(A,k) <stride>` that returns the "stride" of dimension ``k``:
    increasing the index of dimension ``k`` by ``1`` should increase the
    index ``i`` of :func:`getindex(A,i) <getindex>` by :func:`stride(A,k) <stride>`.  If a
    pointer conversion method :func:`Base.unsafe_convert(Ptr{T}, A) <unsafe_convert>` is provided, the
    memory layout should correspond in the same way to these strides.

:obj:`DenseArray` は :obj:`AbstractArray` を継承した抽象型です。これは、
値をCやFortranの関数に渡すため、メモリ上でのオフセットが等間隔になるような
配列を表す型です。この型のサブタイプは :func:`stride(A,k) <stride>` を
実装していなくてはならず、これは次元 ``k`` におけるストライド
（隣り合う要素間の距離）を返します。次元 ``k`` のインデックスを ``1``
増やすごとに、 :func:`getindex(A,i) <getindex>` によって返される
``i`` の値は :func:`stride(A,k) <stride>` ずつ増えていきます。
ポインタ変換関数 :func:`Base.unsafe_convert(Ptrf{T}, A) <unsafe_convert>`
が呼び出された場合、上に示したストライドに関する規則と挙動が一致している
必要があります。


..
    The :obj:`Array` type is a specific instance of :obj:`DenseArray`
    where elements are stored in column-major order (see additional notes in
    :ref:`man-performance-tips`). :obj:`Vector` and :obj:`Matrix` are aliases for
    the 1-d and 2-d cases. Specific operations such as scalar indexing,
    assignment, and a few other basic storage-specific operations are all
    that have to be implemented for :obj:`Array`, so that the rest of the array
    library can be implemented in a generic manner.

:obj:`Array` は :obj:`DenseArray` を継承した具象型で、値は列指向で
保持されます。（詳しくは :ref:`man-performance-tips` を参照してください）
:obj:`Vector` と :obj:`Matrix` はそれぞれ１次元と２次元の場合のエイリアスです。
スカラーでインデックスを取る、値を代入するなどの要素の型に依存する処理は
全て :obj:`Array` に対して実装しなくてはなりません。ですので、配列ライブラリ
のその他の処理はジェネリックに実装するだけで十分です。

..
    :obj:`SubArray` is a specialization of :obj:`AbstractArray` that performs
    indexing by reference rather than by copying. A :obj:`SubArray` is created
    with the :func:`view` function, which is called the same way as :func:`getindex`
    (with an array and a series of index arguments). The result of :func:`view` looks
    the same as the result of :func:`getindex`, except the data is left in place.
    :func:`view` stores the input index vectors in a :obj:`SubArray` object, which
    can later be used to index the original array indirectly.

:obj:`SubArray` は :obj:`AbstractArray` を継承した型で、インデックスを
用いて値を読み書きする際にコピーせず参照を用いる点が特徴的です。
:obj:`SubArray` は :func:`getindex` と同じ使い方（ただし引数に配列や
インデックスの集合を与えたとき）をする :func:`view` 関数によって
作成されます。 :func:`view` の返り値は :func:`getindex` の場合と同じに
見えますが、値のコピーではなく、もとの値の参照を保持している点に違いがあります。
これを後から用いることで、元の配列を間接的に変更することができます。

..
    :obj:`StridedVector` and :obj:`StridedMatrix` are convenient aliases defined
    to make it possible for Julia to call a wider range of BLAS and LAPACK
    functions by passing them either :obj:`Array` or :obj:`SubArray` objects, and
    thus saving inefficiencies from memory allocation and copying.

:obj:`StriedVector` と :obj:`StrideMatrix` は BLAS や LAPACK に、
:obj:`Array` 、:obj:`SubArray` をより簡単に渡すことで多様な関数を
呼び出すのを便利にするエイリアスです。 メモリアロケーションや値のコピー
によって生じるパフォーマンスの低下を防いでくれます。


..
    The following example computes the QR decomposition of a small section
    of a larger array, without creating any temporaries, and by calling the
    appropriate LAPACK function with the right leading dimension size and
    stride parameters.

以下に、巨大な配列のごく一部のみをQR分解する例を示します。
一時データを作成することなく、適切なLAPACKの関数を適切な Leading dimension
（訳注: 配列の第一次元の要素数）とストライドパラメータで呼び出しています。

.. doctest::

    julia> a = rand(10,10)
    10×10 Array{Float64,2}:
     0.561255   0.226678   0.203391  0.308912   …  0.750307  0.235023   0.217964
     0.718915   0.537192   0.556946  0.996234      0.666232  0.509423   0.660788
     0.493501   0.0565622  0.118392  0.493498      0.262048  0.940693   0.252965
     0.0470779  0.736979   0.264822  0.228787      0.161441  0.897023   0.567641
     0.343935   0.32327    0.795673  0.452242      0.468819  0.628507   0.511528
     0.935597   0.991511   0.571297  0.74485    …  0.84589   0.178834   0.284413
     0.160706   0.672252   0.133158  0.65554       0.371826  0.770628   0.0531208
     0.306617   0.836126   0.301198  0.0224702     0.39344   0.0370205  0.536062
     0.890947   0.168877   0.32002   0.486136      0.096078  0.172048   0.77672
     0.507762   0.573567   0.220124  0.165816      0.211049  0.433277   0.539476

    julia> b = view(a, 2:2:8,2:2:4)
    4×2 SubArray{Float64,2,Array{Float64,2},Tuple{StepRange{Int64,Int64},StepRange{Int64,Int64}},false}:
     0.537192  0.996234
     0.736979  0.228787
     0.991511  0.74485
     0.836126  0.0224702

    julia> (q,r) = qr(b);

    julia> q
    4×2 Array{Float64,2}:
     -0.338809   0.78934
     -0.464815  -0.230274
     -0.625349   0.194538
     -0.527347  -0.534856

    julia> r
    2×2 Array{Float64,2}:
     -1.58553  -0.921517
      0.0       0.866567

スパース行列（疎行列）
=======================

..
    `Sparse matrices <https://en.wikipedia.org/wiki/Sparse_matrix>`_ are
    matrices that contain enough zeros that storing them in a special data
    structure leads to savings in space and execution time. Sparse
    matrices may be used when operations on the sparse representation of a
    matrix lead to considerable gains in either time or space when
    compared to performing the same operations on a dense matrix.

`スパース行列 <https://en.wikipedia.org/wiki/Sparse_matrix>`_ とは
十分多くのゼロを値として持ち、ゆえに特別なデータ構造で保持すると
実行時間と空間を節約できるような行列のことです。
操作をおこないたい行列がスパースな場合、このデータ構造を用いることで、
パフォーマンスが劇的に改善する場合があります。

..
    Compressed Sparse Column (CSC) Storage
    --------------------------------------

圧縮列格納方式(Compressed Sparse Column Storage, CSC Storage)
================================================================

..
    In Julia, sparse matrices are stored in the `Compressed Sparse Column
    (CSC) format
    <https://en.wikipedia.org/wiki/Sparse_matrix#Compressed_sparse_column_.28CSC_or_CCS.29>`_.
    Julia sparse matrices have the type ``SparseMatrixCSC{Tv,Ti}``, where ``Tv``
    is the type of the nonzero values, and ``Ti`` is the integer type for
    storing column pointers and row indices.::

Juliaでは、スパース行列は `圧縮列格納方式(Compressed Sparse Column Storage, CSC Storage) <https://en.wikipedia.org/wiki/Sparse_matrix#Compressed_sparse_column_.28CSC_or_CCS.29>`_
と呼ばれる方法でメモリ上に保持されます。 Juliaにおけるスパース行列の
型は `SparseMatrixCSC{Tv, Ti}` で表され、 ``Tv`` にはゼロでない数値が、
``Ti`` には列へのポインタと、行のインデックスが入ります。::

    type SparseMatrixCSC{Tv,Ti<:Integer} <: AbstractSparseMatrix{Tv,Ti}
        m::Int                  # Number of rows
        n::Int                  # Number of columns
        colptr::Vector{Ti}      # Column i is in colptr[i]:(colptr[i+1]-1)
        rowval::Vector{Ti}      # Row values of nonzeros
        nzval::Vector{Tv}       # Nonzero values
    end

..
    The compressed sparse column storage makes it easy and quick to access
    the elements in the column of a sparse matrix, whereas accessing the
    sparse matrix by rows is considerably slower. Operations such as
    insertion of nonzero values one at a time in the CSC structure tend to
    be slow. This is because all elements of the sparse matrix that are
    beyond the point of insertion have to be moved one place over.

列を圧縮して保持することで、各列の値にアクセスするのが高速になりますが、
各行へのアクセスはかなり遅くなります。例えば、ゼロでない値を CSC 構造の
行列に一つ一つ代入していくような操作は低速となる傾向があります。というのも
代入したポイント以降にある要素全てを一つずつずらしていかなくてはならないためです。

..
    All operations on sparse matrices are carefully implemented to exploit
    the CSC data structure for performance, and to avoid expensive operations.

スパース行列に対して適用される操作は全て、CSCデータ構造に最適な
パフォーマンスを発揮し、効率の悪い操作をしないよう慎重に実装されています。

..
    If you have data in CSC format from a different application or library,
    and wish to import it in Julia, make sure that you use 1-based indexing.
    The row indices in every column need to be sorted. If your :obj:`SparseMatrixCSC`
    object contains unsorted row indices, one quick way to sort them is by
    doing a double transpose.

CSCフォーマットのデータを他のアプリケーションやライブラリからJuliaに
インポートする際は、1開始のインデックスを使用しなくてはならない点に
注意してください。 また、全列に関して、行のインデックスをソートしておく
必要があります。もし :obj:`SparseMatrixCSC` の行インデックスが
ソートされていない場合、２回転置すると高速にソートされます。

..
    In some applications, it is convenient to store explicit zero values
    in a :obj:`SparseMatrixCSC`. These *are* accepted by functions in :mod:`Base`
    (but there is no guarantee that they will be preserved in mutating
    operations).  Such explicitly stored zeros are treated as structural
    nonzeros by many routines.  The :func:`nnz` function returns the number of
    elements explicitly stored in the sparse data structure,
    including structural nonzeros. In order to count the exact number of actual
    values that are nonzero, use :func:`countnz`, which inspects every stored
    element of a sparse matrix.

現実には :obj:`SparseMatrixCSC` にゼロの値を明示的にもたせることが有用な場合
もあります。 :mod:`Base` の関数は全て、そのようにゼロを持つ `SparseMatrixCSC`
を受け取っても大丈夫なように作られています（が、引数の値を変更するような関数
の場合、当然ながらゼロの値を保持することは保証されません）。多くの処理は
そういった明示的ゼロを、非明示的ゼロ（スパース行列のデフォルト値）と区別し、
非ゼロ値として扱います。例えば :func:`nnz` は、スパースなデータ構造内の、
明示的に保持された要素の数を返すのですが、これには明示的ゼロの値も含まれます。
明示的ゼロを含まない、「本当にゼロでない値」をカウントしたい場合は
:func:`countnz` を使用すべきです。これは、スパース行列内の値を全て調べあげます。

..
    Sparse matrix constructors
    --------------------------

スパース行列のコンストラクタ
----------------------------

..
    The simplest way to create sparse matrices is to use functions
    equivalent to the :func:`zeros` and :func:`eye` functions that Julia provides
    for working with dense matrices. To produce sparse matrices instead,
    you can use the same names with an ``sp`` prefix:

スパース行列を作成する最も単純な方法は、密行列における :func:`zeros` と
:func:`eye` に相当する関数を使用することです。スパース行列の場合、頭に
``sp`` がついています。

.. doctest::

    julia> spzeros(3,5)
    3×5 sparse matrix with 0 Float64 nonzero entries

    julia> speye(3,5)
    3×5 sparse matrix with 3 Float64 nonzero entries:
            [1, 1]  =  1.0
            [2, 2]  =  1.0
            [3, 3]  =  1.0

..
    The :func:`sparse` function is often a handy way to construct sparse
    matrices. It takes as its input a vector ``I`` of row indices, a
    vector ``J`` of column indices, and a vector ``V`` of nonzero
    values. ``sparse(I,J,V)`` constructs a sparse matrix such that
    ``S[I[k], J[k]] = V[k]``.

:func:`sparse` 関数でも、お手軽にスパース行列を作成できます。
これは以下を引数として取ります。

1. ``I`` 行インデックスのベクトル
2. ``J`` 列インデックスのベクトル
3. ``V`` 非負値のベクトル

``sparse(I,J,V)`` は ``S[I[k], J[i] = V[k]]`` となるようなスパース行列を
返します。

.. doctest::

    julia> I = [1, 4, 3, 5]; J = [4, 7, 18, 9]; V = [1, 2, -5, 3];

    julia> S = sparse(I,J,V)
    5×18 sparse matrix with 4 Int64 nonzero entries:
            [1 ,  4]  =  1
            [4 ,  7]  =  2
            [5 ,  9]  =  3
            [3 , 18]  =  -5

..
    The inverse of the :func:`sparse` function is :func:`findn`, which
    retrieves the inputs used to create the sparse matrix.

:func:`sparse` の逆の機能を持つ関数は :func:`findn` です。これは
スパース行列を作成するのに使われたインデックスの値を返します。

.. doctest::

    julia> findn(S)
    ([1,4,5,3],[4,7,9,18])

    julia> findnz(S)
    ([1,4,5,3],[4,7,9,18],[1,2,3,-5])

..
    Another way to create sparse matrices is to convert a dense matrix
    into a sparse matrix using the :func:`sparse` function:



.. doctest::

    julia> sparse(eye(5))
    5×5 sparse matrix with 5 Float64 nonzero entries:
            [1, 1]  =  1.0
            [2, 2]  =  1.0
            [3, 3]  =  1.0
            [4, 4]  =  1.0
            [5, 5]  =  1.0

..
    You can go in the other direction using the :func:`full` function. The
    :func:`issparse` function can be used to query if a matrix is sparse.

:func:`full` 関数で、逆にスパース行列から密行列への変換を行えます。
また :func:`issparse` で行列がスパースか否かをチェックできます。

.. doctest::

    julia> issparse(speye(5))
    true

..
    Sparse matrix operations
    ------------------------

スパース行列の操作
------------------

..
    Arithmetic operations on sparse matrices also work as they do on dense
    matrices. Indexing of, assignment into, and concatenation of sparse
    matrices work in the same way as dense matrices. Indexing operations,
    especially assignment, are expensive, when carried out one element at
    a time. In many cases it may be better to convert the sparse matrix
    into ``(I,J,V)`` format using :func:`findnz`, manipulate the non-zeroes or
    the structure in the dense vectors ``(I,J,V)``, and then reconstruct
    the sparse matrix.

スパース行列に対する数学的操作は、密行列の場合とほぼ同様に行えます。
インデックス処理、値の代入、行列の結合などのやり方は、全て同じです。
インデックス処理や値の代入は、要素を一つ一つ処理していこうとすると
効率の悪い処理となるので、そのような場合は :func:`findnz` を使って
``(I,J,V)`` （行列内のゼロでない値の情報）を抜きだして直接操作し、
その後スパース行列を再構成したほうがベターです。

..
    Correspondence of dense and sparse methods
    ------------------------------------------
    The following table gives a correspondence between built-in methods on sparse
    matrices and their corresponding methods on dense matrix types. In general,
    methods that generate sparse matrices differ from their dense counterparts in
    that the resulting matrix follows the same sparsity pattern as a given sparse
    matrix ``S``, or that the resulting sparse matrix has density ``d``, i.e. each
    matrix element has a probability ``d`` of being non-zero.

スパース行列と密行列のメソッド対応表
------------------------------------
以下のテーブルはスパース行列のビルトインメソッドと、それに対応する密行列
のメソッドとの対応を表に表したものです。一般的に、スパース行列を返す関数は
以下の２点のうちどちらかの特徴を持っており、その点だけが対応する密行列の
関数との違いです。

1. 引数として取った ``S`` と同じタイプの行列（スパース行列ならスパース行列、密行列なら密行列）を返す。
2. 密度 ``d`` のスパース行列を返す。ただし密度 ``d`` の行列とは、それぞれの要素がゼロでない確率が ``d`` である行列のことを指す。

..
    Details can be found in the :ref:`stdlib-sparse` section of the standard library
    reference.

詳細は標準ライブラリリファレンスの :ref:`stdlib-sparse` セクションを見てください。


..
    +----------------------------------------+----------------------------------+--------------------------------------------+
    | Sparse                                 | Dense                            | Description                                |
    +========================================+==================================+============================================+
    | :func:`spzeros(m,n) <spzeros>`         | :func:`zeros(m,n) <zeros>`       | Creates a *m*-by-*n* matrix of zeros.      |
    |                                        |                                  | (:func:`spzeros(m,n) <spzeros>` is empty.) |
    +----------------------------------------+----------------------------------+--------------------------------------------+
    | :func:`spones(S) <spones>`             | :func:`ones(m,n) <ones>`         | Creates a matrix filled with ones.         |
    |                                        |                                  | Unlike the dense version, :func:`spones`   |
    |                                        |                                  | has the same sparsity pattern as *S*.      |
    +----------------------------------------+----------------------------------+--------------------------------------------+
    | :func:`speye(n) <speye>`               | :func:`eye(n) <eye>`             | Creates a *n*-by-*n* identity matrix.      |
    +----------------------------------------+----------------------------------+--------------------------------------------+
    | :func:`full(S) <full>`                 | :func:`sparse(A) <sparse>`       | Interconverts between dense                |
    |                                        |                                  | and sparse formats.                        |
    +----------------------------------------+----------------------------------+--------------------------------------------+
    | :func:`sprand(m,n,d) <sprand>`         | :func:`rand(m,n) <rand>`         | Creates a *m*-by-*n* random matrix (of     |
    |                                        |                                  | density *d*) with iid non-zero elements    |
    |                                        |                                  | distributed uniformly on the               |
    |                                        |                                  | half-open interval :math:`[0, 1)`.         |
    +----------------------------------------+----------------------------------+--------------------------------------------+
    | :func:`sprandn(m,n,d) <sprandn>`       | :func:`randn(m,n) <randn>`       | Creates a *m*-by-*n* random matrix (of     |
    |                                        |                                  | density *d*) with iid non-zero elements    |
    |                                        |                                  | distributed according to the standard      |
    |                                        |                                  | normal (Gaussian) distribution.            |
    +----------------------------------------+----------------------------------+--------------------------------------------+
    | :func:`sprandn(m,n,d,X) <sprandn>`     | :func:`randn(m,n,X) <randn>`     | Creates a *m*-by-*n* random matrix (of     |
    |                                        |                                  | density *d*) with iid non-zero elements    |
    |                                        |                                  | distributed according to the *X*           |
    |                                        |                                  | distribution. (Requires the                |
    |                                        |                                  | ``Distributions`` package.)                |
    +----------------------------------------+----------------------------------+--------------------------------------------+

.. tabularcolumns:: |l|l|L|

+------------------------------------+------------------------------+--------------------------------------------+
| スパース行列                       | 密行列                       | 説明                                       |
+====================================+==============================+============================================+
| :func:`spzeros(m,n) <spzeros>`     | :func:`zeros(m,n) <zeros>`   | 値が全てゼロの *m*-by-*n* 行列を作成       |
|                                    |                              | ( :func:`spzeros(m,n) <spzeros>` は値が空) |
+------------------------------------+------------------------------+--------------------------------------------+
| :func:`spones(S) <spones>`         | :func:`ones(m,n) <ones>`     | １で埋められた行列を作成                   |
|                                    |                              | 密行列の場合と違い :func:`spones` は *S*   |
|                                    |                              | と同じ密度の行列を返す。                   |
+------------------------------------+------------------------------+--------------------------------------------+
| :func:`speye(n) <speye>`           | :func:`eye(n) <eye>`         | *n*-by-*n* の単位行列を作成                |
+------------------------------------+------------------------------+--------------------------------------------+
| :func:`full(S) <full>`             | :func:`sparse(A) <sparse>`   | 密行列 <=> スパース行列のフォーマット変換  |
+------------------------------------+------------------------------+--------------------------------------------+
| :func:`sprand(m,n,d) <sprand>`     | :func:`rand(m,n) <rand>`     | *m*-by-*n* で密度 *d* のランダムな行列     |
|                                    |                              | 値は :math:`[0, 1)` の独立同一分布から     |
|                                    |                              | ランダムサンプリングしたものになる。       |
+------------------------------------+------------------------------+--------------------------------------------+
| :func:`sprandn(m,n,d) <sprandn>`   | :func:`randn(m,n) <randn>`   | 値の分布が独立同一分布でなく、標準正規分布 |
|                                    |                              | である点以外は上と同じ                     |
+------------------------------------+------------------------------+--------------------------------------------+
| :func:`sprandn(m,n,d,X) <sprandn>` | :func:`randn(m,n,X) <randn>` | 値の分布が標準正規分布ではなくカイ二乗分布 |
|                                    |                              | である点以外は上と同じ                     |
|                                    |                              | （``Distributions`` パッケージが必要）     |
+------------------------------------+------------------------------+--------------------------------------------+

