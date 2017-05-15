include <MCAD/polyholes.scad>;
include <MCAD/units.scad>;


usb_conn_amphenol = [10.4*mm, 9.4*mm, 3.4*mm];

sink_0_1 = [26*mm, 49*mm, 0.8*mm, 1*mm, 18*mm, 4*mm, 10*mm, 0.5*mm,
		 usb_conn_amphenol];
sink_0_2 = [26*mm, 48*mm, 0.8*mm, 1*mm, 18*mm, 4*mm, 10*mm, 1.25*mm,
		 usb_conn_amphenol];
sink_0_3 = [25*mm, 30*mm, 1.6*mm, 1*mm, 17*mm, 4*mm, 10*mm, 1.25*mm,
		 usb_conn_amphenol];

function sink_width(board) = board[0];
function sink_length(board) = board[1];
function sink_thickness(board) = board[2];
function sink_corner_radius(board) = board[3];
function sink_screw_spacing(board) = board[4];
function sink_screw_distance(board) = board[5];
function sink_connector_cutout(board) = board[6];
function sink_connector_extend(board) = board[7];
function sink_connector(board) = board[8];

/*
 * A simple representation of a PD Buddy Sink circuit board
 */
module sink(board=sink_0_3, board_color="indigo", copper_color="gold",
		connector_color="silver") {
	difference() {
		color(board_color)
			hull() {
				for (x = [sink_corner_radius(board),
						sink_length(board) - sink_corner_radius(board)]) {
					for (y = [sink_corner_radius(board),
							sink_width(board) - sink_corner_radius(board)]) {
						translate([x, y, 0])
							cylinder(r=sink_corner_radius(board),
									h=sink_thickness(board),
									$fn=($fn<3) ? 8 : ceil($fn/4)*4);
					}
				}
			}

		color(copper_color)
			for (y = [-1, 1]) {
				translate([sink_screw_distance(board),
						sink_width(board)/2 + y*sink_screw_spacing(board)/2,
						-epsilon])
					polyhole(d=3.5, h=sink_thickness(board) + 2*epsilon);
			}
	}

	color(connector_color)
		translate([-sink_connector_extend(board),
				sink_width(board)/2 - sink_connector(board)[1]/2,
				sink_thickness(board)])
		cube(sink_connector(board));
}
