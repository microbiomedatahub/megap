# 目次
1. 【参考】コンテナイメージ作成とGitHub Container registryへの登録
2. CWLtool実行環境の構築方法
3. megapのcwltoolを用いた実行方法

# 1. 【参考】コンテナイメージ作成とGitHub Container registryへの登録
https://github.com/users/satoshi0409/packages/container/package/megap%2Fmegap-for-cwl 
にあるGitHub Container registryに既に登録済みなので、__作成し直す場合以外は以下の操作は不要です。__

```
# Dockerfileと必要なスクリプトをgit cloneする
$ git clone https://github.com/microbiomedatahub/megap.git
Cloning into 'megap'...
remote: Enumerating objects: 19, done.
remote: Counting objects: 100% (19/19), done.
remote: Compressing objects: 100% (19/19), done.
remote: Total 19 (delta 4), reused 0 (delta 0), pack-reused 0
Unpacking objects: 100% (19/19), done.
$ cd megap && ls
Dockerfile  Program  README.md  cwl_scripts
# Dockerコンテナイメージの作成
$ docker build -t megap .

# パーソナルアクセストークンをghcr.txtに保存して、以下でGitHubアカウントにログインする
$ cat ../ghcr.txt | docker login ghcr.io -u satoshi0409 --password-stdin
WARNING! Your password will be stored unencrypted in /home/satoshi.tazawa/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
$ docker images
REPOSITORY   TAG       IMAGE ID       CREATED          SIZE
megap        latest    423b3bd74d9a   15 minutes ago   651MB
ubuntu       latest    df5de72bdb3b   2 weeks ago      77.8MB
$ docker tag 423b3bd74d9a ghcr.io/satoshi0409/megap/megap-for-cwl:latest
$ docker images
REPOSITORY                                TAG       IMAGE ID       CREATED          SIZE
megap                                     latest    423b3bd74d9a   51 minutes ago   651MB
ghcr.io/satoshi0409/megap/megap-for-cwl   latest    423b3bd74d9a   51 minutes ago   651MB
ubuntu                                    latest    df5de72bdb3b   2 weeks ago      77.8MB
$ docker push ghcr.io/satoshi0409/megap/megap-for-cwl:latest
The push refers to repository [ghcr.io/satoshi0409/megap/megap-for-cwl]
01af93a512a5: Pushed
dbd15e3c6cfa: Pushed
be5091874c3c: Pushed
c36a58d12c14: Pushed
44de761777ae: Pushed
b93d0e1c2514: Pushed
2ab477d2a8be: Pushed
6d92f7aa204e: Pushed
629d9dbab5ed: Layer already exists
latest: digest: sha256:7a9ac66c9b394f1dab6ce1d0153c275b2680f5de8bd2b5968b34a68fbe9d64b0 size: 2217
```

# 2. CWLtool実行環境の構築方法
スパコン上で以下の手順で実行環境の構築を行った。
```
$ qlogin && ssh it048
# virtualenvとcwltoolのインストール
$ pip install virtualenv
$ python -m virtualenv cwltoolenv
$ . cwltoolenv/bin/activate
(cwltoolenv) $ pip install --upgrade pip
(cwltoolenv) $ pip install cwltool
# dockerモジュールのロード(cwltool内からdocker pullするために必要)
(cwltoolenv) $ module load docker
```

# 3. megapのCWLtoolを用いた実行方法
例えばit048の/data1/megap-cwltool でテストを実施する手順を以下に示す。
```
$ mkdir -p /data1/megap-cwltool && cd /data1/megap-cwltool
# テスト用のraw, Referenceフォルダーをこのフォルダーにコピー
```
GitHub Container registryに登録済みのコンテナイメージを.cwlファイルの内部でpullして実行している。


## A. MeGAPPre.shの実行
https://github.com/microbiomedatahub/megap/tree/main/cwl_scripts
にあるdocker-megappre.cwlファイルとdocker-megappre.ymlファイルのペアを作成する。<br>
実行する前にrawとReferenceフォルダーへのpathは実行環境に応じて適宜変更する。<br>
```
input_data_path:
  class: Directory
  path: /data1/megap-cwltool/raw/
input_ref_path:
  class: Directory
  path: /data1/megap-cwltool/Reference/
```
実行時にデフォルトで使用される/tmpフォルダの容量が足りないと、解析途中で落ちてしまう。<br>
この場合は空のフォルダー(例えばtmp1)を作成して--cachedirで指定すれば解決する。

```
(cwltoolenv)$ cwltool --cachedir tmp1 docker-megappre.cwl docker-megappre.yml
INFO /lustre7/home/tazawa-axio/cwltoolenv/bin/cwltool 3.1.20220802125926
INFO Resolved 'docker-megappre.cwl' to 'file:///data1/megap-cwltool/docker-megappre.cwl'
INFO [job docker-megappre.cwl] Output of job will be cached in /data1/megap-cwltool/tmp1/fd48498a0e82e888cccfc460924f8cf0
INFO [job docker-megappre.cwl] /data1/megap-cwltool/tmp1/fd48498a0e82e888cccfc460924f8cf0$ docker \
    run \
    -i \
    --mount=type=bind,source=/data1/megap-cwltool/tmp1/fd48498a0e82e888cccfc460924f8cf0,target=/gpCPOu \
    --mount=type=bind,source=/tmp/xbb2dznn,target=/tmp \
    --mount=type=bind,source=/data1/megap-cwltool/raw,target=/var/lib/cwl/stge775bebf-bf19-4c16-bd61-e4313a78d39f/raw,readonly \
    --mount=type=bind,source=/data1/megap-cwltool/Reference,target=/var/lib/cwl/stg917f0fad-3553-47f0-a98f-4b92013e4682/Reference,readonly \
    --workdir=/gpCPOu \
    --read-only=true \
    --user=5008:8001 \
    --rm \
    --cidfile=/tmp/1ace44j7/20220817123915-267525.cid \
    --env=TMPDIR=/tmp \
    --env=HOME=/gpCPOu \
    ghcr.io/satoshi0409/megap/megap-for-cwl:latest \
    MeGAPPre.sh \
    /var/lib/cwl/stge775bebf-bf19-4c16-bd61-e4313a78d39f/raw \
    /var/lib/cwl/stg917f0fad-3553-47f0-a98f-4b92013e4682/Reference
Detecting adapter sequence for read1...
No adapter detected for read1

Read1 before filtering:
total reads: 25974516
total bases: 2555246767
Q20 bases: 2508201382(98.1589%)
Q30 bases: 2325869831(91.0233%)

Read1 after filtering:
total reads: 24776937
total bases: 2467819898
Q20 bases: 2429985047(98.4669%)
Q30 bases: 2267419567(91.8795%)

Filtering result:
reads passed filter: 24776937
reads failed due to low quality: 0
reads failed due to too many N: 10881
reads failed due to too short: 1186698
reads with adapter trimmed: 0
bases trimmed due to adapters: 0

Duplication rate (may be overestimated since this is SE data): 10.3991%

JSON report: fastp.json
HTML report: fastp.html

/app/program/fastp -i /var/lib/cwl/stge775bebf-bf19-4c16-bd61-e4313a78d39f/raw/ERR911975_1.fastq.sam.mapped.bam.sort.bam.fastq -o ERR911975_1.fastq.sam.mapped.bam.sort.bam.fastq.trim.fastq -G -3 -n 1 -l 90 -w 1 --adapter_fasta /var/lib/cwl/stg917f0fad-3553-47f0-a98f-4b92013e4682/Reference/Adapter.fasta
fastp v0.23.2, time used: 756 seconds
INFO [job docker-megappre.cwl] Max memory used: 5217MiB
INFO [job docker-megappre.cwl] completed success
{
    "out": {
        "location": "file:///data1/megap-cwltool/fd48498a0e82e888cccfc460924f8cf0",
        "basename": "fd48498a0e82e888cccfc460924f8cf0",
        "class": "Directory",
        "listing": [
            {
                "class": "File",
                "location": "file:///data1/megap-cwltool/fd48498a0e82e888cccfc460924f8cf0/fastp.json",
                "basename": "fastp.json",
                "checksum": "sha1$24ae181ba6752642c03c34e3d6ecb4c2b56dc971",
                "size": 58451,
                "path": "/data1/megap-cwltool/fd48498a0e82e888cccfc460924f8cf0/fastp.json"
            },
            {
                "class": "File",
                "location": "file:///data1/megap-cwltool/fd48498a0e82e888cccfc460924f8cf0/fastp.html",
                "basename": "fastp.html",
                "checksum": "sha1$04c121a6990cbf50d592ff5d9ef03072c8bd3a35",
                "size": 229817,
                "path": "/data1/megap-cwltool/fd48498a0e82e888cccfc460924f8cf0/fastp.html"
            },
            {
                "class": "File",
                "location": "file:///data1/megap-cwltool/fd48498a0e82e888cccfc460924f8cf0/ERR911975_1.fastq.sam.mapped.bam.sort.bam.fastq.trim.fastq.fa",
                "basename": "ERR911975_1.fastq.sam.mapped.bam.sort.bam.fastq.trim.fastq.fa",
                "checksum": "sha1$3cc087cb0a853a3b08be446bbc90398937a11e22",
                "size": 2980141824,
                "path": "/data1/megap-cwltool/fd48498a0e82e888cccfc460924f8cf0/ERR911975_1.fastq.sam.mapped.bam.sort.bam.fastq.trim.fastq.fa"
            }
        ],
        "path": "/data1/megap-cwltool/fd48498a0e82e888cccfc460924f8cf0"
    }
}
INFO Final process status is success

$ ls -al fd48498a0e82e888cccfc460924f8cf0/
合計 2910588
drwxr-xr-x  2 tazawa-axio co-axiohelix        127  8月 17 12:52 .
drwxr-xr-x 11 tazawa-axio co-axiohelix       4096  8月 22 12:14 ..
-rw-r--r--  1 tazawa-axio co-axiohelix 2980141824  8月 17 12:52 ERR911975_1.fastq.sam.mapped.bam.sort.bam.fastq.trim.fastq.fa
-rw-r--r--  1 tazawa-axio co-axiohelix     229817  8月 17 12:51 fastp.html
-rw-r--r--  1 tazawa-axio co-axiohelix      58451  8月 17 12:51 fastp.json
```

## B. MeGAPTaxa.shの実行
同様にdocker-megaptaxa.cwlとdocker-megaptaxa.ymlを作成する。<br>
```
(cwltoolenv)$ mkdir tmp2
# MeGAPPreで作成した.faファイルをrawにコピーする
(cwltoolenv)$ cp ERR911975_1.fastq.sam.mapped.bam.sort.bam.fastq.trim.fastq.fa raw/
(cwltoolenv)$ cwltool --cachedir tmp2 docker-megaptaxa.cwl docker-megaptaxa.yml
INFO /lustre7/home/tazawa-axio/cwltoolenv/bin/cwltool 3.1.20220802125926
INFO Resolved 'docker-megaptaxa.cwl' to 'file:///data1/megap-cwltool/docker-megaptaxa.cwl'
INFO [job docker-megaptaxa.cwl] Output of job will be cached in /data1/megap-cwltool/tmp2/de938ffa3aa79a8df92959e1b3ff3c1d
INFO [job docker-megaptaxa.cwl] /data1/megap-cwltool/tmp2/de938ffa3aa79a8df92959e1b3ff3c1d$ docker \
    run \
    -i \
    --mount=type=bind,source=/data1/megap-cwltool/tmp2/de938ffa3aa79a8df92959e1b3ff3c1d,target=/GXzRtr \
    --mount=type=bind,source=/tmp/mzkoevs_,target=/tmp \
    --mount=type=bind,source=/data1/megap-cwltool/raw,target=/var/lib/cwl/stg162e146a-84b9-4d1e-82d3-793377bbc9bb/raw,readonly \
    --mount=type=bind,source=/data1/megap-cwltool/Reference,target=/var/lib/cwl/stg9b4f184f-461d-4ab7-a071-ece99cd1e079/Reference,readonly \
    --workdir=/GXzRtr \
    --read-only=true \
    --user=5008:8001 \
    --rm \
    --cidfile=/tmp/1im0i03g/20220817154017-283394.cid \
    --env=TMPDIR=/tmp \
    --env=HOME=/GXzRtr \
    ghcr.io/satoshi0409/megap/megap-for-cwl:latest \
    MeGAPTaxa.sh \
    /var/lib/cwl/stg162e146a-84b9-4d1e-82d3-793377bbc9bb/raw \
    /var/lib/cwl/stg9b4f184f-461d-4ab7-a071-ece99cd1e079/Reference
# loaded 1364630 sequences
# loading taxonomy file: /var/lib/cwl/stg9b4f184f-461d-4ab7-a071-ece99cd1e079/Reference/RDP_BacArc.fasta.one.1200.3000.mapseq
!! Wed Aug 17 06:40:32 2022 [] mapseq.cpp:3609 void load_taxa(const estr&, eseqdb&): loading taxonomy, 229697 sequences not found in sequence database
# taxonomies: 1
# tax levels: 9
# tax: 0 level: 0 (2)
# tax: 0 level: 1 (60)
# tax: 0 level: 2 (145)
# tax: 0 level: 3 (243)
# tax: 0 level: 4 (423)
# tax: 0 level: 5 (2162)
# tax: 0 level: 6 (110)
# tax: 0 level: 7 (352)
# tax: 0 level: 8 (1)
# fcount: 76 otukmercount: 260326
# processing input... 24776937
# done processing 24776937 seqs (9905.64s)
INFO [job docker-megaptaxa.cwl] Max memory used: 2086MiB
INFO [job docker-megaptaxa.cwl] completed success
{
    "out": {
        "location": "file:///data1/megap-cwltool/de938ffa3aa79a8df92959e1b3ff3c1d",
        "basename": "de938ffa3aa79a8df92959e1b3ff3c1d",
        "class": "Directory",
        "listing": [
            {
                "class": "File",
                "location": "file:///data1/megap-cwltool/de938ffa3aa79a8df92959e1b3ff3c1d/ERR911975_1.fastq.sam.mapped.bam.sort.bam.fastq.trim.fastq.fa.mapseq.parsed.genus.m16s",
                "basename": "ERR911975_1.fastq.sam.mapped.bam.sort.bam.fastq.trim.fastq.fa.mapseq.parsed.genus.m16s",
                "checksum": "sha1$eead2ac13b5ebe28caccf01d004a17fa26d6a68c",
                "size": 3766,
                "path": "/data1/megap-cwltool/de938ffa3aa79a8df92959e1b3ff3c1d/ERR911975_1.fastq.sam.mapped.bam.sort.bam.fastq.trim.fastq.fa.mapseq.parsed.genus.m16s"
            }
        ],
        "path": "/data1/megap-cwltool/de938ffa3aa79a8df92959e1b3ff3c1d"
    }
}
INFO Final process status is success

[tazawa-axio@it048 megap-cwltool]$ ls -al de938ffa3aa79a8df92959e1b3ff3c1d/
合計 8
drwxr-xr-x  2 tazawa-axio co-axiohelix  108  8月 17 18:25 .
drwxr-xr-x 11 tazawa-axio co-axiohelix 4096  8月 22 12:14 ..
-rw-r--r--  1 tazawa-axio co-axiohelix 3766  8月 17 18:25 ERR911975_1.fastq.sam.mapped.bam.sort.bam.fastq.trim.fastq.fa.mapseq.parsed.genus.m16s
```

## C. MeGAPFunc.shの実行
同様にdocker-megapfunc.cwlとdocker-megapfunc.ymlを作成する。<br>
```
(cwltoolenv)$ mkdir tmp3
(cwltoolenv)$ cwltool --cachedir tmp3 docker-megapdfunc.cwl docker-megapfunc.yml
INFO /lustre7/home/tazawa-axio/cwltoolenv/bin/cwltool 3.1.20220802125926
INFO Resolved 'docker-megapfunc.cwl' to 'file:///data1/megap-cwltool/docker-megapfunc.cwl'
INFO ['docker', 'pull', 'ghcr.io/satoshi0409/megap/megap-for-cwl:latest']
latest: Pulling from satoshi0409/megap/megap-for-cwl
(中略)
INFO [job docker-megapfunc.cwl] Max memory used: 34278MiB
INFO [job docker-megapfunc.cwl] completed success
{
    "out": {
        "location": "file:///data1/megap-cwltool/f7jf0952",
        "basename": "f7jf0952",
        "class": "Directory",
        "listing": [
            {
                "class": "File",
                "location": "file:///data1/megap-cwltool/f7jf0952/ERR911975_1.fastq.sam.mapped.bam.sort.bam.fastq.trim.fastq.fa.pt.fasta.remshort",
                "basename": "ERR911975_1.fastq.sam.mapped.bam.sort.bam.fastq.trim.fastq.fa.pt.fasta.remshort",
                "checksum": "sha1$96b2063c54b173672fe7161981ea9da8511d7030",
                "size": 1224015468,
                "path": "/data1/megap-cwltool/f7jf0952/ERR911975_1.fastq.sam.mapped.bam.sort.bam.fastq.trim.fastq.fa.pt.fasta.remshort"
            },
            {
                "class": "File",
                "location": "file:///data1/megap-cwltool/f7jf0952/ERR911975_1.fastq.sam.mapped.bam.sort.bam.fastq.trim.fastq.fa.pt.fasta.remshort.tsv.parsed",
                "basename": "ERR911975_1.fastq.sam.mapped.bam.sort.bam.fastq.trim.fastq.fa.pt.fasta.remshort.tsv.parsed",
                "checksum": "sha1$33883559b022655026b4c4a458faefc941f07710",
                "size": 1169828536,
                "path": "/data1/megap-cwltool/f7jf0952/ERR911975_1.fastq.sam.mapped.bam.sort.bam.fastq.trim.fastq.fa.pt.fasta.remshort.tsv.parsed"
            },
            {
                "class": "File",
                "location": "file:///data1/megap-cwltool/f7jf0952/ERR911975_1.fastq.sam.mapped.bam.sort.bam.fastq.trim.fastq.fa.pt.fasta.remshort.tsv.parsed.keggid.ko.tsv",
                "basename": "ERR911975_1.fastq.sam.mapped.bam.sort.bam.fastq.trim.fastq.fa.pt.fasta.remshort.tsv.parsed.keggid.ko.tsv",
                "checksum": "sha1$a48cff4c76f280062b92124c14250b71eab8ffc7",
                "size": 96210,
                "path": "/data1/megap-cwltool/f7jf0952/ERR911975_1.fastq.sam.mapped.bam.sort.bam.fastq.trim.fastq.fa.pt.fasta.remshort.tsv.parsed.keggid.ko.tsv"
            }
        ],
        "path": "/data1/megap-cwltool/f7jf0952"
    }
}
INFO Final process status is success
```
