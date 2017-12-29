include <MCAD/polyholes.scad>;
include <MCAD/units.scad>;

include <sink.scad>;


/*
 * Mill-Max Series 854 cutout
 *
 * Cutout is centered on the first pin, with the other pins along the positive
 * X axis.
 */
module mill_max_854_cutout(pins, h, clearance) {
	translate([-0.025*inch - 0.115*inch/2 - clearance, -0.0435*inch - clearance, 0])
		cube([pins*.05*inch + 0.115*inch + 2*clearance, .087*inch + 2*clearance, h]);
}

/*
 * 3D-printed part of a PD Buddy programming jig
 */
module programming_jig(board=sink_1_0, layer_thickness=0.4*mm,
		extrusion_width=0.6*mm, clearance=0.35*mm) {
	/* It would be ridiculous to try to cram enough information into the board
	 * objects to properly parameterize this, so the board is only used to set
	 * which object we're making. */
	if (board == sink_0_3 || board == sink_1_0) {
		/* Pin dimensions */
		pwr_bottom = 0.212*inch;
		pwr_stroke = 0.090*inch;
		pwr_mid = pwr_bottom + pwr_stroke/2;
		swd_bottom = 0.212*inch;
		swd_stroke = 0.055*inch;
		swd_mid = swd_bottom + swd_stroke/2;

		/* The ideal height for the pin jig: the average of the mid-stroke
		 * heights for both types of pin */
		ideal_board_height = (pwr_mid + swd_mid)/2;

		/* The height of the pin jig, rounded to the nearest layer_thickness */
		board_height = round(ideal_board_height / layer_thickness) * layer_thickness;

		echo(ideal_board_height=ideal_board_height, board_height=board_height);
		echo(pwr_percent=100-(board_height-pwr_bottom)*100/pwr_stroke);
		echo(swd_percent=100-(board_height-swd_bottom)*100/swd_stroke);

		/* The board's ideal location */
		/*
#		translate([0, 0, ideal_board_height])
			sink(board);
			*/

		/* The board's real location */
		/*
		translate([0, 0, board_height])
			sink(board);
			*/

		/* Lip around the board */
		translate([-2*extrusion_width - clearance, -2*extrusion_width - clearance, board_height])
			cube([4*extrusion_width + 2*clearance + sink_length(board), 2*extrusion_width, sink_thickness(board)]);
		translate([-2*extrusion_width - clearance, sink_width(board) + clearance, board_height])
			cube([4*extrusion_width + 2*clearance + sink_length(board), 2*extrusion_width, sink_thickness(board)]);
		translate([-2*extrusion_width - clearance, -clearance, board_height])
			cube([2*extrusion_width, 2*clearance + sink_width(board), sink_thickness(board)]);
		translate([sink_length(board) + clearance, -clearance, board_height])
			cube([2*extrusion_width, 2*clearance + sink_width(board), sink_thickness(board)]);

		/* Box under the board
		 * Every cutout is extended by clearance in X and Y.  Since the board
		 * can shift by that much, everything on it can too. */
		difference() {
			translate([-2*extrusion_width - clearance, -2*extrusion_width - clearance, 0])
				cube([4*extrusion_width + 2*clearance + sink_length(board),
						4*extrusion_width + 2*clearance + sink_width(board),
						board_height]);

			/* Cutout for the output connector */
			hull() {
				translate([26.5*mm, 11*mm, -epsilon])
					polyhole(d=2*1.75*mm + 2*clearance, h=board_height + 2*epsilon);
				translate([26.5*mm, 14*mm, -epsilon])
					polyhole(d=2*1.75*mm + 2*clearance, h=board_height + 2*epsilon);
			}

			/* Cutout under the USB connector */
			translate([-clearance, sink_width(board)/2 - sink_connector_cutout(board)/2 - clearance, board_height - 2*layer_thickness])
				cube([2*clearance + sink_connector(board)[0] - sink_connector_extend(board), sink_connector_cutout(board) + 2*clearance, 2*layer_thickness + epsilon]);

			/* Cutout for the switch */
			switch_cutout_height = ceil((1.4*mm + layer_thickness)/layer_thickness)*layer_thickness;
			translate([12*mm - clearance, 3.5*mm - clearance, board_height - switch_cutout_height])
				cube([9*mm + 2*clearance, 6*mm + 2*clearance, switch_cutout_height + epsilon]);

			/* Cutout for the power pins */
			translate([11*mm - 0.05*inch - clearance, 2*mm - 0.05*inch - clearance, -epsilon])
				cube([0.2*inch + 2*clearance, 0.1*inch + 2*clearance, board_height + 2*epsilon]);

			/* Cutout to remove the thin piece between the switch and power
			 * pins */
			translate([12*mm - clearance, 2*mm + 0.05*inch - epsilon, board_height - switch_cutout_height])
				cube([-1*mm + 0.15*inch + 2*clearance, 1.5*mm - 0.05*inch + 2*epsilon, switch_cutout_height + epsilon]);

			/* Cutouts for the SWD pins */
			translate([23.55*mm, 17.96*mm, -epsilon])
				rotate([0, 0, 90])
				mill_max_854_cutout(pins=5, h=board_height + 2*epsilon, clearance=clearance);
			translate([27.45*mm, 17.96*mm, -epsilon])
				rotate([0, 0, 90])
				mill_max_854_cutout(pins=5, h=board_height + 2*epsilon, clearance=clearance);
		}

		/* Mounting holes */
		difference() {
			translate([sink_length(board) + clearance + 2*extrusion_width,
					-clearance - 2*extrusion_width,
					0])
				cube([8*mm, 8.5*mm, board_height + sink_thickness(board)]);

			translate([35*mm, 3*mm, -epsilon])
				polyhole(d=3.3*mm, h=board_height + sink_thickness(board) + 2*epsilon);
		}

		difference() {
			translate([-clearance - 2*extrusion_width,
					sink_width(board) + clearance + 2*extrusion_width,
					0])
				rotate([0, 0, 180])
				cube([8*mm, 8.5*mm, board_height + sink_thickness(board)]);

			translate([-5*mm, 22*mm, -epsilon])
				polyhole(d=3.3*mm, h=board_height + sink_thickness(board) + 2*epsilon);
		}

		echo(total_height=board_height + sink_thickness(board));
	}
}

programming_jig();
