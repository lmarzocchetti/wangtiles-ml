let open_image (filename : string) : Image.image = 
  ImageLib_unix.openfile filename

let save_image (filename : string) (image: Image.image) = 
  ImageLib_unix.writefile filename image

let id r g b = (r, g, b)

let read_pix (image : Image.image) (x : int) (y : int) = 
  Image.read_rgb image x y id

(* List all files which end with ".png" to take the 16 wang tile images and return a list of string of their filename *)
let list_wang_tiles () = 
  Sys.readdir "img/"
  |> Array.to_list
  |> List.filter (fun x -> Filename.extension x = ".png")

(* Create an Hashtbl of string * string, which the key are string of the bitmask and values are the relative paths of the images *)
let create_map () =
  let files = list_wang_tiles () in
  let paths = 
    files
    |> List.map (String.cat "img/")
    |> List.map (open_image)
  in
  let keys =
    files
    |> List.map (String.split_on_char '.')
    |> List.map (List.hd)
  in
  let ret_val = Hashtbl.create 16 in
  List.combine keys paths
  |> List.iter (fun (k, v) -> Hashtbl.add ret_val k v);
  ret_val

let write_tile (tile_width : int) (tile_height : int) (image : Image.image) (tile : Image.image) (posx : int) (posy : int) = 
  for row = 0 to tile_height - 1 do
    for col = 0 to tile_width - 1 do
      let image_row = row + (posy * tile_height) in
      let image_col = col + (posx * tile_width) in
      let (r, g, b) = read_pix tile row col in 
      Image.write_rgb image image_col image_row r g b
    done
  done

let construct_wang_image (grid : string array array) = 
  let map = create_map () in
  let (tile_width, tile_height) = ((Hashtbl.find map "0000").width, (Hashtbl.find map "0000").height) in
  let (output_width, output_height) = (Array.length grid * tile_width, Array.length (grid.(0)) * tile_height) in
  let output_pixmap = Image.create_rgb output_width output_height in 
  let rows = (Array.length grid) - 1 in
  let cols = (Array.length (grid.(0))) - 1 in
  for row = 0 to rows do
    for col = 0 to cols do
      write_tile tile_width tile_height output_pixmap (Hashtbl.find map grid.(row).(col)) row col
    done
  done;
  output_pixmap
