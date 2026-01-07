include <BOSL2/std.scad>

// Comb dimensions
neck_width = 19;
pin_width = 1.40;
comb_depth = 4.14;

// Holder dimensions
wall_thickness = 3;
chevron_arm_length = neck_width/2;
chevron_arm_width = 15; // Width between top and bottom arms
holder_height = comb_depth;

$fn = 100;

// Create the >< shaped holder
module comb_holder(multiplier = 1.5, anchor = CENTER, spin = 0, orient = UP) {
  attachable(
    anchor, spin, orient,
    size=[chevron_arm_length * 2, chevron_arm_width, holder_height]
  ) {
    diff() {
      // Main chevron body
      chevron_body();

      // Hole for the pin at the center tip
      attach(FRONT, CENTER, inside=true)
        cyl(h=chevron_arm_width*2, d=multiplier*pin_width);
    }
    children();
  }
}

// Create the >> chevron shape using BOSL2
module chevron_body(anchor, spin, orient) {
  attachable(
    anchor, spin, orient,
    size=[chevron_arm_length * 2, chevron_arm_width, holder_height]
  ) {
    union() {
      // Left chevron arm >
      hull() {
        // Top point of left chevron
        move([-chevron_arm_length, chevron_arm_width / 2, 0])
          cyl(h=holder_height, r=wall_thickness, anchor=CENTER);

        // Center point (tip)
        cyl(h=holder_height, r=wall_thickness, anchor=CENTER);

        // Bottom point of left chevron
        move([-chevron_arm_length, -chevron_arm_width / 2, 0])
          cyl(h=holder_height, r=wall_thickness, anchor=CENTER);
      }

      // Right chevron arm >
      hull() {
        // Center point (tip)
        cyl(h=holder_height, r=wall_thickness, anchor=CENTER);

        // Top point of right chevron
        move([chevron_arm_length, chevron_arm_width / 2, 0])
          cyl(h=holder_height, r=wall_thickness, anchor=CENTER);

        // Bottom point of right chevron
        move([chevron_arm_length, -chevron_arm_width / 2, 0])
          cyl(h=holder_height, r=wall_thickness, anchor=CENTER);
      }
    }
    children();
  }
}

// Render the holder

comb_holder(2);
