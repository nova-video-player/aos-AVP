#!/bin/sh

cat top.html > index.html
markdown faq.md > faq.html
cat faq.html >> index.html
cat bottom.html >> index.html
