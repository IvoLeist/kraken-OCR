build-linux-image:
	docker buildx build \
  	-f Dockerfile.minimal \
  	--progress=plain \
  	-t kraken-ocr:7.0 \
  	--load \
  	.

build-linux-image-no-cache:
	docker buildx build \
  	-f Dockerfile.minimal \
  	--progress=plain \
  	-t kraken-ocr:7.0 \
  	--load \
  	--no-cache \
  	.