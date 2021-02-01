dxf = "weather-station-stand.dxf";

leg_offset = 10;
leg_room = 10;

enable_base = 0;
enable_box = 1;
enable_combine = 0;

module base() {
    // right_inner = 10
    // brace = 84
    // left_inner = 94
    /*scale([1, -1, 1])
    rotate([90, 0, 0])
    linear_extrude(height = 94) 
    import(dxf, layer = "tool");*/
    
    difference() {
        hull() {
            linear_extrude(height = 1) 
            import(dxf, layer = "b0", $fn = 180);
            linear_extrude(height = 2.5) 
            import(dxf, layer = "b1", $fn = 180);
        }
        hull() {
            translate([0, 0, 3])
            linear_extrude(height = 1) 
            import(dxf, layer = "b2", $fn = 180);
            translate([0, 0, 1])
            linear_extrude(height = 1) 
            import(dxf, layer = "b3", $fn = 180);
        }
        translate([0, 0, -2])
        linear_extrude(height = 4) 
        import(dxf, layer = "b3", $fn = 180);
    }
    rotate([90, 0, 0])
    translate([leg_room, 0, -leg_offset])
    linear_extrude(height = 2.5) 
    import(dxf, layer = "stand", $fn = 180);
    rotate([90, 0, 0])
    translate([leg_room, 0, -106.5 + leg_offset])
    linear_extrude(height = 2.5) 
    import(dxf, layer = "stand", $fn = 180);
    difference() {
        rotate([90, 0, 0])
        translate([leg_room, 0, -106.5 + leg_offset])
        linear_extrude(height = 87) 
        import(dxf, layer = "cross");
        rotate([0, 90, 0])
        translate([10, 52, 60])
        cylinder(r = 80 / 2, h = 20, $fn = 180);
        /*rotate([90, 0, 0])
        translate([leg_room, 0, -14])
        linear_extrude(height = 4) 
        import(dxf, layer = "notch");
        rotate([90, 0, 0])
        translate([leg_room, 0, -94])
        linear_extrude(height = 4) 
        import(dxf, layer = "notch");*/
    }
}

module box() {
    translate([-227.5, -50, -2.5])
    linear_extrude(height = 2.5) 
    import(dxf, layer = "box-bottom", $fn = 32);
    difference() {
        intersection() {
            difference() {
                translate([-227.5, -50, -2.5])
                linear_extrude(height = 44) 
                import(dxf, layer = "box-bottom", $fn = 32);
                translate([-227.5, -50, -6])
                linear_extrude(height = 50) 
                import(dxf, layer = "box-walls");
            }
            scale([1, -1, 1])
            rotate([90, 0, 0])
            translate([-227.5, 50, 0])
            linear_extrude(height = 110) 
            import(dxf, layer = "box-front", $fn = 128);
        }
        rotate([90, 0, 90])
        translate([-387.5, 0, -5])
        linear_extrude(height = 160) 
        import(dxf, layer = "box-side", $fn = 128);
    }
}    

if (enable_base > 0)
    base();
if (enable_box > 0)
    box();
if (enable_combine > 0) {
    base();
    translate([64, 125, 41])
    rotate([60, 0, 270])
    box();
}

