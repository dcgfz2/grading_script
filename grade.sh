#!/bin/bash

unzip sampleInput.zip -d sampleInput
unzip expectedOutput.zip -d expectedOutput
unzip submissions.zip -d submissions

for file in submissions/*
do
	testcounter=0
	correctcounter=0
	cheattrigger=0
	for sample in sampleInput/*
	do
		swipl $file $(cat $sample) > a_$(basename $sample).out
		if diff a_$(basename $sample).out expectedOutput/$(basename $sample).out -b -B >/dev/null;
		then
			correctcounter=$((correctcounter+1))
			if grep -F $(cat expectedOutput/$(basename $sample).out) $file >/dev/null;then
			cheattrigger=1	
			fi
		fi
		
		testcounter=$((testcounter+1))
	done
	grade=$((100*$correctcounter/$testcounter))
	submitted=$(basename $file)
	submitter=${submitted%.*}
	if [ "$cheattrigger" = 1 ];then
		echo "$submitter, $grade*" >> grades.txt
	else	
		echo "$submitter, $grade" >> grades.txt
	fi
done 