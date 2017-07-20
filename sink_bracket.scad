include <MCAD/polyholes.scad>;
include <MCAD/units.scad>;

include <truncated_teardrop.scad>;

include <sink.scad>;


/*
 * A general-purpose mount for the PD Buddy Sink
 */
module sink_mount(layer_thickness=0.25*mm, height=8*mm, nut_depth=4*mm,
		cutout=0.5*mm, bolt_tolerance=0.3*mm, nut_tolerance=0.05*mm,
		board=sink_1_0) {
	w = sink_width(board);

	difference() {
		/* Body of the mount */
		cube([8*mm, w, height]);

		/* Bolt hole bottom height.  Leave one layer_thickness as a bridge. */
		bhbot = nut_depth + layer_thickness;
		/* Bolt holes */
		translate([4*mm, (w - sink_screw_spacing(board))/2, bhbot])
			polyhole(d=3*mm + bolt_tolerance, h=height - bhbot + epsilon);
		translate([4*mm, (w + sink_screw_spacing(board))/2, bhbot])
			polyhole(d=3*mm + bolt_tolerance, h=height - bhbot + epsilon);

		/* Nut holes */
		translate([4*mm, (w - sink_screw_spacing(board))/2, -epsilon])
			rotate([0, 0, 30])
			cylinder(r=6.4*mm / 2 + nut_tolerance, h=nut_depth + epsilon, $fn=6);
		translate([4*mm, (w + sink_screw_spacing(board))/2, -epsilon])
			rotate([0, 0, 30])
			cylinder(r=6.4*mm / 2 + nut_tolerance, h=nut_depth + epsilon, $fn=6);

		/* Small cutout to clear any solder bulges under the USB connector */
		translate([-epsilon, (w - sink_connector_cutout(board))/2, height - cutout])
			cube([8*mm + 2*epsilon, sink_connector_cutout(board), cutout + epsilon]);
	}
}

/*
 * A bracket for mounting the PD Buddy Sink on a panel
 */
module sink_bracket(layer_thickness=0.25*mm, height=8*mm, nut_depth=4*mm,
		cutout=0.5*mm, bolt_tolerance=0.3*mm, nut_tolerance=0.05*mm,
		board=sink_1_0) {
	w = sink_width(board);
	halfend_width = 8*mm;
	bracket_width = w + 2*halfend_width;

	mount_distance = 5*mm;

	difference() {
		union() {
			cube([8*mm, halfend_width, height]);

			translate([0, halfend_width, 0])
				sink_mount(layer_thickness=layer_thickness, height=height,
						nut_depth=nut_depth, cutout=cutout,
						bolt_tolerance=bolt_tolerance,
						nut_tolerance=nut_tolerance,
						board=board);

			translate([0, halfend_width + w, 0])
				cube([8*mm, halfend_width, height]);
		}

		/* Bolt holes */
		translate([-epsilon, mount_distance, height/2])
			truncated_teardrop(radius=(3*mm + bolt_tolerance)/2,
					length=8*mm + 2*epsilon);
		translate([-epsilon, bracket_width - mount_distance, height/2])
			truncated_teardrop(radius=(3*mm + bolt_tolerance)/2,
					length=8*mm + 2*epsilon);

		/* Nut holes */
		translate([4*mm, mount_distance, height/2])
			rotate([0, 90, 0])
			rotate([0, 0, 30])
			cylinder(r=6.4*mm / 2 + nut_tolerance, h=nut_depth + epsilon, $fn=6);
		translate([4*mm, bracket_width - mount_distance, height/2])
			rotate([0, 90, 0])
			rotate([0, 0, 30])
			cylinder(r=6.4*mm / 2 + nut_tolerance, h=nut_depth + epsilon, $fn=6);
	}
}


sink_bracket(layer_thickness=0.25);
