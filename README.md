# select-rectangle package [![Build Status](https://travis-ci.org/hmatsuda/select-rectangle.svg?branch=master)](https://travis-ci.org/hmatsuda/select-rectangle) [![Build status](https://ci.appveyor.com/api/projects/status/ocqrj3udf4ta6oky/branch/master)](https://ci.appveyor.com/api/projects/status/ocqrj3udf4ta6oky/branch/master)
![A screenshot of your spankin' package](http://cl.ly/image/3I2C2k232e10/select-rectangle.gif)

## Installation
```sh
apm install select-rectangle
```
or find it in the Packages tab under settings

## Usage
### Select `alt-s`
At first, select region that you want to do.
Next, press `alt-s` to select rectangle region. if repeating the `alt-s` would go back to the initial selection.
After that, You can copy, cut or following actions. 

### Clear `alt-cmd-c`
After selecting rectangle region by `alt-s`, `alt-cmd-c` clears the region-rectangle by replacing all of its contents with spaces.

### Open `alt-cmd-o`
After selecting rectangle region by `alt-s`, `alt-cmd-o` inserts blank space to fill the space of the region-rectangle (open-rectangle). This pushes the previous contents of the region-rectangle to the right. 
