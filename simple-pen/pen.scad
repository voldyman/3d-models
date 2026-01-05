include <BOSL2/std.scad>
include <BOSL2/threading.scad>
include <./housing.scad>

body_l = 81.9;
body_d = 13.1;

cap_d = 14.9;
cap_l = 66.74;
cap_clip_l = 41;

section_d = 11.87;
section_l = 19.89;

section_thread_l = 8.95;
section_thread_d = 8.95;
section_thread_pitch = section_thread_l / 10;
section_thread_base_d = 8.4;

section_inner_d = section_thread_d - 2;

body_outer_thread_d = body_d - 0.5;
body_outer_thread_l = 3;
body_outer_thread_pitch = 1;

body_inner_cyl_d = body_d - (1.5 * 2);
body_inner_cyl_l = body_l + body_outer_thread_l - section_thread_l;

//$fn = 100;

assert(section_d < body_outer_thread_d, "body outer threads should be bigger than section to fit in the cap");
module body(anchor, orient) {

  module body_outer_cyl() {
    cyl(d=body_d, h=body_l, rounding2=body_d / 3, anchor=anchor, orient=orient) {
      attach(BOT, TOP)
        threaded_rod(d=body_outer_thread_d, l=body_outer_thread_l, pitch=body_outer_thread_pitch, lead_in_shape="smooth", lead_in=body_outer_thread_d) {

          children();
        }
    }
  }
  diff() {
    body_outer_cyl()
      attach(BOT, BOT, inside=true, overlap=1)
        threaded_rod(d=section_thread_d + 0.5, l=section_thread_l, pitch=section_thread_pitch, lead_in_shape="smooth", internal=true)
          attach(TOP, BOT, overlap=1)
            cyl(d=body_inner_cyl_d, h=body_inner_cyl_l, rounding2=body_inner_cyl_d / 3);
  }
  children();
}

module cap(anchor, orient) {
  diff()
    cyl(d=cap_d, h=cap_l, rounding2=cap_d / 3, anchor=anchor, orient=orient) {
      attach(BOT, BOT, inside=true, overlap=1)
        threaded_rod(d=body_outer_thread_d + 0.5, l=body_outer_thread_l * 2.5, pitch=body_outer_thread_pitch, lead_in_shape="smooth", lead_in=body_outer_thread_d, end_len1=2, internal=true)
          attach(TOP, BOT)
            cyl(d=body_outer_thread_d, h=cap_l - body_outer_thread_l * 4, rounding2=body_outer_thread_d / 3);

      children();
    }
}

module section(anchor, orient) {

  diff() {
    cyl(d=section_d, h=section_l, anchor=anchor, orient=orient) {
      attach(TOP, TOP, inside=true, overlap=0.1)
        nib_housing(internal=true);
      attach(BOT, TOP)
        threaded_rod(d=section_thread_d, l=section_thread_l, pitch=section_thread_pitch, lead_in_shape="smooth", end_len=section_thread_l / 6);
      attach(TOP, TOP, inside=true, overlap=1)
        cyl(d=section_inner_d-1, l=section_l + section_thread_l + 1);
    }
  }

  children();
}

module assembled() {
  body(orient=BACK);
  zrot(180) back(cap_l + 6) cap(orient=BACK);
  fwd(section_l * 2.752) zrot(180) section(orient=BACK);
  children();
}

module for_print() {
  $fn = 100;
  body(anchor=BOT);
  left(40) cap(anchor=BOT);
  left(80) section(anchor=BOT);
}

render_mode = "none";
mode = "for_print";
//mode = "assembled";
//mode = "housing";
//mode="section";

if (mode == "for_print") {
  for_print();
} else if (mode == "section") {
  projection(cut=true)
    section(orient=BACK);
} else if (mode == "housing") {
  projection(cut=true)
    diff()
      cyl(l=section_l + 3, d=section_d, orient=BACK)
        attach(TOP, TOP, inside=true, overlap=0.1)
          nib_housing();
} else if (mode == "assembled") {
  projection(cut=true) {
    assembled();
  }
}
