# DiscordBotF

フィヨルドブートキャンプサーバー専用のDiscord連携サービスです。

サービス内でメンバーが質問に答えると、それをBotがDiscordのチャンネルに自動投稿します。
Discordコミュニティ内のメンバーがお互いのことをもっと知り合うきっかけをつくります！

## 開発環境

- Ruby 3.0.2
- Rails 6.1.3

## 機能概要

- 指定したサーバーのメンバーのみがログインできます。
- サーバーのメンバーは答えたい質問を選んで、それに対する回答を入力します。
- 回答はDiscordの指定したチャンネルに毎日ランダムに投稿されます。
- 自分の回答と過去に投稿されたメンバーの回答をサービス上で見ることができます。
- サーバーの管理人は、サービスの管理者として登録されます。
- 管理者は、任意のユーザーを管理者にすることができます。
- 管理者は、質問の登録、編集、削除ができます。
- サーバーから去ったメンバーは自動的にサービスから削除されます。

## 利用方法

### DiscordのApplicationの作成

https://discordapp.com/developers/applications/

Botの設定

- Developer PortalからBotを作成してTokenを環境変数に設定
- SERVER MEMBERS INTENTをONにする
- OAuth2のScopeからBotをチェック、PermissionsのSendMessagesをチェックする
- 発行されたURLからBotをサーバーに招待する

OAuth2の設定

- Developer PortalのOAuth2のRedirectsにリダイレクトURLを設定する
- OAuth2のClient IDとClient Secretを環境変数に設定
- 利用Scopeはidentifyのみです

### 環境変数の設定

| 環境変数名            | 説明                                      |
| --------------------- | ----------------------------------------- |
| DISCORD_BOT_TOKEN     | BotのToken                                |
| DISCORD_CLIENT_ID     | OAuth2のClient ID                         |
| DISCORD_CLIENT_SECRET | OAuth2のClient Secret                     |
| DISCORD_SERVER_ID     | Botを招待するDiscordサーバーのID          |
| DISCORD_CHANNEL_ID    | Botのメッセージを送信したいチャンネルのID |
| SEND_MESSAGE_COUNT    | 一度に送信する回答数                      |
| URL_HOST              | ローカルの場合は`127.0.0.1:3000`          |

Discordの個人設定の詳細設定から開発者モードをONにすると、サーバーやチャンネルのIDを取得できるようになります。

### インストール

```
$ bin/setup
$ rails server
```

### Rake Task

ローカルの場合は`rails discord_bot:start`でBotをオンライン状態にたちあげることができます。
Herokuで動かす際はDynosに表示されるこのコマンドをONにしてください。
ユーザーの自動削除機能はBotをオンライン状態にしていないと機能しません。
※Heroku無料枠で利用している場合はスリープ状態になってしまうようなので、Heroku Schedulerで10分おきにアクセスさせるなどして対応してください。

メッセージの送信は`rails discord_bot:send_messages`を定期実行することで動作しています。
Herokuで動かす際はHeroku Schedulerにこのコマンドを登録してください。

## テスト

```
$ rails test:all
```

## ScreenShots
![discord-bot-f-1](https://user-images.githubusercontent.com/66161651/124405816-8f02b500-dd7a-11eb-9491-ed32dbae5982.png)
![discord-bot-f-2](https://user-images.githubusercontent.com/66161651/124405827-95912c80-dd7a-11eb-9761-e97ec6d518b7.png)
