bottom_width = 200;
top_width = 100;
inner_height = 150;
thickness = 7;
back_thickness = 3;
back_width = 25;
side_height = 10;

/* [Hidden] */

depth = thickness + back_thickness;
top_left = bottom_width - top_width + 10;

// Bottom.
cube([bottom_width, depth, side_height]);

// Right.
translate([bottom_width, 0, 0]) {
    cube([10, depth, inner_height]);
}

// Top.
translate([top_left, 0, inner_height]) {
    cube([top_width, depth, side_height]);
}

// Back.
translate([0, thickness, side_height]) {
    // Straight up.
    translate([top_left + back_width, 0, 0]) {
        cube([back_width, back_thickness, inner_height - side_height]);
    }
    
    // Bottom left to top left.
    points = [
      [  0,  0,  0 ], // 0
      [ back_width,  0,  0 ], // 1
      [ back_width,  back_thickness,  0 ], // 2
      [ 0,  back_thickness,  0 ], // 3
      [ top_left,  0,  inner_height - side_height ], // 4
      [ top_left + back_width,  0,  inner_height - side_height ], // 5
      [ top_left + back_width,  back_thickness,  inner_height - side_height ], // 6
      [ top_left,  back_thickness,  inner_height - side_height ], // 7
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
