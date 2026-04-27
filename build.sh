VERSION_DEV_IN_ONE=20260426
VERSION_OPENCODE=1.14.25

docker builder prune -f
docker build -t fellow99/dev-in-one:$VERSION_DEV_IN_ONE -f Dockerfile-dev-in-one .
docker build -t fellow99/dev-playwright:$VERSION_DEV_IN_ONE -f Dockerfile-dev-playwright --build-arg VERSION_DEV_IN_ONE=$VERSION_DEV_IN_ONE .
docker build -t fellow99/dev-opencode:$VERSION_OPENCODE -f Dockerfile-dev-opencode --build-arg VERSION_DEV_IN_ONE=$VERSION_DEV_IN_ONE --build-arg VERSION_OPENCODE=$VERSION_OPENCODE .

docker push fellow99/dev-in-one:$VERSION_DEV_IN_ONE
docker push fellow99/dev-playwright:$VERSION_DEV_IN_ONE
docker push fellow99/dev-opencode:$VERSION_OPENCODE

docker save fellow99/dev-in-one:$VERSION_DEV_IN_ONE > fellow99_dev-in-one_$VERSION_DEV_IN_ONE.tar
docker save fellow99/dev-playwright:$VERSION_DEV_IN_ONE > fellow99_dev-playwright_$VERSION_DEV_IN_ONE.tar
docker save fellow99/dev-opencode:$VERSION_OPENCODE > fellow99_dev-opencode_$VERSION_OPENCODE.tar

gzip fellow99_dev-in-one_$VERSION_DEV_IN_ONE.tar
gzip fellow99_dev-playwright_$VERSION_DEV_IN_ONE.tar
gzip fellow99_dev-opencode_$VERSION_OPENCODE.tar
