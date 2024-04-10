# wangtiles-ml
Wang Tiles generator in Ocaml

![output](https://github.com/lmarzocchetti/wangtiles-ml/assets/61746163/8e721b61-20cd-4b1a-9082-84d8028d72cd)

## Prerequisites
You need to install in the current opam switch these libraries:
```
$ opam install imagelib
```

## Build
Simply launch this command:
```
dune build --profile=release
```

## Execute
You need to have in the same folder of the executable an "img/" folder.
In this "img/" folder must be there 16 png files with this pattern:
```
NSEW.png -> N | S | E | W = 0 | 1
```
0 and 1 are to say that a direction (North, South, East, West) are color 0 or color 1.
See the "img/" folder included in this project!

After that simply launch the executable:
```
$ ./_build/install/default/bin/wangml -width 20 -height 20 -output output
```
or (if you have moved the executable in the same folder of "img/"):
```
$ ./wangml -width 20 -height 20 -output output
```

### Further updates
- [x] Compute the generation and save it to an output file
- [ ] Use Raylib to write a GUI in which the User can choose the position and a specific tile to starting the generation

### Contributes 
Thanks to Tsoding for the atlas that he generates: [wang-tiles](https://github.com/tsoding/wang-tiles)
