## gcloud導入手順

### WSLの更新
```
sudo apt update && sudo apt upgrade
```

### Google Cloud SDKのインストール

1. リポジトリの追加
```
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
```

2. Google Cloudの公開鍵の追加
```
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
```

3. パッケージリストの更新
```
sudo apt update
```

4. Google Cloud SDKのインストール
```
sudo apt install google-cloud-sdk
```

### gcloudの初期化
```
gcloud init
```

### 認証
```
gcloud auth login
```
ブラウザベースでの認証が始まります。
localhostからはWSLの場合は入れないことがあるので、表示されるurlをコピーしてブラウザで開いてください。

## gcloudからterraformに必要な情報等の作成及び取得

### GCPプロジェクトの作成
```
gcloud projects create <プロジェクトID> --name=<プロジェクト名>
gcloud projects create terraform-practice-torohash --name=terraform-practice-torohash
```

### GCPプロジェクトの設定
```
gcloud config set project [PROJECT_ID]
gcloud config set project terraform-practice-torohash
```

### GCPプロジェクトの確認
```
gcloud config list
```

### VMインスタンスAPIの有効化
```
gcloud services enable compute.googleapis.com --project [PROJECT_ID]
gcloud services enable compute.googleapis.com --project terraform-practice-torohash
```
※割と時間がかかる場合あり

### 有効なAPIの確認
```
gcloud services list --enabled --project [PROJECT_ID]
gcloud services list --enabled --project terraform-practice-torohash
```

### 請求アカウントのリンク
```
gcloud beta billing accounts list
gcloud beta billing projects link [PROJECT_ID] --billing-account=[BILLING_ACCOUNT_ID]
```
請求先アカウントをlistから確認し、そのIDを指定してリンクします。

### サービスアカウントの作成
```
gcloud iam service-accounts create [SERVICE_ACCOUNT_NAME] --display-name [DISPLAY_NAME]
gcloud iam service-accounts create terraform-practice-torohash --display-name terraform-practice-torohash
```

### サービスアカウントの確認
```
gcloud iam service-accounts list
```

### サービスアカウントに権限の付与
```
gcloud projects add-iam-policy-binding [PROJECT_ID] --member="serviceAccount:[SA_NAME]@[PROJECT_ID].iam.gserviceaccount.com" --role="roles/compute.admin"
gcloud projects add-iam-policy-binding terraform-practice-torohash --member="serviceAccount:terraform-practice-torohash@terraform-practice-torohash.iam.gserviceaccount.com" --role="roles/compute.admin"
```
付与しているcompute.adminはVMインスタンスの作成や削除などの権限を持っています。

### サービスアカウントの権限の確認
```
gcloud projects get-iam-policy [PROJECT_ID] --flatten="bindings[].members" --format='table(bindings.role)' --filter="bindings.members:[SA_NAME]@[PROJECT_ID].iam.gserviceaccount.com"
gcloud projects get-iam-policy terraform-practice-torohash --flatten="bindings[].members" --format='table(bindings.role)' --filter="bindings.members:terraform-practice-torohash@terraform-practice-torohash.iam.gserviceaccount.com"
```

### サービスアカウントのキーの作成
```
gcloud iam service-accounts keys create [FILE_NAME].json --iam-account [SA_NAME]@[PROJECT_ID].iam.gserviceaccount.com
gcloud iam service-accounts keys create workspace/terraform-practice-torohash.json --iam-account terraform-practice-torohash@terraform-practice-torohash.iam.gserviceaccount.com
```

## terraformの設定

### terraformのインストール
dockerを使用。Dockerfileおよび、docker-compose.ymlを確認してください。

### terraformの初期化
```
docker compose run --rm terraform init
```
terraform init は、Terraformプロジェクトを初期化します。プラグインやプロバイダーなどの必要なコンポーネントをダウンロードし、Terraformがプロジェクトを実行する準備を整えます。  
※--rmはコンテナの終了時にコンテナを削除するオプションです。

### terraformのプラン
```
docker compose run --rm terraform plan
```
terraform plan は、提案された変更をプレビューします。これにより、実際にリソースを作成または変更する前に、Terraformがどのような操作を行うかを知ることができます。

### terraformの実行
```
docker compose run --rm terraform apply
```
terraform apply は、planで示された変更を実際に適用します。これにより、インフラストラクチャーが実際に作成または変更されます。

### terraformの破棄
```
docker compose run --rm terraform destroy
```
terraform destroy は、Terraformによって管理されているすべてのインフラストラクチャーを破棄します。これにより、インフラストラクチャーが削除されます。

## .envファイルの設定

```
TF_VAR_credentials=キーファイル名
TF_VAR_region=リージョン(us-central1など)
TF_VAR_project=プロジェクトID
TF_VAR_zone=ゾーン(us-central1-aなど)
TF_VAR_instance=インスタンス名
TF_VAR_instance_name_prefix=インスタンス名のプレフィックス
TF_VAR_instance_count=インスタンス数
```