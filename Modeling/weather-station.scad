$fn = 128;
dxf = "weather-station.dxf";
standoff = 3;
grill = 1.5;
grill_hole = 1;
grill_size = 15;
grill_slant = 0.8;
extend = 4;
squish = 0.125;
feet_offset = 5;
mid_x = 36.225;

enable_bottom = 1;
enable_board = 0;
enable_grill = 1;
enable_feet = 1;
enable_lid = 0;
enable_standoffs = 1;
enable_explode = 0;
enable_heat = 0;
enable_lcd = 0;
enable_align = 0;

module align() {
    linear_extrude(height = 15) 
    import(dxf, layer = "LCD_ALIGN");
}

module gpio() {
    translate([mid_x + 5, 110, 29])
    rotate([90, 0, 0])
    hull() {
        translate([-28, 0, 0])
        cylinder(r = 3, h = 20);
        translate([28, 0, 0])
        cylinder(r = 3, h = 20);
    }
}

module grilled(count = 10, deep = -10) {
    if (enable_grill > 0) {
        for (x = [0: count]) {
            hull() {
                translate([0, x * grill * 4, deep])
                sphere(grill_hole, $fn = 24);
                translate([13, x * grill * 4, deep])
                sphere(grill_hole, $fn = 24);
                translate([0, x * grill * 4 - grill_size / 2  - extend / 2, (grill_size  + extend) * grill_slant])
                sphere(grill_hole, $fn = 24);
                translate([13, x * grill * 4 - grill_size / 2 - extend / 2, (grill_size + extend) * grill_slant])
                sphere(grill_hole, $fn = 24);
            }
        }
    }
}

module feet() {
    if (enable_feet > 0) {
        color([0, 0.75, 0.5])
        translate([-24.5 + feet_offset, 16 + feet_offset, -0.5])
        scale([1, 1, squish])
        sphere(4.5, $fn = 32);
        color([0, 0.75, 0.5])
        translate([98 - feet_offset, 16 + feet_offset, -0.5])
        scale([1, 1, squish])
        sphere(4.5, $fn = 32);
        color([0, 0.75, 0.5])
        translate([98 - feet_offset, 88 - feet_offset, -0.5])
        scale([1, 1, squish])
        sphere(4.5, $fn = 32);
        color([0, 0.75, 0.5])
        translate([-24.5 + feet_offset, 88 - feet_offset, -0.5])
        scale([1, 1, squish])
        sphere(4.5, $fn = 32);
    }
}

module bottom() {
    difference() { 
        union () {
            translate([0, 0, 0.5])
            hull() {
                linear_extrude(height = 1) 
                import(dxf, layer = "BOTTOM");
                translate([0, 0, -1])
                linear_extrude(height = 1) 
                import(dxf, layer = "BOTTOM_BEVEL");
                
            }
            translate([0, 0, 1.5])
                linear_extrude(height = 27.5)
                   import(dxf, layer = "WALL");
        }
        if (enable_standoffs > 0) {
            translate([0, 0, 0.5])
            color([0.2, 1, 0])
            linear_extrude(height = standoff + 3)
               import(dxf, layer = "PIN_POSTS");
        }
        gpio();
        feet();
        translate([0, 0, 1])
        linear_extrude(height = 26.5)
           import(dxf, layer = "HEAT_GROOVE");
        translate([-42, 27, 5])
        grilled(10);
        translate([5, 105, 5])
        rotate([0, 0, -90])
        grilled(15);
        translate([0, 0, 1.5]) {
                translate([0, 20, 12.5 + standoff])
                rotate([90, 0, 0])
                linear_extrude(height = 20)
                   import(dxf, layer = "FRONT");

                translate([90, 0, 136.5 + standoff])
                rotate([0, 90, 0])
                linear_extrude(height = 20)
                   import(dxf, layer = "SIDE");
        }
        // round snaps
        color([0, 1, 1])
        translate([36.225 - 10, 10.5, 25.0])
        sphere(1.75, $fn = 32);
        color([0, 1, 1])
        translate([36.225 + 10, 10.5, 25.0])
        sphere(1.75, $fn = 32);
    }
    difference() {
        translate([0, 0, 1.5]) {
            difference() {
                
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
    }
    translate([0, 0, 1.5])
    linear_extrude(height = 25.2 + extend - 1.7)
       import(dxf, layer = "HEAT_TABS");
    
}

module heat() {
    slide = 10;
    difference() {
        union() {
            translate([0, 0, -0.25])
            linear_extrude(height = 26.75 + extend)
            import(dxf, layer = "HEAT");
            translate([-20.75, 68 + slide, (26.75 + extend) / 2])
            rotate([90, 0, 90])
            cylinder(r = 3, h = 4, $fn = 6);
            translate([-19.3, 40 + slide, (26.75 + extend) / 2])
            rotate([90, 0, 90])
            cylinder(r = 3, h = 2, $fn = 6);
        }
        color([1, 0, 0])
        translate([-20, 16, 0])
        rotate([0, 90, 0])
        cylinder(r = 2.75, h = 10);
        color([1, 0, 0])
        translate([-22, 68 + slide, (26.75 + extend) / 2])
        rotate([0, 90, 0])
        cylinder(r = 1, h = 5.2);
        color([1, 0, 0])
        translate([-21, 40 + slide, (26.75 + extend) / 2])
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

module lcd() {
    scale([1, 1, -1])
    union() {
        difference() {
            union() {
                linear_extrude(height = 2) 
                import(dxf, layer = "LID_BACK");
                linear_extrude(height = 4.5)
                import(dxf, layer = "LID_STANDS", $fn = 6);
            }
            translate([0, 0, -1])
            linear_extrude(height = 8)
            import(dxf, layer = "LID_POSTS");
        }
        linear_extrude(height = 7)
        import(dxf, layer = "LID_TABS");
        
        // round snaps
        color([0, 1, 1])
        translate([36.225 - 10, 10.5, 3.5])
        sphere(1.7, $fn = 32);
        color([0, 1, 1])
        translate([36.225 + 10, 10.5, 3.5])
        sphere(1.7, $fn = 32);
    }
}


if (enable_bottom > 0)
    bottom();

if (enable_heat > 0) {
    if (enable_explode > 0)
        translate([0, 0, 34])
        heat();
    if (enable_explode == 0)
        translate([140, -10, 19.35])
        rotate([90, 90, 0])
        heat();
}

if (enable_lid > 0) {
    if (enable_explode > 0)
        translate([0, 0, 75])
        lid();
    if (enable_explode == 0)
        lid();
}

if (enable_lcd > 0) {
    if (enable_explode > 0)
        translate([0, 0, 75])
        lcd();
    if (enable_explode == 0)
        rotate([0, 180, 0])
        lcd();
}


if (enable_align > 0) {
    align();
}
