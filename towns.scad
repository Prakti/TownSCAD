include <BOSL/constants.scad>
use <BOSL/transforms.scad>
use <BOSL/shapes.scad>

//##################################
// Utility Geometry
//##################################

module arc(width, height, depth) {
  render() {
    cube([width, depth, height], center=true);
    zmove(height/2) xrot(90) cylinder(depth, width/2, width/2, center=true, $fn=32);
  }
}

module window_frame(width, height, depth) {
  render () {
    difference () {
      cube([width, depth, height]);
      translate([1,-1, 1]) cube([width-2, depth+2, height-2]);
    }
  }
}

module window_gen(width, height, xdiv=1, ydiv=1, xoffset=0, zoffset=0, mask=false) {
  if (mask) {
    translate([- width / 2 + xoffset, -1, 7 + zoffset]) {
      cube([width, 8, height]);
    }
  } else {
    translate([- width / 2 + xoffset, 1, 7 + zoffset]) {
      color("Peru") {
        window_frame(width, height, 1);
        if (xdiv > 1) {
          for (x = [1:xdiv - 1]) {
            translate([width / xdiv * x - 0.25, 0.25, 0.5]) cube([0.5, 0.5, height -1]);
          }
        }
        if (ydiv > 1) {
          for (y = [1:ydiv - 1]) {
             translate([0.5, 0.25, height / ydiv * y - 0.25]) cube([width - 1, 0.5, 0.5]);
          }
        }
      }
    }
  }
}

//##################################
// Modules of Wall Features
//##################################

module door1 (mask=false, wall_color="ivory") {
  if (mask) {
    translate([0, 1, 6.9]) arc(8, 12, 6);
  } else {
    translate([0, 1, 7]) {
      color(wall_color) {
        difference () {
          arc(8, 12, 4);
          zmove(-0.1) arc(6, 12, 5);
        }
      }
      color("Peru") ymove(1) arc(7, 12, 2);
    }
    translate([-4.5, -2, 0]) {
      color("gray") cube([9, 4, 1.1]);
    }
    translate([2, 1.1, 7.7]) {
      color("gray") sphere(0.5, $fn=12);
    }
  }
}

module window1 (mask=false, wall_color="ivory") {
  window_gen(7, 9, xdiv=2, ydiv=2, xoffset=1, zoffset=1, mask=mask);
}

module window2 (mask=false, wall_color="ivory") {
  window_gen(11, 10, xdiv=3, ydiv=2, xoffset=-0.5, zoffset=-1, mask=mask);
}

//##################################
// Wall Definition
//##################################

// Central Wall Feature dispatch
module wall_feature(type="", wall_color="ivory") {
  if (type == "door1") {
    door1(wall_color=wall_color);
  } else if (type == "window1") {
    window1(wall_color=wall_color);
  } else if (type == "window2") {
    window2(wall_color=wall_color);
  } 
}

// Central Wall Cutmask dispatch
module wall_cutmask(type="") {
  if (type == "door1") {
   door1(true); 
  } else if (type == "window1") {
    window1(true);
  } else if (type == "window2") {
    window2(true);
  }
}

// South side Wall
module wall_segment_s(pos, height) {  
  s1 = [0, 0];
  s2 = [20, 0];
  s3 = [20, 2]; 
  s4 = [0, 2];
  linear_extrude(height) polygon([s1, s2, s3, s4, s1]);
}

module wall_s(pos, wall_color="ivory", features=[]) {
  translate([pos.x * 20, pos.y * 20, pos.z * 22]) {
    color(wall_color) {
      difference () {
        wall_segment_s(pos, 22);
        union () {
          for (feature=features) {
            xmove(10)  wall_cutmask(feature);
          }
        }
      }  
    }
    for (feature=features) {
      xmove(10) wall_feature(feature, wall_color);
    }
  }
}

// North Side Wall
module wall_segment_n(pos, height) {
  n1 = [0, 20];  
  n2 = [20, 20]; 
  n3 = [20, 18];
  n4 = [0, 18];  
  linear_extrude(height) polygon([n1, n2, n3, n4, n1]);
}
 
module wall_n(pos, wall_color="ivory", features=[]) {
  translate([pos.x * 20, pos.y * 20, pos.z * 22]) {
    color(wall_color) {
      difference () {
         wall_segment_n(pos, 22);
        union () {
          for (feature=features) {
            translate([10, 20, 0]) zrot(180) wall_cutmask(feature);
          }
        }
      }
    }
    for (feature=features) {
      translate([10, 20, 0]) zrot(180) wall_feature(feature, wall_color);
    }
  }
}

// West Side Wall
module wall_segment_w(height) {
  w1 = [0,0];
  w2 = [0,20];  
  w3 = [2, 20]; 
  w4 = [2, 0];
  linear_extrude(height) polygon([w1, w2, w3, w4, w1]);
}

module wall_w(pos, wall_color="ivory", features=[]) {
  translate([pos.x * 20, pos.y * 20, pos.z * 22]) {
    color(wall_color) {
      difference () {
        wall_segment_w(22);
        union () {
          for (feature=features) {
            translate([0, 10, 0]) zrot(-90) wall_cutmask(feature);
          }
        }
      }
    }
    for (feature=features) {
      translate([0, 10, 0]) zrot(-90) wall_feature(feature, wall_color);
    }
  }
}

// East Side Wall
module wall_segment_e(pos, height) {
  e1 = [20, 0];
  e2 = [20, 20];
  e3 = [18, 20];
  e4 = [18, 0];
  linear_extrude(height) polygon([e1, e2, e3, e4, e1]);
}

module wall_e(pos, wall_color="ivory", features=[]) {
  translate([pos.x * 20, pos.y * 20, pos.z * 22]) {
    color(wall_color) {
      difference () {
        wall_segment_e(pos, 22);
        union () {
          for (feature=features) {
            translate([20, 10, 0]) zrot(90) wall_cutmask(feature);
          }
        }
      }
    }
    for (feature=features) {
      translate([20, 10, 0]) zrot(90) wall_feature(feature, wall_color);
    }
  }
}

//##################################
// Tower Roof Definition
//##################################

module tower_roof1(pos) {
  module roof_solid() {   
      prismoid(size1=[24,24], size2=[0,0], h=15);
      zmove(4) prismoid(size1=[17,17], size2=[0,0], h=20);
  }
    
  translate([pos.x * 20 + 10, pos.y * 20 + 10, pos.z * 22 - 1]) {
    difference () {
      roof_solid();
      zmove(-3) roof_solid();
    }
  }
}

//##################################
// Saddle Roof Definition
//##################################

module prism(width, depth, height, direction, zoffset=0, overlap=[0,0]) {
  _width = width + 2 * overlap.x;
  _depth = depth + 2 * overlap.y;
  translate([width / 2, depth / 2, zoffset]) {
    if (direction == "we") {
      prismoid(size1=[_width, _depth], size2=[_width, 0], h=height);
    } else {
      prismoid(size1=[_width, _depth], size2=[0, _depth], h=height);
    }
  }
}

// Basic Prism for West-East direction
module prism_we(width, depth, height, zoffset=0, overlap=[0,0]) {
  prism(width, depth, height, "we", zoffset, overlap);
}

// Basic Prism for North-South direction
module prism_ns(width, depth, height, zoffset=0, overlap=[0,0]) {
  prism(width, depth, height, "ns", zoffset, overlap);
}

module saddle_roof(start, end, zlevel, direction, height=20) {
  width = (end.x - start.x + 1) * 20;
  depth = (end.y - start.y + 1) * 20;
  xpos = start.x * 20 - width / 2;
  ypos = start.y * 20 - depth / 2;
  
  _overlap = direction == "we" ? [0,2] : [2,0];

  translate([start.x * 20, start.y * 20, zlevel * 22 -1]) {
    render () {
      difference() {
        prism(width, depth, height, direction, overlap=_overlap);
        prism(width, depth, height, direction, -3, overlap=[2,2]);
      }    
    }
  }
}

module saddle_roof_end(pos, width, direction, side, height=20, wall_color="ivory") {
  start_we = [pos.x, pos.y + width - 1];
  end_we= [pos.x - 0.9, pos.y + width - 1];
  
  start_ns = [pos.x + width - 1, pos.y];
  end_ns= [pos.x + width - 1, pos.y - 0.9];
  
  module _wall () {
    if (direction == "we") {
      if (side == "w") {
        wall_segment_w(height);
      } else {
        wall_segment_e(height);
      }
    } else {
      if (side == "s") {
        wall_segment_s(height);
      } else {
        wall_segment_n(height);
      }
    }
  }
  
  module _prism () {
    if (direction == "we") {
      prism(20, width * 20, height, direction, -3, overlap=[2,2]);
    } else {
      prism(width * 20, 20, height, direction, -3, overlap=[2,2]);
    }
  }
  
  translate([pos.x * 20, pos.y * 20, pos.z * 22]) {
    color(wall_color) render() {
      intersection () {
        _wall();
        _prism();
      }
    }
  }
  
  if (direction == "we") {
    if (side == "w") {
      xmove(-2) saddle_roof(start_we, end_we, pos.z, direction, height); 
    } else {
      xmove(20) saddle_roof(start_we, end_we, pos.z, direction, height); 
    }
  } else {
    if (side == "s") {
      ymove(-2) saddle_roof(start_ns, end_ns, pos.z, direction, height); 
    } else {
      ymove(20) saddle_roof(start_ns, end_ns, pos.z, direction, height); 
    }
  }
}

// Saddle to Saddle Roof Adapter Direction
module saddle_roof_join(start, end, zlevel, direction, side, height=20) {
  w_factor = direction == "we" ? 10 : 20;
  d_factor = direction == "ns" ? 10 : 20;
  width = (end.x - start.x + 1) * w_factor;
  depth = (end.y - start.y + 1) * d_factor;
  xpos = start.x * 20 - width / 2;
  ypos = start.y * 20 - depth / 2;
  _overlap = direction == "we" ? [0,2] : [2,0];
  
  module adapter() {
    render () {
      difference() {
        prism(width, depth, height, direction, overlap=_overlap);
        prism(width, depth, height, direction, -3, overlap=[2,2]);
        if (direction == "we") {
          prism(width * 2, depth, height, "ns", -3, overlap=[2,2]);
        } else {
          prism(width, depth * 2, height, "we", -3, overlap=[2,2]);
        }
      }    
    }
  }

  translate([start.x * 20, start.y * 20, zlevel * 22 -1]) {
    if (direction == "we") {
      if(side == "w") {
        adapter();
      } else {
        xmove(width * 2) mirror([1,0,0]) adapter();
      }
    } else {
      if (side == "s") {
        adapter();
      } else {
        ymove(depth * 2) mirror([0,1,0]) adapter();
      }
    }
  }
}

//##################################
// Floor Definition
//##################################

module floor1(start, end, zlevel, overlap=0, ridge=[false, false, false, false]) {
  width = (end.x - start.x + 1) * 20 + 2 * overlap;
  depth = (end.y - start.y + 1) * 20 + 2 * overlap;
  xpos = start.x * 20 - overlap;
  ypos = start.y * 20 - overlap;
  translate([xpos, ypos, zlevel * 22 - 2.2]) {
    color("gray") cube([width, depth, 2.3]);
    zmove(0.9) {
      if (ridge[0]) {
        // North
        color("gray") xmove(overlap/2) ymove(overlap/2) cube([width - overlap, 1, 6]);
      }
      if (ridge[1]) {
        // East
        color("gray") xmove(width - 1 - overlap/2) ymove(overlap/2) cube([1 ,depth - overlap, 6]);
      }
      if (ridge[2]) {
        // South
        color("gray") xmove(overlap/2) ymove(depth - 1 - overlap/2) cube([width - overlap, 1, 6]);
      }
      if (ridge[3]) {
        // West
        color("gray") xmove(overlap/2) ymove(overlap/2) cube([1 ,depth - overlap, 6]);
      }
    }
  }
}

//##################################
// Test Driving this Shit!
//##################################

floor1([-1, -2], [3, 2], 0);

// Ground Floor
wall_w([0,0,0], features=["window1"], wall_color="PaleGreen");
wall_s([0,0,0], features=["window1"], wall_color="PaleGreen");
wall_s([1,-1,0], features=["door1"], wall_color="PaleGreen");
wall_w([1,-1,0], features=["window1"], wall_color="PaleGreen");
wall_e([1,-1,0], features=["window1"], wall_color="PaleGreen");
wall_s([2,0,0], features=["window1"], wall_color="PaleGreen");
wall_s([3,0,0], features=["window1"], wall_color="PaleGreen");
wall_n([0,0,0], features=["window2"], wall_color="PaleGreen");
wall_n([1,0,0], features=["window1"], wall_color="PaleGreen");
wall_n([2,1,0], features=["window1"], wall_color="PaleGreen");
wall_w([2,1,0], features=["door1"], wall_color="PaleGreen");
wall_e([2,1,0], features=["door1"], wall_color="PaleGreen");
wall_n([3,0,0], features=["window1"], wall_color="PaleGreen");
wall_e([3,0,0], features=["window1"], wall_color="PaleGreen");

// Second Floor
wall_w([0,0,1], features=["window1"], wall_color="PaleGreen");
wall_s([0,0,1], features=["window1"], wall_color="PaleGreen");
wall_s([1,-1,1], features=["window1"], wall_color="PaleGreen");
wall_w([1,-1,1], features=["window1"], wall_color="PaleGreen");
wall_e([1,-1,1], features=["window1"], wall_color="PaleGreen");
wall_s([2,0,1], features=["window1"], wall_color="PaleGreen");
wall_s([3,0,1], features=["window1"], wall_color="PaleGreen");
wall_n([0,0,1], features=["window2"], wall_color="PaleGreen");
wall_n([1,0,1], features=["window1"], wall_color="PaleGreen");
wall_n([2,1,1], features=["window1"], wall_color="PaleGreen");
wall_w([2,1,1], features=["window1"], wall_color="PaleGreen");
wall_e([2,1,1], features=["window1"], wall_color="PaleGreen");
wall_n([3,0,1], features=["window1"], wall_color="PaleGreen");
wall_e([3,0,1], features=["window1"], wall_color="PaleGreen");

// Roof 
saddle_roof([0, 0], [3, 0], 2, "we");
saddle_roof_end([0,0,2], 1, "we", "w", wall_color="PaleGreen");
saddle_roof_end([3,0,2], 1, "we", "e", wall_color="PaleGreen");

// Southern Extension
saddle_roof_join([1, 0], [1, 0], 2, "ns", "s");
saddle_roof([1, -1], [1, -1], 2, "ns");
saddle_roof_end([1,-1,2], 1, "ns", "s", wall_color="PaleGreen"); 

// Northern Extension
saddle_roof_join([2, 0], [2, 0], 2, "ns", "n");
saddle_roof([2, 1], [2, 1], 2, "ns");
saddle_roof_end([2,1,2], 1, "ns", "n", wall_color="PaleGreen"); 



// Tower comes here
floor1([4, -1], [6, 1], 0);


wall_s([5,0,0], features=["door1"], wall_color="MediumTurquoise");
wall_n([5,0,0], features=["window1"], wall_color="MediumTurquoise");
wall_w([5,0,0], features=["window1"], wall_color="MediumTurquoise");
wall_e([5,0,0], features=["window1"], wall_color="MediumTurquoise");

wall_s([5,0,1], features=["window1"], wall_color="MediumTurquoise");
wall_n([5,0,1], features=["window1"], wall_color="MediumTurquoise");
wall_w([5,0,1], features=["window1"], wall_color="MediumTurquoise");
wall_e([5,0,1], features=["window1"], wall_color="MediumTurquoise");

wall_s([5,0,1], features=["window1"], wall_color="MediumTurquoise");
wall_n([5,0,1], features=["window1"], wall_color="MediumTurquoise");
wall_w([5,0,1], features=["window1"], wall_color="MediumTurquoise");
wall_e([5,0,1], features=["window1"], wall_color="MediumTurquoise");

wall_s([5,0,2], features=["window1"], wall_color="MediumTurquoise");
wall_n([5,0,2], features=["window1"], wall_color="MediumTurquoise");
wall_w([5,0,2], features=["window1"], wall_color="MediumTurquoise");
wall_e([5,0,2], features=["window1"], wall_color="MediumTurquoise");

wall_s([5,0,3], features=["window1"], wall_color="MediumTurquoise");
wall_n([5,0,3], features=["window1"], wall_color="MediumTurquoise");
wall_w([5,0,3], features=["window1"], wall_color="MediumTurquoise");
wall_e([5,0,3], features=["window1"], wall_color="MediumTurquoise");

tower_roof1([5,0,4]);
