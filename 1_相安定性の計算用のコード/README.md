### 使用方法

- 実行directryの中にsrcを配置

- `srcpath=./src/*.sh ; for i in $srcpath ; do chmod 777 $i ; . $i ;  done` 実行
　srcファイル中の関数を読み込み

- `chmod 777 ./vasprun2017.sh`
　実行権限がないと実行できない

- `nohup ./vasprun2017 &` 実行
下記は ./vasprun2017内で実行している内容

- POSCARなどが配置されているdirectryの1階層上に移動

- `BM.MakeInput` 実行
　dirctryの中にBMフォルダと、BM用の実行ファイルが出来上がる

- `BM.MakeInput`を実行したdirectryで`BM.Vasprun.Slack`を実行

#### 全ての計算が終わったら

- `BM.Integratedata`をやる
　BMのデータを全て集計して、phonopyでBM計算を可能にする。