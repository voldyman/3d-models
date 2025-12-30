include <BOSL2/std.scad>

$fn = 36;

/////////
// Goal dimensions
BOARD_WIDTH = 38.60;
DEFAULT_ROUNDING = 2;

pp_stand_clip_d = 20;
pp_stand_clip_h = 20;
pp_stand_clip_w = 40;

pp_stand_base_w = pp_stand_clip_w;
pp_stand_base_h = 15;
pp_stand_base_d = BOARD_WIDTH + 2 * pp_stand_clip_d;

pp_stand_nub_r = pp_stand_base_w / 16;
////////
module stand_clip(size, anchor = CENTER, spin = 0, orient = UP) {
  let (
    size = force_list(size, 3),
    check = assert(is_vector(size, 3) && all_positive(size), "\nsize must be a positive scalar or 3-vector."),
    width = size[0],
    thickness = size[1],
    height = size[2]
  )
  tag_scope() {
    diff() {
      wedge(size, spin=spin, anchor=anchor, orient=orient) {
        attach("top_edge", FWD + LEFT, inside=true) {
          rounding_edge_mask(r=DEFAULT_ROUNDING, l=$edge_length + 1);
        }
        attach(["hypot_right", "hypot_left"], FWD + LEFT, inside=true) {
          rounding_edge_mask(r=DEFAULT_ROUNDING, l=width);
        }
        attach([FRONT + LEFT, FRONT + RIGHT], FWD + LEFT, inside=true) {
          rounding_edge_mask(r=DEFAULT_ROUNDING, l=height);
        }
      }
      children();
    }
  }
}

module stand_base(size, top_rounding_w = 0, anchor = CENTER, spin = 0, orient = UP) {
  cuboid(size, rounding=DEFAULT_ROUNDING, anchor=anchor, spin=spin, orient=orient, except=[TOP]) {
    children();
  }
}

stand_base([pp_stand_base_w, pp_stand_base_d, pp_stand_base_h], pp_stand_clip_w) {
  attach(TOP, BOT, align=BACK, spin=0) {
    stand_clip([pp_stand_clip_w, pp_stand_clip_d, pp_stand_clip_h]);
  }
  attach(TOP, BOT, align=FORWARD, spin=180) {
    stand_clip([pp_stand_clip_w, pp_stand_clip_d, pp_stand_clip_h]);
  }
  attach(TOP, TOP, align=CENTER, overlap=pp_stand_nub_r) {
    spheroid(r=pp_stand_nub_r, style="octa");
  }
  attach(BOT, TOP, align=[FORWARD, BACK], inset=pp_stand_base_d / 8, overlap=4) {
    cuboid([pp_stand_base_w, pp_stand_base_d / 8, pp_stand_base_h / 2], rounding=DEFAULT_ROUNDING);
  }
}
