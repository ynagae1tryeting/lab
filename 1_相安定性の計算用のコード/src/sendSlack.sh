#!bin/bash

# ------------
# Slackのbotとして指定したチャンネルに投稿するスクリプト
# 
# $1: botの名前 $2: メッセージ
# ------------

function sendSlack () {
#    set -eu
# --- Incoming WebHooksのURL
# --- 
    WEBHOOKURL="https://hooks.slack.com/services/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"
# --- デフォルトの変数
# --- slack 送信チャンネル
    CHANNEL="#testbot_yuki"
# --- slack 送信名
    BOTNAME="計算途中結果報告bot"
    BOTNAME="$1"
# --- slack アイコン
    FACEICON=":nerd_face:"
# --- メッセージ
    MESSAGE="現在計算中のqueが終了しました。"
    MESSAGE="$2"

    curl -s -S -X POST --data-urlencode "payload={\"channel\": \"${CHANNEL}\", \"username\": \"${BOTNAME}\", \"icon_emoji\": \"${FACEICON}\", \"text\": \"${MESSAGE}\" }" ${WEBHOOKURL}
}