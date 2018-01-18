#! /bin/bash
gcloud compute --project "infra-189307" \
	instances create "reddit-app" \
	--zone "europe-west1-b" \
	--machine-type "f1-micro" \
	--image-family "reddit-full" \
	--tags puma-server
