#!/bin/bash

source_folder=/data/inidun/courier/tm/v0.2.0
storage_type=zip

./scripts/copy-tm-model --source-folder ${source_folder}/tm_courier_v0.2.0_100-TF5-MP0.02-500000-lc.gensim_mallet-lda --storage-type $storage_type --target-name tm-100-v1.0-lowercase --force
./scripts/copy-tm-model --source-folder ${source_folder}/tm_courier_v0.2.0_200-TF5-MP0.02-500000-lc.gensim_mallet-lda --storage-type $storage_type --target-name tm-200-v1.0-lowercase --force
./scripts/copy-tm-model --source-folder ${source_folder}/tm_courier_v0.2.0_500-TF5-MP0.02-500000-lc.gensim_mallet-lda --storage-type $storage_type --target-name tm-500-v1.0-lowercase --force
./scripts/copy-tm-model --source-folder ${source_folder}/tm_courier_v0.2.0_50-TF5-MP0.02-500000-lc.gensim_mallet-lda --storage-type $storage_type --target-name  tm-050-v1.0-lowercase --force

# tm_courier_v0.2.0_100-TF5-MP0.02-500000.lemma.mallet.gensim_mallet-lda v0.2.0_100-TF5-MP0.02-500000.lemma.mallet.gensim_mallet-lda
# tm_courier_v0.2.0_200-TF5-MP0.02-500000.lemma.mallet.gensim_mallet-lda v0.2.0_200-TF5-MP0.02-500000.lemma.mallet.gensim_mallet-lda
# tm_courier_v0.2.0_500-TF5-MP0.02-500000.lemma.mallet.gensim_mallet-lda v0.2.0_500-TF5-MP0.02-500000.lemma.mallet.gensim_mallet-lda
# tm_courier_v0.2.0_50-TF5-MP0.02-500000.lemma.mallet.gensim_mallet-lda v0.2.0_50-TF5-MP0.02-500000.lemma.mallet.gensim_mallet-lda
