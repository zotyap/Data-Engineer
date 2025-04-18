#!/usr/bin/env bash

dir_path="/home/zotya/de_project/TEST"
mkdir -p $dir_path/sales

for year in {2023..2025};
do
mkdir -p "$dir_path/sales/$year"
	for mon in {01..12};
	do
	date="$year-$mon"
	cat $dir_path/sales.csv | grep "$date" > $dir_path/sales/$year/$mon.csv
	done
done
