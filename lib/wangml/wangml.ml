(* Type of a tile's part *)
type color = Zero | One

(* Type of a Wang tile *)
type tile = Tile of {north: color; south: color; east: color; west: color} | Empty

exception OutOfBound of string

(* Generate a random Color *)
let random_gen (x : unit) : color = 
  let _ = x in
  Random.self_init ();
  match Random.int 2 with
    | 1 -> One
    | _ -> Zero

(* Generate the initial Array with all Empty *)
let generate_grid
    (dimx : int) (dimy : int) : tile array array =
    let arr = Array.make_matrix dimx dimy Empty in
    arr

(* Set a Tile in position: posx posy
   raise OutOfBound exception if the posx or posy are out of bound *)
let set_tile_at (grid : tile array array) (new_tile : tile) (posx : int) (posy : int) =
  if 
    posx >= Array.length grid ||
    posx < 0 ||
    posy >= Array.length (grid.(0)) ||
    posy < 0
  then
    raise (OutOfBound "Index out of bound")
  else
    grid.(posx).(posy) <- new_tile

(* Construct a tile based of optional color, that indicate if in a specific direction is present or not a tile and
   if yes then we're constrained by the color that the function received in input
   if not then we can choose a random color *)
let construct_tile
  (north : color option) (south : color option) (east : color option) (west : color option) : tile = 
  let n = 
    match north with
    | Some a -> a
    | None -> random_gen ()
  in
  let s = 
    match south with
    | Some a -> a
    | None -> random_gen ()
  in
  let e = 
    match east with
    | Some a -> a
    | None -> random_gen ()
  in
  let w = 
    match west with
    | Some a -> a
    | None -> random_gen ()
  in
  Tile {north = n; south = s; east = e; west = w}

(* Match the 4 tiles neighbors and construct a new tile *)
let match_tile (upper : tile) (lower : tile) (right: tile) (left : tile) : tile =
  let (n : color option) = match upper with
  | Empty -> None
  | Tile {north = _; south; east = _; west = _} -> Some south in
  let (s : color option) = match lower with
  | Empty -> None
  | Tile {north; south = _; east = _; west = _} -> Some north in
  let (e : color option) = match right with
  | Empty -> None
  | Tile {north = _; south = _; east = _; west} -> Some west in
  let (w : color option) = match left with
  | Empty -> None
  | Tile {north = _; south = _; east; west = _} -> Some east in
  construct_tile n s e w

(* Fill the Array with the Wang tile algorithm *)
let fill_grid (grid : tile array array) =
  let rows = (Array.length grid) - 1 in
  let cols = (Array.length (grid.(0))) - 1 in
  for row = 0 to rows do
    for col = 0 to cols do
      match grid.(row).(col) with
      | Empty ->
        (match (row, col) with
        (* The four angles *)
        | (0, 0) -> grid.(0).(0) <- match_tile Empty (grid.(1).(0)) (grid.(0).(1)) Empty
        | (x, y) when x = rows && y = cols -> grid.(x).(y) <- match_tile (grid.(x - 1).(y)) Empty Empty (grid.(x).(y - 1))
        | (0, y) when y = cols -> grid.(0).(y) <- match_tile Empty (grid.(1).(y)) Empty (grid.(0).(y - 1))
        | (x, 0) when x = rows -> grid.(x).(0) <- match_tile (grid.(x - 1).(0)) Empty (grid.(x).(1)) Empty
        (* The four sides *)
        | (x, 0) -> grid.(x).(0) <- match_tile (grid.(x - 1).(0)) (grid.(x + 1).(0)) (grid.(x).(1)) Empty
        | (0, y) -> grid.(0).(y) <- match_tile Empty (grid.(1).(y)) (grid.(0).(y + 1)) (grid.(0).(y - 1))
        | (x, y) when y = cols -> grid.(x).(y) <- match_tile (grid.(x - 1).(y)) (grid.(x + 1).(y)) Empty (grid.(x).(y - 1))
        | (x, y) when x = rows -> grid.(x).(y) <- match_tile (grid.(x - 1).(y)) Empty (grid.(x).(y + 1)) (grid.(x).(y - 1))
        (* Internal *)
        | (x, y) -> grid.(x).(y) <- match_tile (grid.(x - 1).(y)) (grid.(x + 1).(y)) (grid.(x).(y + 1)) (grid.(x).(y - 1)))
      | _ -> ()
    done
  done

let color_to_bit (color : color) : string = 
  match color with
  | Zero -> "0"
  | One -> "1"

let tile_to_bitmask (tile : tile) : string =
  match tile with
  | Tile {north; south; east; west} -> 
    north :: south :: east :: west :: []
    |> List.map color_to_bit
    |> String.concat ""
  | Empty -> ""

let convert_to_bitmask (grid : tile array array) = 
  grid
  |> Array.map (Array.map tile_to_bitmask)

(* Return a string based by the color, only for internal usage *)
let show_color col =
  match col with
  | Zero -> "0"
  | One -> "1"

(* Prints to stdout a Tile, only for internal usage *)
let show_tile (tile) : unit =
  match tile with
  | Tile {north: color; south: color; east: color; west: color} 
      -> Printf.printf "[N: %s; S: %s; E: %s; W: %s]\n"
          (show_color north)
          (show_color south)
          (show_color east)
          (show_color west)
  | Empty -> print_endline "Empty"

(* Prints to stdout a Grid full of tile *)
let show (grid : tile array array) : unit =
  Array.iter (fun x -> 
    Array.iter show_tile x;
    print_newline ()
  ) grid