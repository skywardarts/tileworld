cd ./game-server && npm install -d
echo '============   game-server npm installed ============'
cd ..
cp patches/everyauth/request_main.js web-server/node_modules/everyauth/node_modules/request/main.js
echo '============   everyauth patched ============'