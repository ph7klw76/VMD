# VMD script to visualize molecular orbitals from a Molden file

# Load the Molden file and capture the molecule ID
set molid [mol new cis-111.molden type molden]

# Set display properties
color Display Background white
display projection Orthographic
# Turn off axes display

# Display the molecule structure using bond drawing method and type coloring method
mol representation Bonds 0.1 15
mol color Type
mol addrep $molid
mol delrep 0 $molid
# Function to visualize and save snapshot for a given orbital index
proc visualize_orbital {molid index} {
    
    # Display the isosurface for the orbital with positive isovalue and ColorID 0
    set isoval 0.03
    mol representation Orbital $isoval $index 0 0 0.075 1 6 0 0 1
    mol color ColorID 0
    mol addrep $molid

    # Display the isosurface for the orbital with negative isovalue and ColorID 1
    set isoval -0.03
    mol representation Orbital $isoval $index 0 0 0.075 1 6 0 0 1
    mol color ColorID 1
    mol addrep $molid

    # Adjust the view
    rotate x by 0
    rotate y by 0
    rotate z by 0
    axes location off
    # Set the display window to full size
    display resize 1920 1080

    # Determine the snapshot filename
    if {$index == 207} {
        set filename "HOMO.bmp"
    } else {
        set n [expr 207 - $index]
        set filename "HOMO-$n.bmp"
    }

    # Save the visualization to a BMP image
    render snapshot $filename
    # Wait for 2 seconds
    after 2000
    # Remove the added representations to reset for the next orbital
    mol delrep 1 $molid
    after 2000
    mol delrep 1 $molid
}

# Loop through orbital indices from 414 to 396 and visualize each
for {set index 207} {$index >= 187} {incr index -1} {
    visualize_orbital $molid $index
}
