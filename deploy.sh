#!/bin/bash

command -v lftp >/dev/null 2>&1 || { echo >&2 "LFTP is required."; exit 1; }
test -f ".environment" || { echo ".environment is required."; exit; }

source '.environment';

test ! -z "$FTP_USER" || { echo "FTP_USER variable is required."; exit; }
test ! -z "$FTP_PASSWORD" || { echo "FTP_PASSWORD variable is required."; exit; }
test ! -z "$$HOST" || { echo "$HOST variable is required."; exit; }

echo "Deployment started";

echo "Pulling latest source"
# git pull origin >/dev/null 2>&1

echo "Building application"
yarn build >/dev/null 2>&1

echo "Uploading"
lftp << EOF

set ssl:verify-certificate no;
open -u $FTP_USER,$FTP_PASSWORD $HOST

rm -rf /domains/$HOST/public_html/q3/font
rm -rf /domains/$HOST/public_html/q3/js
rm -rf /domains/$HOST/public_html/q3/style
rm -rf /domains/$HOST/public_html/q3/index.html
rm -rf /domains/$HOST/public_html/q3/sw.js
rm -rf /domains/$HOST/public_html/q3/sw.js.gz

mirror -R build/ /domains/$HOST/public_html/q3

EOF

echo "Deployment finished";