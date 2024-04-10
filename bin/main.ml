let usage_msg = "wangml -width <width> -height <height> -output <output_filename>"

let input_width = ref 0
let input_height = ref 0
let output_filename = ref ""

let speclist = 
  [("-width", Arg.Set_int input_width, "Set width of the output image");
   ("-height", Arg.Set_int input_height, "Set height of the output image");
   ("-output", Arg.Set_string output_filename, "Set output image path")]

let control_arguments () = 
  match !input_width with
  | 0 -> failwith "Insert a non zero width value!"
  | _ -> ();
  
  match !input_height with
  | 0 -> failwith "Insert a non zero height value!"
  | _ -> ();

  match !output_filename with
  | "" -> failwith "Insert an output filename!"
  | _ -> ()

let () = 
  Arg.parse speclist (fun _ -> ()) usage_msg;
  control_arguments ();

  let open Wangml in
  let tl = construct_tile None None None None in
  let grid = generate_grid
    !input_width
    !input_height
  in
  set_tile_at grid tl 0 0;
  fill_grid grid;
  let grid = convert_to_bitmask grid in
  let img = Utility.construct_wang_image grid in
  Utility.save_image (String.cat !output_filename ".png") img

(* let () =
  let open Wangml in
  let dimx = 20 in 
  let dimy = 20 in
  let tl = Tile {north = One; south = One; east = One; west = One} in
  let grid = generate_grid
    dimx
    dimy
  in
  set_tile_at grid tl 0 0;
  fill_grid grid;
  let grid = convert_to_bitmask grid in
  let img = Utility.construct_wang_image grid in
  Utility.save_image "output.png" img *)