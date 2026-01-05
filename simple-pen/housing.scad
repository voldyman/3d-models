include <BOSL2/std.scad>
include <BOSL2/threading.scad>

// ============================================
// MAIN MODEL
// ============================================

module nib_housing(orient, internal = false) {
  // Calculate cumulative positions from bottom

  // Collar/Flange
  collar_width = 0.7;
  collar_diameter = 8.5;

  // Grip section
  grip_length = 2;
  grip_diameter = 8.5;

  // Main cylindrical body
  body_length = 10.5;
  body_diameter = 7.5;

  // Threaded section - M7.4x0.5
  thread_major_diameter = 7.4;
  thread_pitch = 0.5;
  thread_length = 4.4;

  // Step down section
  step_length = 3;
  step_diameter = 6.9;

  // Tail/nipple for cartridge/converter
  tail_length = 4;
  tail_diameter = 2.5;
  collar_z = 0;
  grip_z = collar_z + collar_width;
  body_z = grip_z + grip_length;
  thread_z = body_z + body_length;
  step_z = thread_z + thread_length;
  tail_z = step_z + step_length;

  thread_lead_in_angle = 30.0;
  clearance = 0.2;
  clearance_scale = 1 + (clearance * 2 / collar_diameter);

  scale([clearance_scale, clearance_scale, 1])
    cyl(d=collar_diameter, h=collar_width, orient=orient, anchor=BOTTOM)
      attach(BOT, TOP, overlap=0.1)
        cyl(d=grip_diameter, h=grip_length, anchor=BOTTOM)
          attach(BOT, TOP, overlap=0.1)
            cyl(d=body_diameter, h=body_length, anchor=BOTTOM)
              attach(BOT, TOP, overlap=0.1)
                threaded_rod(
                  d=thread_major_diameter,
                  pitch=thread_pitch,
                  l=thread_length,
                  internal=internal,
                  lead_in_ang=thread_lead_in_angle,
                  anchor=BOTTOM
                )
                  attach(BOT, TOP, overlap=0.1)
                    cyl(d=step_diameter, h=step_length, anchor=BOTTOM)
                      attach(BOT, TOP, overlap=0.1)
                        // cyl(d=internal ? step_diameter : tail_diameter,h=tail_length,anchor=BOTTOM);
                        cyl(d=tail_diameter, h=tail_length, anchor=BOTTOM);

  children();
}
