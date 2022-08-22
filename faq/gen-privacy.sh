#!/bin/sh

cat top-privacy.html > privacy.html
markdown privacy.md >> privacy.html
cat bottom.html >> privacy.html
