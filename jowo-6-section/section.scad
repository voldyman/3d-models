// JoWo #6 Nib Unit Housing (Solid Body Only)
// Based on fpnibs.com specifications
// All dimensions in millimeters

include <BOSL2/std.scad>
include <BOSL2/threading.scad>

// ============================================
// PARAMETERS
// ============================================

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

// Clearance for fit
clearance = 0.2; // mm of radial clearance

// Section wall thickness
section_wall_thickness = 2;

// Thread lead-in angle
thread_lead_in_angle = 30.0;

// Calculate total length for housing
full_length = collar_width + grip_length + body_length + thread_length + step_length + tail_length;

// ============================================
// MAIN MODEL
// ============================================

module nib_housing(internal = false) {
  // Calculate cumulative positions from bottom
  collar_z = 0;
  grip_z = collar_z + collar_width;
  body_z = grip_z + grip_length;
  thread_z = body_z + body_length;
  step_z = thread_z + thread_length;
  tail_z = step_z + step_length;

  union() {
    // 1. Collar/Flange
    translate([0, 0, collar_z])
      cyl(d=collar_diameter, h=collar_width, anchor=BOTTOM);

    // 2. Grip section
    translate([0, 0, grip_z])
      cyl(d=grip_diameter, h=grip_length, anchor=BOTTOM);

    // 3. Main body
    translate([0, 0, body_z])
      cyl(d=body_diameter, h=body_length, anchor=BOTTOM);

    // 4. Threaded section (BOSL2)
    translate([0, 0, thread_z])
      threaded_rod(
        d=thread_major_diameter,
        pitch=thread_pitch,
        l=thread_length,
        internal=internal,
        lead_in_ang=thread_lead_in_angle,
        anchor=BOTTOM
      );

    // 5. Step-down section
    translate([0, 0, step_z])
      cyl(d=step_diameter, h=step_length, anchor=BOTTOM);

    // 6. Tail nipple
    translate([0, 0, tail_z])
      cyl(
        d=internal ? step_diameter : tail_diameter,
        h=tail_length,
        anchor=BOTTOM
      );
  }

  children();
}

module nib_section() {
  clearance_scale = 1 + (clearance * 2 / collar_diameter);

  difference() {
    cyl(d=collar_diameter + section_wall_thickness, h=full_length, anchor=BOTTOM);
    // Scale the internal cavity slightly larger for clearance
    scale([clearance_scale, clearance_scale, 1])
      nib_housing(internal=true);
  }
  children();
}

// ============================================
// RENDER
// ============================================

// Render mode: "both", "housing", "section"
render_mode = "both";
if (render_mode != "none") {
  // Resolution
  $fn = 100;
}
if (render_mode == "both" || render_mode == "housing") {
  nib_housing(internal=false);
}

if (render_mode == "both" || render_mode == "section") {
  left(20) {
    nib_section();
  }
}
