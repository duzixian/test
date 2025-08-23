cf_install() {
curl -fsSL -o cf https://ghfast.top/https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
chmod +x cf
}


cf_url() {
    local file_name=${1:-log.txt}          # 缺省文件名 log.txt
    grep -oE 'https://[^[:space:]]*\.trycloudflare\.com' "$file_name" | head -n1
}
