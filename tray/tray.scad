include <BOSL2/std.scad>

$fn = 100;

buffer = 0.7;
eye_drops_radius = (21.5 + buffer) / 2;
earphones_diameter = 65.2 + buffer;
earphones_radius = earphones_diameter / 2;
wall_thickness = 2;

// Tray dimensions
tray_width = earphones_diameter * 2 + wall_thickness * 2;
tray_depth = earphones_diameter * 2 + wall_thickness * 6;
tray_height = 10;

// Grid dimensions
rows = 2;
cols = 2;
cell_width = (tray_width - wall_thickness * 2) / cols;
cell_depth = (tray_depth - wall_thickness * 2) / rows;

diff() {
  // Outer shell
  cuboid([tray_width, tray_depth, tray_height], rounding=2, edges="Z") {

    // earphones holder cell
    attach(TOP, TOP, align=LEFT, inside=true, overlap=wall_thickness, inset=wall_thickness * 2)
      back(earphones_radius + wall_thickness)
        cyl(h=tray_height, r=earphones_radius, rounding=2, anchor=TOP) attach(TOP, TOP, inside=true) rounding_hole_mask(r=earphones_radius, rounding=2);

    
    // eye drops cell
    attach(TOP, TOP, align=RIGHT, inside=true, overlap=wall_thickness, inset=wall_thickness * 2)
      back(earphones_radius + wall_thickness) right(tray_width / 4 - wall_thickness * 2 - eye_drops_radius)
          cyl(h=tray_height, r=eye_drops_radius, rounding=2, anchor=TOP) attach(TOP, TOP, inside=true) rounding_hole_mask(r=eye_drops_radius, rounding=2);

    
    // Merged bottom row
    attach(TOP, TOP, align=FWD, inside=true, overlap=wall_thickness, inset=wall_thickness) {
      cuboid(
        [

          tray_width - wall_thickness * 2,
          cell_depth - wall_thickness,
          tray_height,
        ], rounding=2, anchor=TOP
      ) {
        edge_mask(TOP)
          chamfer_edge_mask(chamfer=2.5);
        corner_mask(TOP) chamfer_edge_mask(chamfer=0.5, l=3);
      }
    }
    edge_mask(TOP)
      chamfer_edge_mask(chamfer=0.5);
  }
}
