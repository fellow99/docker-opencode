VERSION_OPENCODE=1.3.17
VERSION_OPENCLAW=2026.4.8

docker builder prune -f
docker build -t fellow99/playwright-vnc:latest -f Dockerfile-playwright-vnc .
docker build -t fellow99/playwright-sdkman:latest -f Dockerfile-playwright-sdkman .
docker build -t fellow99/opencode-aio:$VERSION_OPENCODE -f Dockerfile-opencode-aio --build-arg VERSION_OPENCODE=$VERSION_OPENCODE .
docker build -t fellow99/opencode-openclaw:$VERSION_OPENCODE-$VERSION_OPENCLAW -f Dockerfile-opencode-openclaw --build-arg VERSION_OPENCODE=$VERSION_OPENCODE --build-arg VERSION_OPENCLAW=$VERSION_OPENCLAW .

docker push fellow99/playwright-vnc:latest
docker push fellow99/playwright-sdkman:latest
docker push fellow99/opencode-aio:$VERSION_OPENCODE
docker push fellow99/opencode-openclaw:$VERSION_OPENCODE-$VERSION_OPENCLAW

docker save fellow99/playwright-vnc:latest > fellow99_playwright-vnc_latest.tar
docker save fellow99/playwright-sdkman:latest > fellow99_playwright-sdkman_latest.tar
docker save fellow99/opencode-aio:$VERSION_OPENCODE > fellow99_opencode-aio_$VERSION_OPENCODE.tar
docker save fellow99/opencode-openclaw:$VERSION_OPENCODE-$VERSION_OPENCLAW > fellow99_opencode-openclaw_$VERSION_OPENCODE-$VERSION_OPENCLAW.tar

gzip fellow99_playwright-vnc_$VERSION.tar
gzip fellow99_playwright-sdkman_latest.tar
gzip fellow99_opencode-aio_$VERSION_OPENCODE.tar
gzip fellow99_opencode-openclaw_$VERSION_OPENCODE-$VERSION_OPENCLAW.tar
