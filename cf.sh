cf_init() {
wget https://ghfast.top/https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
mv cloudflared-linux-amd64 /usr/local/bin/cloudflared
chmod +x /usr/local/bin/cloudflared
}

cf_url() {
    local file_name=${1:-log.txt}          # 缺省文件名 log.txt
    grep -oE 'https://[^[:space:]]*\.trycloudflare\.com' "$file_name" | head -n1
}

sshd2222() {
    /usr/sbin/sshd -D -p 2222 -o PermitRootLogin=yes &
}

configure_ssh() {
    PORT=$1
    local port=${PORT:-22}

    if grep -Eq "^#?\s*PermitRootLogin" /etc/ssh/sshd_config; then
        sed -i 's/^#\?\s*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
    else
        echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
    fi

    if grep -Eq "^#?\s*PasswordAuthentication\s" /etc/ssh/sshd_config; then
        sed -i 's/^#\?\s*PasswordAuthentication\s.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
    else
        echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
    fi

    if grep -Eq "^#?\s*Port" /etc/ssh/sshd_config; then
        sed -i "s/^#\?\s*Port .*/Port ${port}/" /etc/ssh/sshd_config
    else
        echo "Port ${port}" >> /etc/ssh/sshd_config
    fi

    #if grep -Eq "^#?\s*UsePAM" /etc/ssh/sshd_config; then
        #sed -i 's/^#\?\s*UsePAM.*/UsePAM no/' /etc/ssh/sshd_config
    #else
        #echo "UsePAM no" >> /etc/ssh/sshd_config
    #fi
    systemctl enable --now ssh
}
