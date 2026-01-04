include <BOSL2/std.scad>
include <BOSL2/threading.scad>

body_d = 12.7;
body_height = 15;

body_thread_d = body_d - 1.5;
body_thread_l = 4;

cap_thread_d = body_thread_d + 0.4;
cap_inner_d = cap_thread_d - 1;
cap_thread_l = body_thread_l * 1.2;

$fn = 100;

// body
module body() {
  diff() {
    cyl(d=body_d, h=body_height, anchor=BOTTOM, rounding2=body_d / 3) {
      attach(TOP, TOP, inside=true, overlap=-1)
        cyl(d=body_thread_d - 2, h=body_height + body_thread_l, rounding2=(body_thread_d - 2) / 3);

      attach(BOTTOM, TOP)
        threaded_rod(d=body_thread_d, l=body_thread_l, pitch=1, lead_in_shape="sqrt");
    }
  }
  children();
}

//cap
module cap() {
  tag_scope("cap_scope")
    diff() {
      cyl(d=body_d, h=body_height, anchor=BOTTOM, rounding2=body_d / 3)
        attach(TOP, TOP, inside=true, overlap=-1)
          cyl(d=cap_inner_d, h=body_height - cap_thread_l, rounding2=cap_inner_d / 3) {
            attach(BOTTOM, BOT, overlap=1)
              threaded_rod(d=cap_thread_d, l=cap_thread_l, pitch=1, lead_in_shape="sqrt", internal=true);
          }
    }
  children();
}

body();
left(20)

  cap();
