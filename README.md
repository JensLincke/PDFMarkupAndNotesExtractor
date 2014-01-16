# PDFMarkupAndNotesExtractor

Shell script, that extracts the markup and notes of PDFs using, Apple's "Preview" Application and AppleScript

This script uses "Preview" to extract the annotations and notes of pdf files into a text file
Since there is no public API for extracting the annotations, it scraps them from the UI of "Preview"

NOTE: you will be asked to grand the "Terminal" the right to control your computer 
       and you have to allow this in your systems settings

WARNING: For this reason, the script might have to be adapted for every future version of "Preview", until there will be a stable API for accessing the notes and markup.


## Related Work

Apple Automator allows to extract the annotations of a PDF, but it only gives you your own note and the position and color of the annation, but not the actual content of what you marked. This limitation might be due to copyright reasons, but this is not clear. 

Skim, a PDF annotation programm, provides similar extraction facilities, but only for notes taken with itself. It allows to convert existing annotations from "Preview", but the converted annotations do not contain the marked up text. 

## Copyright 
under MIT License (MIT)
Copyright (c) 2014 Jens Lincke
