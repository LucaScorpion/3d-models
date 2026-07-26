// The dimensions of the tablet.
tablet_height = 170;
tablet_thickness = 7;

// The dimensions of the holder's top and bottom segments.
bottom_width = 169;
top_width = 100;

// The height (depth) of the groove lip
groove_height = 3;
// The thickness of the groove lip, front and back.
groove_thickness = 3;
groove_thickness_back = 1;

// The amount of material below and above the tablet in the groove.
bottom_thickness = 5;
top_thickness = 5;

// The thickness and width of the supports on the back.
support_thickness = 3;
support_width = 25;

left_width = 17;

angle_plug_height = 14;
angle_plug_thickness = 10;

/* [Hidden] */

$fn = 32;

total_thickness = support_thickness + groove_thickness_back + tablet_thickness + groove_thickness;
total_height = bottom_thickness + tablet_height + top_thickness;
inner_height = tablet_height - groove_height * 2;
top_height = groove_height + top_thickness;
bottom_height = groove_height + bottom_thickness;

// Left.
difference() {
    left();
    plug();
}

// Bottom.
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

// Top.
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

// Supports.
translate([0, total_thickness - support_thickness, bottom_height]) {
    top_right = left_width + top_width - support_width;
    bottom_right = left_width + bottom_width;

    // Straight up.
    translate([top_right - support_width, 0, 0]) {
        cube([support_width, support_thickness, inner_height]);
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
    polyhedron(points, faces);
}

/* Modules */

module plug() {
    angle_plug_y = groove_thickness + tablet_thickness / 2 - angle_plug_thickness / 2;
    translate([-0.001, angle_plug_y, bottom_height + inner_height / 2]) {
        cube([left_width + 0.002, angle_plug_thickness, angle_plug_height]);
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

module bottomLeft() {
    translate([left_width / 2, 0, bottom_height / 2]) {
        scale([left_width / 2, 1, bottom_height / 2]) {
            rotate([-90, 0, 0]) {
                cylinder(total_thickness, r = 1);
            }
        }
    }
}
module topLeft() {
    translate([left_width / 2, 0, total_height - top_height / 2]) {
        scale([left_width / 2, 1, top_height / 2]) {
            rotate([-90, 0, 0]) {
                cylinder(total_thickness, r = 1);
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
