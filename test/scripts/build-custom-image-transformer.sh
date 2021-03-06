#!/bin/bash

# Copyright 2019 The Kubeflow Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This shell script is used to build an image from our argo workflow

set -o errexit
set -o nounset
set -o pipefail

export PATH=${GOPATH}/bin:/usr/local/go/bin:${PATH}
REGISTRY="${GCP_REGISTRY}"
PROJECT="${GCP_PROJECT}"
IMAGE_TRANSFOMER_DIR="docs/samples/transformer/image_transformer/"
VERSION=$(git describe --tags --always --dirty)

echo "Activating service-account ..."
gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}

echo "Building and pushing image-transfomer ..."
cd ${IMAGE_TRANSFOMER_DIR}
cp transformer.Dockerfile Dockerfile
gcloud builds submit . --tag=${REGISTRY}/${REPO_NAME}/image-transformer:${VERSION} --project=${PROJECT}
gcloud container images add-tag --quiet ${REGISTRY}/${REPO_NAME}/image-transformer:${VERSION} ${REGISTRY}/${REPO_NAME}/image-transformer:latest --verbosity=info
