#!/bin/bash

rm -rf reuters
mkdir reuters

cd reuters

mkdir lda_perxtest

cd ..

cd ../src

make clean
make

./src_lda 	-g \
		 	-out=../tests/reuters \
		 	-ks=../data/reuters/ks.dat \
		 	-P=7 | tee ../tests/reuters/output.log


# From K = 1 to 300, grid search for the optimal K range
optimal_K=-1
for K in {80..120..10};do
	if [[ optimal_K -ne -1 ]]; then
		K=$optimal_K
	fi
	echo ============================================================================
	echo "   K = $K - LDA"
	echo ============================================================================

	./src_lda 	-out=../tests/reuters/lda_perxtest \
			 	-I=300 \
			 	-in=../data/reuters/input.dat \
			 	-K=$K \
			 	-alg=lda | tee ../tests/reuters/lda_perxtest/output.log \
			 	-perp=lr

done
