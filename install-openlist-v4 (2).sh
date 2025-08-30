
# ------------------------------------------------------------
#  OpenList 极简安装脚本
#  用法：
#    bash openlist.sh            # 最新版
#    bash openlist.sh 4.11       # 指定版 4.11
# ------------------------------------------------------------

set -e

# ------------- 颜色输出 -------------
RED_COLOR='\e[1;31m'; GREEN_COLOR='\e[1;32m'; YELLOW_COLOR='\e[1;33m'; RES='\e[0m'

# ------------- CPU 架构映射 -------------
declare -A ARCH_MAP=(
  ["x86_64"]="amd64" ["aarch64"]="arm64" ["loongarch64"]="loong64"
  ["loongson3"]="mips64le" ["s390x"]="s390x"
)

# ------------- 基本检查 -------------
CURRENT_OS=$(uname -s)
[ "$CURRENT_OS" != "Linux" ] && { echo -e "${RED_COLOR}✖ 仅支持 Linux${RES}"; exit 1; }

if [ "$(id -u)" -ne 0 ]; then
  exec sudo bash "$0" "$@"
fi

if ! command -v curl >/dev/null 2>&1; then
  echo -e "${RED_COLOR}✖ 请先安装 curl${RES}"; exit 1
fi

if ! command -v systemctl >/dev/null 2>&1; then
  echo -e "${RED_COLOR}✖ 需要 systemd 环境${RES}"; exit 1
fi

# ------------- 获取系统架构 -------------
platform=$(arch 2>/dev/null || uname -m)
ARCH=${ARCH_MAP[$platform]:-UNKNOWN}
[ "$ARCH" = "UNKNOWN" ] && { echo -e "${RED_COLOR}✖ 暂不支持 $platform${RES}"; exit 1; }

# ------------- 版本参数 -------------
TARGET_TAG=${1:-latest}

# ------------- 安装目录 -------------
INSTALL_PATH="/opt/openlist"
mkdir -p "$INSTALL_PATH"

# ------------- 磁盘空间检查 -------------
# ------------- 新版：静默检查磁盘空间 -------------
check_disk_space() {
  local tmp_mb=$(df /tmp 2>/dev/null | awk 'NR==2{print $4}' || echo 0)
  local install_mb=$(df "$(dirname "$INSTALL_PATH")" 2>/dev/null | awk 'NR==2{print $4}' || echo 0)
  if [ "$tmp_mb" -lt 102400 ] || [ "$install_mb" -lt 102400 ]; then
    echo -e "${YELLOW_COLOR}⚠ 磁盘空间可能不足，继续安装...${RES}"
  fi
}

check_disk_space

# ------------- 下载地址构造 -------------
if [ "$TARGET_TAG" = "latest" ]; then
  DOWNLOAD_URL="https://ghfast.top/https://github.com/OpenListTeam/OpenList/releases/latest/download/openlist-linux-musl-$ARCH.tar.gz"
else
  DOWNLOAD_URL="https://ghfast.top/https://github.com/OpenListTeam/OpenList/releases/download/${TARGET_TAG}/openlist-linux-musl-$ARCH.tar.gz"
fi

# ------------- 下载 & 解压 -------------
TMP_TAR="/tmp/openlist.tar.gz"
echo -e "${GREEN_COLOR}📥 下载 OpenList ...${RES}"
curl -L --retry 3 --retry-delay 3 "$DOWNLOAD_URL" -o "$TMP_TAR"
tar -zxf "$TMP_TAR" -C "$INSTALL_PATH" && rm -f "$TMP_TAR"

[ ! -x "$INSTALL_PATH/openlist" ] && { echo -e "${RED_COLOR}✖ 安装文件异常${RES}"; exit 1; }
chmod +x "$INSTALL_PATH/openlist"
