# LABEL GENERATOR

this simple tool will generate labels based on csv data.
It takes a table of data from wich each row corresponds to a label.
In the HTML template, you define where the values of the row should be inserted.
The resulting html page just stacks all labels with inserted values horizontally.
This page can then simply be printed to paper and cut out :)

Ideal for:
- Business-Cards
- Labels with QR-Codes (When printed on sticky paper f.Ex.)

example template:
```
./label.ps1 ./example/label.html ./example/names.csv > ./result.html
```

then open the ./result.html in the browser