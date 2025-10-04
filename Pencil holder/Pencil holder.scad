base_height = 15;
base_spacing = 2;
base_spacing_bottom = 5;
pencil_diameter = 8; // .1
wall_thickness = 1; // .1
pencil_height = 40;
pencil_count = 5;
slice_angle = 80;
bottom_bump_depth = 2;

/* [Hidden] */
$fa = 1;
$fs = 0.4;

// Calculated variables
pencil_holder_diameter = pencil_diameter + wall_thickness * 2;
base_width_top = base_spacing * (pencil_count + 1) + pencil_holder_diameter * pencil_count;
base_depth_top = pencil_holder_diameter + base_spacing;
base_width = base_width_top + base_spacing_bottom * 2;
base_depth = base_depth_top + base_spacing_bottom * 2;

// Base polyhedron
base_points = [
  [  0,  0,  0 ], // 0
  [ base_width,  0,  0 ], // 1
  [ base_width,  base_depth,  0 ], // 2
  [  0,  base_depth,  0 ], // 3
  [ base_spacing_bottom,  base_spacing_bottom,  base_height ], // 4
  [ base_width_top + base_spacing_bottom,  base_spacing_bottom,  base_height ], // 5
  [ base_width_top + base_spacing_bottom,  base_depth_top + base_spacing_bottom,  base_height ], // 6
  [ base_spacing_bottom,  base_depth_top + base_spacing_bottom,  base_height ], // 7
];
base_faces = [
  [0,1,2,3], // Bottom
  [4,5,1,0], // Front
  [7,6,5,4], // Top
  [5,6,2,1], // Right
  [6,7,3,2], // Back
  [7,4,0,3], // Left
];

// Base
difference() {
    polyhedron(base_points, base_faces);
    
    // Remove bottom of each pencil cylinder.
    for (i = [0:pencil_count - 1]) {
        x = holder_r + base_spacing + base_spacing_bottom + (pencil_holder_diameter + base_spacing) * i;
        translate([x, base_depth / 2, base_height]) {
            resize([pencil_diameter, pencil_diameter, bottom_bump_depth  * 2]) {
                sphere(d = pencil_diameter);
            }
        }
    }
}

// Pencil holder module
holder_r = pencil_holder_diameter / 2;
module pencil_holder(i) {
    x = holder_r + base_spacing + base_spacing_bottom + (pencil_holder_diameter + base_spacing) * i;
    
    translate([x, base_depth / 2, base_height - 0.001]) {
        difference() {
            // Outer cylinder.
            cylinder(pencil_height, holder_r, holder_r);  
            
            // Remove inner cylinder.
            // Move down by a fraction to ensure the full height becomes hollow.
            translate([0, 0, -0.001]) {
                cylinder(pencil_height + 0.002, pencil_diameter / 2, pencil_diameter / 2);
            }
            
            // Remove front slice.
            rotate([0, 0, -90 - slice_angle / 2]) {
                rotate_extrude(angle = slice_angle) {
                    // Use relatively large overlap (0.01) here,
                    // so the precision can stay lower (i.e. $fs can stay higher).
                    translate([holder_r - wall_thickness - 0.01, -0.001, 0]) {
                        square([wall_thickness + 0.02, pencil_height + 0.002]);
                    }
                }
            }
        }
    }
}

// Pencil holders
for (i = [0:pencil_count - 1]) {
    pencil_holder(i);
}
