#!/bin/bash

# 蒲公英上传脚本
# 使用方法: ./upload_to_pgyer.sh [API_KEY] [BUILD_DESCRIPTION]

set -e

# 配置参数
# 检查第一个参数是否是API Key（长度为32的十六进制字符串）
if [ -n "$1" ] && [ ${#1} -eq 32 ] && [[ "$1" =~ ^[a-f0-9]+$ ]]; then
    # 第一个参数是API Key
    API_KEY="$1"
    BUILD_DESCRIPTION="${2:-自动构建版本}"
    BUILD_PASSWORD="${3:-123321}"
else
    # 使用内置API Key，第一个参数作为描述
    API_KEY="a3edd8799443dafe660b8019c83730af"
    BUILD_DESCRIPTION="${1:-自动构建版本}"
    BUILD_PASSWORD="${2:-123321}"
fi
SCHEME_NAME="AdbidSDKDemo"
WORKSPACE_NAME="../../AdbidSDKWorkspace.xcworkspace"
CONFIGURATION="Release"
ARCHIVE_PATH="./build/AdbidSDKDemo.xcarchive"
IPA_PATH="./build/AdbidSDKDemo.ipa"
EXPORT_OPTIONS_PLIST="./ExportOptions.plist"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

echo_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

echo_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

echo_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查参数
if [ "$API_KEY" = "YOUR_API_KEY_HERE" ]; then
    echo_error "请提供蒲公英API Key"
    echo "使用方法: $0 [API_KEY] [BUILD_DESCRIPTION]"
    echo "注意: 已内置默认API Key，可直接运行 $0"
    exit 1
fi

# 创建构建目录
echo_info "创建构建目录..."
mkdir -p build

# 创建ExportOptions.plist文件
echo_info "创建ExportOptions.plist..."
cat > "$EXPORT_OPTIONS_PLIST" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>development</string>
    <key>compileBitcode</key>
    <false/>
    <key>uploadBitcode</key>
    <false/>
    <key>uploadSymbols</key>
    <false/>
    <key>signingStyle</key>
    <string>automatic</string>
    <key>thinning</key>
    <string>&lt;none&gt;</string>
</dict>
</plist>
EOF

# 清理之前的构建
echo_info "清理之前的构建..."
rm -rf "$ARCHIVE_PATH"
rm -rf "$IPA_PATH"

# 构建Archive
echo_info "开始构建Archive..."
xcodebuild archive \
    -workspace "$WORKSPACE_NAME" \
    -scheme "$SCHEME_NAME" \
    -configuration "$CONFIGURATION" \
    -archivePath "$ARCHIVE_PATH" \
    -destination "generic/platform=iOS" \
    -quiet

if [ ! -d "$ARCHIVE_PATH" ]; then
    echo_error "Archive构建失败"
    exit 1
fi

echo_success "Archive构建完成"

# 导出IPA
echo_info "导出IPA文件..."
xcodebuild -exportArchive \
    -archivePath "$ARCHIVE_PATH" \
    -exportPath "./build" \
    -exportOptionsPlist "$EXPORT_OPTIONS_PLIST" \
    -quiet

if [ ! -f "$IPA_PATH" ]; then
    echo_error "IPA导出失败"
    exit 1
fi

echo_success "IPA导出完成: $IPA_PATH"

# 获取文件大小
FILE_SIZE=$(stat -f%z "$IPA_PATH")
FILE_SIZE_KB=$((FILE_SIZE / 1024))
if [ $FILE_SIZE_KB -lt 1024 ]; then
    echo_info "IPA文件大小: ${FILE_SIZE_KB}KB"
else
    FILE_SIZE_MB=$((FILE_SIZE_KB / 1024))
    echo_info "IPA文件大小: ${FILE_SIZE_MB}MB"
fi

# 第一步：获取上传token
echo_info "获取上传token..."
echo_info "使用API Key: $API_KEY"

# 添加调试信息
echo_info "调试：TOKEN_RESPONSE开始获取..."

TOKEN_RESPONSE=$(curl -s -X POST \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "_api_key=$API_KEY&buildType=ios&buildInstallType=2&buildPassword=$BUILD_PASSWORD&buildDescription=$BUILD_DESCRIPTION" \
    "https://api.pgyer.com/apiv2/app/getCOSToken")

echo_info "调试：TOKEN_RESPONSE = $TOKEN_RESPONSE"

CODE=$(echo "$TOKEN_RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin)['code'])" 2>/dev/null || echo "error")

if [ "$CODE" != "0" ]; then
    echo_error "获取上传token失败"
    echo "$TOKEN_RESPONSE"
    exit 1
fi

# 提取上传参数
KEY=$(echo "$TOKEN_RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin)['data']['key'])")
ENDPOINT=$(echo "$TOKEN_RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin)['data']['endpoint'])")
SIGNATURE=$(echo "$TOKEN_RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin)['data']['params']['signature'])")
TOKEN=$(echo "$TOKEN_RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin)['data']['params']['x-cos-security-token'])")

echo_success "获取上传token成功"

# 第二步：立即上传文件到COS（减少延迟）
echo_info "立即上传IPA文件到蒲公英..."
echo_info "当前时间: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"

# 获取文件名
FILE_NAME=$(basename "$IPA_PATH")

# 使用官方脚本的上传方法
HTTP_CODE=$(curl -o /dev/null -w '%{http_code}' -s \
    --form-string "key=$KEY" \
    --form-string "signature=$SIGNATURE" \
    --form-string "x-cos-security-token=$TOKEN" \
    --form-string "x-cos-meta-file-name=$FILE_NAME" \
    -F "file=@$IPA_PATH" \
    "$ENDPOINT")

# 检查HTTP状态码
echo_info "上传HTTP状态码: $HTTP_CODE"

if [ "$HTTP_CODE" -eq 204 ]; then
    echo_success "文件上传成功"
else
    echo_error "文件上传失败，HTTP状态码: $HTTP_CODE"
    echo_error "这通常表示上传参数有误或token已过期"
    exit 1
fi

# 第三步：等待并检查应用状态
echo_info "文件上传成功，等待蒲公英处理..."

MAX_ATTEMPTS=5
ATTEMPT=0

while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
    ATTEMPT=$((ATTEMPT + 1))
    
    echo_info "检查应用状态 (第 $ATTEMPT 次)..."
    
    # 使用buildKey查询特定构建的状态
    BUILD_INFO_RESPONSE=$(curl -s "https://api.pgyer.com/apiv2/app/buildInfo?_api_key=$API_KEY&buildKey=$KEY")
    
    echo_info "调试：BUILD_INFO_RESPONSE = $BUILD_INFO_RESPONSE"
    
    # 解析构建信息
    BUILD_CODE=$(echo "$BUILD_INFO_RESPONSE" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    print(data.get('code', -1))
except Exception as e:
    print(-1)
" 2>/dev/null || echo "-1")
    
    if [ "$BUILD_CODE" = "0" ]; then
        # 构建处理完成，提取应用信息
        BUILD_INFO=$(echo "$BUILD_INFO_RESPONSE" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    if data['code'] == 0:
        build_data = data['data']
        print(json.dumps({
            'buildName': build_data.get('buildName', 'Unknown'),
            'buildVersion': build_data.get('buildVersion', 'Unknown'),
            'buildShortcutUrl': build_data.get('buildShortcutUrl', '')
        }))
    else:
        print('error')
except Exception as e:
    print('error')
" 2>/dev/null || echo "error")
        
        if [ "$BUILD_INFO" != "error" ]; then
            # 解析应用信息
            BUILD_NAME=$(echo "$BUILD_INFO" | python3 -c "import sys, json; print(json.load(sys.stdin)['buildName'])" 2>/dev/null || echo "Unknown")
            BUILD_VERSION=$(echo "$BUILD_INFO" | python3 -c "import sys, json; print(json.load(sys.stdin)['buildVersion'])" 2>/dev/null || echo "Unknown")
            BUILD_SHORT_URL=$(echo "$BUILD_INFO" | python3 -c "import sys, json; url=json.load(sys.stdin)['buildShortcutUrl']; print('https://www.pgyer.com/' + url if url else 'Unknown')" 2>/dev/null || echo "Unknown")
            
            echo_success "应用上传成功！"
            echo_success "应用名称: $BUILD_NAME"
            echo_success "版本号: $BUILD_VERSION"
            echo_success "下载链接: $BUILD_SHORT_URL"
            echo_success "下载密码: $BUILD_PASSWORD"
            echo_success "二维码: $BUILD_SHORT_URL"
            
            # 清理临时文件
            rm -rf build
            rm -f "$EXPORT_OPTIONS_PLIST"
            
            exit 0
        fi
    else
        echo_info "应用还在处理中，请稍候..."
        sleep 1
    fi
done

echo_error "构建超时，请手动检查蒲公英后台"
exit 1
