// The dimensions of the tablet.
tablet_height = 170;
tablet_thickness = 7;

// The dimensions of the holder's top and bottom segments.
bottom_width = 169;
top_width = 120;

// The height (depth) of the groove lip
groove_height = 3;
// The thickness of the groove lip, front and back.
groove_thickness = 3;
groove_thickness_back = 1;

// The amount of material below and above the tablet in the groove.
bottom_thickness = 4;
top_thickness = 4;

// The size of the supports on the back.
support_thickness = 3;
support_width = 25;

// The size of the angle plug
angle_plug_thickness = 10;
angle_plug_width= 17;
// The height of the top angled part of the plug.
angle_plug_top_height = 15;
// The size of the bottom straight part of the plug.
angle_plug_bottom_height = 8;
angle_plug_bottom_width = 12;

// The size of the cable going up to the angle plug.
cable_thickness = 7;
cable_width = 13;

// How much material to keep left of angle plug.
angle_plug_left = 3;

// Diameter of the screw holes.
screw_hole_size = 4;
// Distance from the sides to the screw holes on the vertical support.
screw_hole_distance = 10;

/* [Hidden] */

$fn = 32;

total_thickness = support_thickness + groove_thickness_back + tablet_thickness + groove_thickness;
total_height = bottom_thickness + tablet_height + top_thickness;
inner_height = tablet_height - groove_height * 2;
top_height = groove_height + top_thickness;
bottom_height = groove_height + bottom_thickness;
left_width = angle_plug_width + angle_plug_left;
angle_plug_height = angle_plug_top_height + angle_plug_bottom_height;

difference() {
    // Main body.
    union() {
        left();
        bottom();
        top();
    }
    plug();
}

// Supports.
translate([0, total_thickness - support_thickness, bottom_height]) {
    top_right = left_width + top_width - support_width;
    bottom_right = left_width + bottom_width;

    // Straight up.
    translate([top_right - support_width, 0, 0]) {
        difference() {
            cube([support_width, support_thickness, inner_height]);
            translate([support_width / 2, 0, screw_hole_distance]) {
                screw_hole();
            }
            translate([support_width / 2, 0, inner_height - screw_hole_distance]) {
                screw_hole();
            }
        }
    }

    // Bottom right to top right.
    points = [
      [bottom_right - support_width, 0, 0], // 0
      [bottom_right, 0, 0], // 1
      [bottom_right, support_thickness, 0], // 2
      [bottom_right - support_width, support_thickness, 0], // 3
      [top_right, 0, inner_height], // 4
      [top_right + support_width, 0, inner_height], // 5
      [top_right + support_width, support_thickness, inner_height], // 6
      [top_right, support_thickness, inner_height], // 7
    ];
    faces = [
      [0,1,2,3], // Bottom
      [4,5,1,0], // Front
      [7,6,5,4], // Top
      [5,6,2,1], // Right
      [6,7,3,2], // Back
      [7,4,0,3], // Left
    ];
    difference() {
        polyhedron(points, faces);
        translate([top_right + (bottom_right - top_right) / 2, 0, inner_height / 2]) {
            screw_hole();
        }
    }
}

/* Modules */

module screw_hole() {
    translate([0, -0.001, 0]) {
        rotate([-90, 0, 0]) {
            cylinder(support_thickness + 0.002, d = screw_hole_size);
        }
    }
}

module plug() {
    center_y = groove_thickness + tablet_thickness / 2;
    plug_z = bottom_height + inner_height / 2 - angle_plug_top_height / 2;

    // Angle plug top part.
    translate([
        -0.001,
        center_y - angle_plug_thickness / 2,
        plug_z,
    ]) {
        cube([left_width + 0.002, angle_plug_thickness, angle_plug_height]);
    }

    // Angle plug bottom part.
    translate([
        angle_plug_left,
        center_y - angle_plug_thickness / 2,
        plug_z - angle_plug_bottom_height,
    ]) {
        cube([angle_plug_bottom_width, angle_plug_thickness, angle_plug_bottom_height + 0.001]);
    }

    // The cable running up to the angle plug.
    translate([
        angle_plug_left - (cable_width - angle_plug_bottom_width) / 2,
        center_y - cable_thickness / 2,
        -0.001,
    ]) {
        cube([cable_width, cable_thickness, plug_z - angle_plug_bottom_height + 0.002]);
    }

    // Room above the plug.
    translate([
        -0.001,
        center_y - angle_plug_thickness / 2,
        plug_z + angle_plug_height - 0.001,
    ]) {
        cube([angle_plug_width, angle_plug_thickness, angle_plug_top_height]);
    }

    // Angled guiding section above the plug.
    translate([
        angle_plug_width - 0.001,
        center_y - angle_plug_thickness / 2,
        plug_z + angle_plug_height + angle_plug_top_height - 0.002,
    ]) {
        rotate([0, 0, 90]) {
            prism(angle_plug_thickness, angle_plug_width, angle_plug_top_height);
        }
    }
}

module left() {
    hull() {
        translate([0, 0, bottom_height]) {
            cube([left_width, total_thickness, inner_height]);
        }
        bottomLeft();
        topLeft();
    }
}

module bottom() {
    difference() {
        hull() {
            translate([left_width, 0, 0]) {
                cube([bottom_width, total_thickness, bottom_height]);
            }
            bottomLeft();
        }
        translate([left_width, groove_thickness, bottom_height - groove_height + 0.001]) {
            cube([bottom_width + 0.001, tablet_thickness, groove_height]);
        }
        translate([left_width, 0, bottom_height + 0.001]) {
            mirror([0, 0, 1]) {
                prism(bottom_width + 0.001, groove_thickness + 0.001, groove_height);
            }
        }
    }
}

module top() {
    difference() {
        hull() {
            translate([left_width, 0, total_height - top_height]) {
                cube([top_width, total_thickness, top_height]);
            }
            topLeft();
        }
        translate([left_width, groove_thickness, total_height - top_height - 0.001]) {
            cube([top_width + 0.001, tablet_thickness, groove_height]);
        }
        translate([left_width, 0, total_height - top_height - 0.001]) {
            prism(top_width + 0.001, groove_thickness + 0.001, groove_height);
        }
    }
}

module bottomLeft() {
    translate([left_width / 2, 0, bottom_height / 2]) {
        scale([left_width, 1, bottom_height]) {
            rotate([-90, 0, 0]) {
                cylinder(total_thickness, d = 1);
            }
        }
    }
}
module topLeft() {
    translate([left_width / 2, 0, total_height - top_height / 2]) {
        scale([left_width, 1, top_height]) {
            rotate([-90, 0, 0]) {
                cylinder(total_thickness, d = 1);
            }
        }
    }
}

module prism(l, w, h) {
    polyhedron(
        points=[[0,0,0], [0,w,h], [l,w,h], [l,0,0], [0,w,0], [l,w,0]],
        faces=[
            [0,1,2,3], // Top sloping face
            [2,1,4,5], // Vertical rectangular face
            [0,3,5,4], // Bottom face
            [0,4,1], // Rear triangular face
            [3,2,5], // Front triangular face
        ]
    );
}
