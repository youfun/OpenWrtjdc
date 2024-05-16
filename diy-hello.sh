sed -i "/helloworld/d" "feeds.conf.default"
echo "src-git helloworld https://github.com/fw876/helloworld.git" >> "feeds.conf.default"

./scripts/feeds update helloworld
./scripts/feeds install -a -f -p helloworld

rm -fr bin/ dl/ staging_dir/ build_dir/ tmp/
