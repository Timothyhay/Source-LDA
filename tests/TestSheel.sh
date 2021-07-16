#!/bin/bash

rm -rf reuters
mkdir reuters

cd reuters

mkdir ctm
mkdir src
mkdir lda
mkdir perp_src

cd ..

cd ../src

make clean
make

./src_lda 	-g \
		 	-out=../tests/reuters \
		 	-ks=../data/reuters/ks.dat \
		 	-P=7 | tee ../tests/reuters/output.log


searchCase=1
for unlabeledTopics in {80..120..10};do
	if [[ optimal_K -ne -1 ]]; then
		K=$optimal_K
	fi
	echo =============================================================
	echo "   Case $searchCase : K = $unlabeledTopics - Source-LDA" > ../tests/reuters/perp_src/output.log 
	echo =============================================================

	./src_lda 	-out=../tests/reuters/perp_src \
			 	-I=300 \
			 	-in=../data/reuters/input.dat \
			 	-ks=../data/reuters/ks.dat \
			 	-K=$unlabeledTopics \
			 	-model=src \
			 	-alg=src \
			 	-mu=0.7 \
			 	-P=7 \
			 	-A=25 \
			 	-perp=imp \
			 	-gt=../tests/reuters/gt.dat \
			 	-sigma=0.3 | tee -a ../tests/reuters/perp_src/output.log 

	let ++searchCase
done

exit 0