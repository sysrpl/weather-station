$fn = 128;
dxf = "weather-station.dxf";
standoff = 3;
grill = 1.5;
grill_hole = 1;
grill_size = 15;
extend = 4;
squish = 0.5;

enable_bottom = 0;
enable_board = 0;
enable_top = 0;
enable_grill = 0;
enable_feet = 0;
enable_standoffs = 0;
enable_explode = 0;
enable_heat = 0;

module grilled(count = 10) {
    if (enable_grill > 0) {
        for (x = [0: count]) {
            hull() {
                translate([0, x * grill * 4, 0])
                sphere(grill_hole, $fn = 24);
                translate([20, x * grill * 4, 0])
                sphere(grill_hole, $fn = 24);
                translate([0, x * grill * 4 - grill_size / 2  - extend / 2, grill_size  + extend])
                sphere(grill_hole, $fn = 24);
                translate([20, x * grill * 4 - grill_size / 2 - extend / 2, grill_size + extend])
                sphere(grill_hole, $fn = 24);
            }
        }
    }
}

module feet() {
    if (enable_feet > 0) {
        color([0, 0.75, 0.5])
        translate([-24.5, 16, -3])
        scale([1, 1, squish])
        sphere(4.5, $fn = 32);
        color([0, 0.75, 0.5])
        translate([98, 16, -3])
        scale([1, 1, squish])
        sphere(4.5, $fn = 32);
        color([0, 0.75, 0.5])
        translate([98, 88, -3])
        scale([1, 1, squish])
        sphere(4.5, $fn = 32);
        color([0, 0.75, 0.5])
        translate([-24.5, 88, -3])
        scale([1, 1, squish])
        sphere(4.5, $fn = 32);
    }
}

module bottom() {
    difference() { 
        union () {
            linear_extrude(height = 1.5) 
            import(dxf, layer = "BOTTOM");
            hull() {
                linear_extrude(height = 1) 
                import(dxf, layer = "BOTTOM");
                translate([0, 0, -3])
                linear_extrude(height = 1) 
                import(dxf, layer = "BOTTOM_BEVEL");
                
            }
        }
        if (enable_standoffs > 0) {
            translate([0, 0, -2])
            color([0.2, 1, 0])
            linear_extrude(height = standoff + 3)
               import(dxf, layer = "PIN_POSTS");
        }
        feet();
        translate([0, 0, 1])
        linear_extrude(height = 26.5)
           import(dxf, layer = "HEAT_GROOVE");
    }
    difference() {
        translate([0, 0, 1.5]) {
            difference() {
                linear_extrude(height = 25)
                   import(dxf, layer = "WALL");
                
                translate([0, 20, 12.5 + standoff])
                rotate([90, 0, 0])
                linear_extrude(height = 20)
                   import(dxf, layer = "FRONT");

                translate([90, 0, 136.5 + standoff])
                rotate([0, 90, 0])
                linear_extrude(height = 20)
                   import(dxf, layer = "SIDE");
            }

            if (enable_standoffs > 0) {
                difference() {
                    union() {
                        linear_extrude(height = standoff + 0.5)
                           import(dxf, layer = "PIN_STANDS", $fn = 6);
                    }
                    translate([0, 0, -2])
                    color([0.2, 1, 0])
                    linear_extrude(height = standoff + 3)
                       import(dxf, layer = "PIN_POSTS");
                }
            }
            if (enable_board > 0) {
                translate([0, 0, standoff + 0.5])
                color([0, 0.4, 0])
                linear_extrude(height = 1.63)
                   import(dxf, layer = "BOARD_OUTLINE");
            }
        }
        translate([-40, 0, 10])
        cube([200, 200, 50]);
        translate([-40, 25, 5])
        grilled();
        translate([5, 105, 5])
        rotate([0, 0, -90])
        grilled(15);
        translate([0, 0, -0.5])
        linear_extrude(height = 27.5)
           import(dxf, layer = "HEAT_GROOVE");
    }
}

module top() {
    difference() {
        translate([0, 0, 1.5]) {
            difference() {
                linear_extrude(height = 25 + extend)
                   import(dxf, layer = "WALL_TOP");
                translate([0, 20, 12.5 + standoff])
                rotate([90, 0, 0])
                linear_extrude(height = 20)
                   import(dxf, layer = "FRONT_FIT");
                translate([90, 0, 136.5 + standoff])
                rotate([0, 90, 0])
                linear_extrude(height = 20)
                   import(dxf, layer = "SIDE");
                // round snaps
                color([0, 1, 1])
                translate([36.725 - 10, 10.5, 25.5])
                sphere(1.5, $fn = 32);
                color([0, 1, 1])
                translate([36.725 + 10, 10.5, 25.5])
                sphere(1.5, $fn = 32);
                linear_extrude(height = 26.5 + extend)
                   import(dxf, layer = "HEAT_GROOVE");
            }
        }
        translate([-40, 0, -42])
        cube([200, 200, 50]);
        linear_extrude(height = 10)
           import(dxf, layer = "WALL_BEVEL");
        color([0.5, 0.5, 0])
        translate([95.2, 10.52, 0])
        cube([10, 56.5, 25]);
        translate([-40, 25, 5])
        grilled();
        translate([5, 105, 5])
        rotate([0, 0, -90])
        grilled(15);
    }
    translate([0, 0, 1.7])
    linear_extrude(height = 26.5 + extend - 1.7)
       import(dxf, layer = "HEAT_TABS");
}

module heat() {
    difference() {
        union() {
            translate([0, 0, -0.25])
            linear_extrude(height = 26.75 + extend)
            import(dxf, layer = "HEAT");
            translate([-20.75, 68, 18])
            rotate([90, 0, 90])
            cylinder(r = 3, h = 4, $fn = 6);
            translate([-19.3, 40, 18])
            rotate([90, 0, 90])
            cylinder(r = 3, h = 2, $fn = 6);
        }
        color([1, 0, 0])
        translate([-20, 16, 0])
        rotate([0, 90, 0])
        cylinder(r = 2.75, h = 10);
        color([1, 0, 0])
        translate([-22, 68, 18])
        rotate([0, 90, 0])
        cylinder(r = 1, h = 5.2);
        color([1, 0, 0])
        translate([-21, 40, 18])
        rotate([0, 90, 0])
        cylinder(r = 1, h = 4.2);
    }
    
}

module lid() {
    difference() {
        intersection() {
            linear_extrude(height = 5) 
            import(dxf, layer = "LID");
            translate([0, 115, 12])
            rotate([90, 0, 0])
            linear_extrude(height = 120) 
            import(dxf, layer = "LID_FRONT", $fn = 3600);
        }
        translate([0, 0, -2])
        linear_extrude(height = 10) 
        import(dxf, layer = "LCD");
    }
    difference() {
        intersection() {
            linear_extrude(height = 5) 
            import(dxf, layer = "LID_RAISE", $fn = 48);
            translate([0, 115, 13])
            rotate([90, 0, 0])
            linear_extrude(height = 120) 
            import(dxf, layer = "LID_FRONT", $fn = 3600);
        }
    }
}

lid();

if (enable_bottom > 0)
    bottom();
if (enable_top > 0) {
    if (enable_explode > 0)
        translate([0, 0, 20])
        top();
    if (enable_explode == 0)
        translate([230, 0, 26.5])
        rotate([0, 180, 0])        
        top();
}

if (enable_heat > 0) {
    if (enable_explode > 0)
        translate([0, 0, 60])
        heat();
    if (enable_explode == 0)
        translate([140, -10, 19.35])
        rotate([90, 90, 0])
        heat();
}