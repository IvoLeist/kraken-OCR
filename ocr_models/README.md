
The mlmodels inside this folder will copied into the container 
when building the docker image. This is needed for the OCR command to work, 
as it needs a model to run.

# How to populate this folder with the models 

1. get the model from zenodo by downloading it directly or with kraken `kraken get`
   e.g. `kraken get 10.5281/zenodo.10592716`
   --> this will download the model `catmus-print-fondue-large.mlmodel` 
	along with its metadata into a specific user directory in a folder with a UUID.
	- MacOS: `~/Library/Application Support/kraken/htrmopo`
	- Linux: `~/.local/share/htrmopo/`

2. copy the model to this folder
   e.g. `cp ~/Library/Application\ Support/kraken/htrmopo/<UUID>/catmus-print-fondue-large.mlmodel .`
