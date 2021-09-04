# TownSCAD

This is an OpenSCAD Library for building towns. It is heavily inspired by
Townscaper, but you have to do program everything. And it is more like a
puzzle, since there's no automagic that configures elements correctly.
On the other hand that also gives much more control.
Goal is that the resulting scenes are 3D printable with FDM printers

## What do we have so far?
* Walls that can be coloured and can have a window or a door
* Basic Floors with an optional ridge (like a railing just simple)
* Basic Roofs with joints and ends (WIP)

## What is on the roadmap?
* Documentation
* More Spires (pretty easy roofs)
* More Roof-Types (incl. adapters)
* More Windows and Doors
* Features that can be put on Floors
* Gardens

## Postprocessing in Blender
The resulting diorama will look pretty regular and boring. To bring it a bit
to life, you can write to STL in OpenSCAD and postprocess in Blender. 
Import the STL, scale it down, put a deformation lattice over it, cut the Mesh
as needed and use the lattice to deform it to your liking. This should bring a
bit of irregularity and thus life to the model.

