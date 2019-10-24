# workload-identity-test

## 概要

[Workload Identity](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity)の検証用レポジトリ

## 準備

- gcloud SDK: 265.0.0
- kubectlもインストール済み
- gcloud auth login済み
- それぞれのshellでプロジェクト名は自分で使う用に書き換えて使ってください(エディタで一括変換するといいかも)

## レポジトリの構成

- new-cluster-sample
  - 新しくWorkload Identityを有効にしたクラスタを作成するサンプル
- new-cluster-long-name-sample
  - 新しくWorkload Identityを有効にしたクラスタを作成するサンプル
  - 名前が長いだけだが動かない
- migration-cluster-sample
  - 既存のクラスタのWorkload Identityを有効にするサンプル
  - 使っているnodeを直接アップグレードする
- migration-manual-cluster-sample
  - 既存のクラスタのWorkload Identityを有効にするサンプル
  - 新しいnodeに手動で移行する
- new-pubsub-migration-sample
  - pubsubを使ったクラスタでWorkload Identityを有効にする
  - 既存の環境でキーを使っていた場合に新しい環境に移行するサンプル
  - service accountのキーをこのディレクトリ下に置く必要があり
