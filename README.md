# megapのCWLtoolsを用いた実行方法

https://github.com/users/satoshi0409/packages/container/package/megap%2Fmegap-for-cwl
にあるコンテナイメージを.cwlファイルの内部でpullして使っている

## 1. MeGAPPre.shの実行
```
$ cwltool docker-megappre.cwl docker-megappre.yml
INFO /home/satoshi.tazawa/.local/bin/cwltool 3.1.20220628170238
INFO Resolved 'docker-megappre.cwl' to 'file:///home/satoshi.tazawa/NIG/2022/docker_pipelines/docker-megap/docker-megappre.cwl'
INFO [job docker-megappre.cwl] /tmp/8tar20wh$ docker \
    run \
    -i \
    --mount=type=bind,source=/tmp/8tar20wh,target=/XWHqYR \
    --mount=type=bind,source=/tmp/_awtn90l,target=/tmp \
    --mount=type=bind,source=/home/satoshi.tazawa/NIG/2022/docker_pipelines/docker-megap/raw,target=/var/lib/cwl/stga65ce49a-cc62-4122-861d-9a4e3b13dd3d/raw,readonly \
    --mount=type=bind,source=/home/satoshi.tazawa/NIG/2022/docker_pipelines/Reference,target=/var/lib/cwl/stg7e846d84-d401-4877-9679-cb073a03f17d/Reference,readonly \
    --workdir=/XWHqYR \
    --read-only=true \
    --user=508:500 \
    --rm \
    --cidfile=/tmp/wr1n_33m/20220726160654-538930.cid \
    --env=TMPDIR=/tmp \
    --env=HOME=/XWHqYR \
    ghcr.io/satoshi0409/megap/megap-for-cwl:latest \
    MeGAPPre.sh \
    /var/lib/cwl/stga65ce49a-cc62-4122-861d-9a4e3b13dd3d/raw \
    /var/lib/cwl/stg7e846d84-d401-4877-9679-cb073a03f17d/Reference
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

/app/program/fastp -i /var/lib/cwl/stga65ce49a-cc62-4122-861d-9a4e3b13dd3d/raw/ERR911975_1.fastq.sam.mapped.bam.sort.bam.fastq -o ERR911975_1.fastq.sam.mapped.bam.sort.bam.fastq.trim.fastq -G -3 -n 1 -l 90 -w 1 --adapter_fasta /var/lib/cwl/stg7e846d84-d401-4877-9679-cb073a03f17d/Reference/Adapter.fasta
fastp v0.23.2, time used: 697 seconds
INFO [job docker-megappre.cwl] Max memory used: 1349MiB
INFO [job docker-megappre.cwl] completed success
{
    "out": {
        "location": "file:///home/satoshi.tazawa/NIG/2022/docker_pipelines/docker-megap/8tar20wh",
        "basename": "8tar20wh",
        "class": "Directory",
        "listing": [
            {
                "class": "File",
                "location": "file:///home/satoshi.tazawa/NIG/2022/docker_pipelines/docker-megap/8tar20wh/fastp.json",
                "basename": "fastp.json",
                "checksum": "sha1$5a712537e624c83ed0190f9f16108e046b35563f",
                "size": 58451,
                "path": "/home/satoshi.tazawa/NIG/2022/docker_pipelines/docker-megap/8tar20wh/fastp.json"
            },
            {
                "class": "File",
                "location": "file:///home/satoshi.tazawa/NIG/2022/docker_pipelines/docker-megap/8tar20wh/fastp.html",
                "basename": "fastp.html",
                "checksum": "sha1$56f7a27e388ac93f0a4b3f8d0c0be7608eaf09e0",
                "size": 229817,
                "path": "/home/satoshi.tazawa/NIG/2022/docker_pipelines/docker-megap/8tar20wh/fastp.html"
            },
            {
                "class": "File",
                "location": "file:///home/satoshi.tazawa/NIG/2022/docker_pipelines/docker-megap/8tar20wh/ERR911975_1.fastq.sam.mapped.bam.sort.bam.fastq.trim.fastq.fa",
                "basename": "ERR911975_1.fastq.sam.mapped.bam.sort.bam.fastq.trim.fastq.fa",
                "checksum": "sha1$9ef4e23e08bcb2ba7bd60e987fff2c45a596b5e7",
                "size": 739442688,
                "path": "/home/satoshi.tazawa/NIG/2022/docker_pipelines/docker-megap/8tar20wh/ERR911975_1.fastq.sam.mapped.bam.sort.bam.fastq.trim.fastq.fa"
            }
        ],
        "path": "/home/satoshi.tazawa/NIG/2022/docker_pipelines/docker-megap/8tar20wh"
    }
}
INFO Final process status is success

$ ls
8tar20wh  docker-megappre.cwl  docker-megappre.yml  raw

$ ll 8tar20wh/
合計 722400
-rw-r--r-- 1 satoshi.tazawa users 739442688  7月 26 16:18 ERR911975_1.fastq.sam.mapped.bam.sort.bam.fastq.trim.fastq.fa
-rw-r--r-- 1 satoshi.tazawa users    229817  7月 26 16:18 fastp.html
-rw-r--r-- 1 satoshi.tazawa users     58451  7月 26 16:18 fastp.json
```

## 2. MeGAPTaxa.shの実行
```
$ cwltool docker-megaptaxa.cwl docker-megaptaxa.yml
```

## 3. MeGAPFunc.shの実行
```
$ cwltool docker-megapdfunc.cwl docker-megapfunc.yml
```
